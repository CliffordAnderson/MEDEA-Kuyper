xquery version "3.1";

declare namespace xbrl = "http://www.xbrl.org/2003/instance";
declare namespace link = "http://www.xbrl.org/2003/linkbase";
declare namespace xlink = "http://www.w3.org/1999/xlink";
declare namespace kranten="http://library.vanderbilt.edu/xbrl/dutch-papers";

declare function local:get-subscribers($xbrl as element()) as xs:integer*
{
  let $abonnementen := $xbrl//link:footnote[fn:starts-with(@xlink:label, "Footnote-abonnementen")]
  for $year in $abonnementen
  let $subscribers := xs:integer(fn:replace($year/text(), "(^.*?)(\d+)(.*$)", "$2"))
  order by xs:integer(fn:replace($year/@xlink:label, "(^.*?)-(\d+)", "$2"))
  return $subscribers
};

declare function local:get-profits($xbrl as element()) as xs:decimal*
{
  let $profits-losses := $xbrl//(kranten:verlies | kranten:winst)
  for $profit-loss in $profits-losses
  let $value :=
    typeswitch($profit-loss)
    case element(kranten:verlies) return -(xs:decimal($profit-loss/text()))
    default return xs:decimal($profit-loss/text())
  order by fn:replace($profit-loss/@contextRef, "(I-)(\d+)", "$2")
  return $value
};

let $xbrl := fn:doc("https://gist.githubusercontent.com/CliffordAnderson/674670de294616f2231c/raw/cab803a7d44661f6cc145e1f5e16e966eb8c89ef/xbrl-heraut.xml")/xbrl:xbrl
let $subscribers := local:get-subscribers($xbrl)
let $profits := local:get-profits($xbrl)
let $dates := $xbrl//xbrl:instant/text()
let $records :=
  for $record at $i in 1 to fn:count($dates)
  let $record := ($dates[$i], $profits[$i], $subscribers[$i])
  return
  element record {
    element dates {$record[1]},
    element pl {$record[2]},
    element subscribers {$record[3]}
  }
let $csv := element csv {$records}
return csv:serialize($csv, map {'header': 'true'})