xquery version "3.1";

declare namespace tei = "http://www.tei-c.org/ns/1.0";
declare namespace fr = "http://www.wheatoncollege.edu/tei-extensions/financialRecords/1.0";

let $trgrphy := fn:doc("https://gist.githubusercontent.com/CliffordAnderson/80dd6ef8a5ce8e0c1d37/raw/cb378b131a3b433ad9bbd48c9dbc94f5041e29ea/begrooting-transactionography.xml")
let $credits := 
  for $record in $trgrphy//fr:transfer[@fra="Ontvangsten"]/tei:measure
  return 
    element record {
      element description {fn:data($record/@commodity)},
      element value {fn:data($record/@quantity)}
    }
let $debits :=
  for $record in $trgrphy//fr:transfer[@fra="Uitgaven"]/tei:measure
  return 
    element record {
      element description {fn:data($record/@commodity)},
      element value {-fn:number(fn:data($record/@quantity))}
    }
return fn:sum($credits/value) + fn:sum($debits/value)