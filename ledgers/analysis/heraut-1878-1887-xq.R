# load libraries
library("ggplot2")
library("lubridate")

# create data.frame from values

heraut <- data.frame(read.csv(file.choose(), header=T))

# add column to track positive and negative values
# Thanks to http://stackoverflow.com/a/12910865/3902229
heraut[["sign"]] = ifelse(heraut[["pl"]] >= 0, "Profit", "Losses")

# parse dates
heraut$dates <- parse_date_time(heraut$dates, orders="ymd")

# create plot
g <- ggplot(heraut, aes(dates))
g <- g + ggtitle("Financial Data for De Heraut, 1878-1887")
g <- g + labs(x="Year", y="Thousands")
g <- g + geom_point(aes(y=subscribers))
g <- g + theme(legend.title=element_blank())
g <- g + geom_smooth(aes(y = subscribers, colour = "Subscribers"), method="loess", se=F)
g <- g + geom_bar(aes(y=pl, fill = sign),  stat = "identity", position="dodge")
g <- g + scale_fill_manual(values = c("Profit" = "darkblue", "Losses" = "red"))
g
