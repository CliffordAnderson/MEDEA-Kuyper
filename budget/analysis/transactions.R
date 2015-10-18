# load required libraries
library(ggplot2)
library(scales)

# import data ("transactions.csv")
csv <- read.csv(file.choose())
begrooting <- data.frame(csv)

# Add column for income versus expenditures
# See http://stackoverflow.com/a/26194589/3902229
begrooting$Balance<- ifelse(begrooting$value > 0,"Income","Expenditure")

# Plot bar graph of income versus expenditures
g <- ggplot(begrooting, aes(x=description, y=value))
g <- g + geom_bar(stat="identity", position="identity", aes(fill = Balance))
g <- g + scale_y_continuous(labels = comma)
# See http://dsgeek.com/2014/09/19/Customizingggplot2charts.html
g <- g + theme(axis.text.x = element_text(size = 10, angle = 45, hjust = 1, vjust = 1))
g <- g + ggtitle("Projected Budget for De Standaard and De Heraut, 1897")
g
