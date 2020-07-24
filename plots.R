library(ggplot2)
library(readr)
library(viridis)
library(scales)
library(plotly)
library(htmlwidgets)
options(browser = "/usr/bin/firefox")

african_data <- read_csv("../../african_data.csv")
african_data$Date <- as.Date(as.character(african_data$Date), format = "%Y-%m-%d")

names(african_data)[10] <- "Restrictions on Gatherings"
african_data$y <- african_data$CountryName

gatherings_data <- african_data[, names(african_data) %in% c("Date", "CountryName", "Restrictions on Gatherings")]

gatherings_data <- gatherings_data[complete.cases(gatherings_data), ]

gatherings_data$CountryName <- factor(gatherings_data$CountryName,levels=rev(unique(gatherings_data$CountryName)))

gatherings_data <- gatherings_data[gatherings_data$Date > "2020-02-14", ]

gatherings_data <- gatherings_data[gatherings_data$CountryName != "France",]

p <- ggplot(gatherings_data, aes(x = Date, y = CountryName, fill = `Restrictions on Gatherings`)) +
    theme(axis.text.x = element_text(angle = 90, hjust = 1, vjust = 0.5)) +
    geom_tile() +
    scale_fill_gradientn(
#        colours = c("gray81", "lightblue1", "#0066CC"),
        colours = c("gray81", "lightblue1", "#0066CC", "navyblue"), #j orig
        limits = c(0, 4),  ## there are 4 categories
        oob = squish) +
    labs(x = "", y = "") +
    scale_x_date(date_breaks = "2 weeks", date_labels = "%b-%d")


gatherings <- ggplotly(p)

saveWidget(gatherings, "gatherings.html")

