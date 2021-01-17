# R code for creating the 1st figure

# Import the necessary libraries
library(dplyr)
library(magrittr)
library(readr)

# Get only the data I'm going to use to create this graph. To read the data
# file, I'm using the `read_delim` function from the `readr` library, since this
# function can deal with compressed files.
dat <-
  read_delim(
    file = file.path("data", "exdata_data_household_power_consumption.zip"),
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
  pull(Global_active_power)

# Plot the histogram

# Make the background transparent
par(bg = NA)

hist(
  dat,
  col = "red",
  main = "Global Active Power",
  xlab = "Global Active Power (kilowatts)"
)

# Export to PNG
dev.copy(png, "plot1.png")
dev.off()
