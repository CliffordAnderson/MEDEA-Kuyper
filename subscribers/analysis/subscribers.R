library(ggmap)
library(ggplot2)
library(plyr)
library(rgeos)

# Thanks to http://bl.ocks.org/prabhasp/raw/5030005/ for sample R code

nl <- readRDS(file.choose()) #NLD_adm1.rds (http://biogeo.ucdavis.edu/data/gadm2.7/rds/NLD_adm1.rds)
subscribers <- read.csv(file.choose()) #subscribers.csv (https://gist.githubusercontent.com/CliffordAnderson/e3f174c31e83f8ca79a1/raw/c99900fbceec2e5c5f4d19d58710274cd62a0c6f/subscribers.csv)

noordHolland <- subscribers[1,2:6] + subscribers[2,2:6]
subscribers <- subscribers[2:11,]
subscribers[1,2:6] <- noordHolland

nl_provinces <- fortify(nl, region = "NAME_1")
names <- ddply(nl_provinces, .(id), summarize, clat = mean(lat), clong = mean(long))
names <- names[c(1,3:5,8:12,14),]

map <- ggplot()
map <- map + geom_map(data = subscribers, aes(map_id = Provincie, fill = Totaal), map = nl_provinces)
map <- map + expand_limits(x = nl_provinces$long, y = nl_provinces$lat)
map <- map + geom_text(data = names, aes(x = clong, y = clat, label = id))
map <- map + scale_fill_gradient(low="#e5f5f9", high="#2ca25f", name="Aantal abonnementen")
map <- map + ggtitle("Staat van Dagblad der Christelijk-Historische Richting, 24 okt. 1871")
map <- map + labs(x = "Longitude", y = "Latitude")
map
