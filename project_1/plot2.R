# R code for creating the 2nd figure.

# Import the necessary libraries:
library(dplyr)
library(magrittr)
library(readr)

# Get only the data I'm going to use to create this graph.
# To read the data file, I'm using the `read_delim` function from the `readr`
# library, since this function can deal with compressed files.
dat <-
  read_delim(
    file = file.path(
      "data",
      "exdata_data_household_power_consumption.zip"
    ),
    delim = ";",
    na = c("?"),
    col_types = cols(
      col_date(format = "%d/%m/%Y"),
      col_time(format = "%H:%M:%S"),
      col_double(),
      col_double(),
      col_double(),
      col_double(),
      col_double(),
      col_double(),
      col_double()
    )
  ) %>%
  filter(
    Date == as.Date("2007-02-01", format = "%Y-%m-%d") |
    Date == as.Date("2007-02-02", format = "%Y-%m-%d")
  ) %>%
  select(Date, Time, Global_active_power) %>%
  # Create a column by combining `Date` and `Time`:
  mutate(date_time = as.POSIXct(paste(Date, Time))) %>%
  select(date_time, Global_active_power)

# Translate the names of the weekdays into English:
Sys.setlocale("LC_TIME", "en_US.utf8")

# Plot the time series:
par(bg = NA)
with(
  dat,
  plot(
    x = date_time,
    y = Global_active_power,
    type = "l",
    xlab = "",
    ylab = "Global Active Power (kilowatts)"
  )
)
dev.copy(png, file.path("my_figures", "plot2.png"))
dev.off()
