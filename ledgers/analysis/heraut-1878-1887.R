# load libraries
library("ggplot2")
library("lubridate")

# create data.frame from values
dates <- c("1878-12-31", "1879-12-31", "1880-12-31", "1881-12-31", "1882-12-31", "1883-12-31", "1884-12-31", "1885-12-31", "1886-12-31", "1887-12-31")
pl <- c(-1334.62, -280.75, -347.28, 60.25, 816.26, 1080.29, 851.25, 2063.57, 2830.84, 1887.26)
subscribers <- c(2601, 2512, 2437, 2497, 2410, 2466, 2494, 2630, 3275, 3750)
heraut <- data.frame(dates, pl, subscribers)

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
