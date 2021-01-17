# R code for creating the 4th figure

# Import the necessary libraries
library(dplyr)
library(magrittr)
library(readr)

# Get only the data I'm going to use to create this graph. To read the data
# file, I'm using the `read_delim` function from the `readr` library, since
# this function can deal with compressed files.
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
  select(
    Date,
    Time,
    Global_active_power,
    Global_reactive_power,
    Voltage,
    Sub_metering_1,
    Sub_metering_2,
    Sub_metering_3
  ) %>%
  # Create a column by combining `Date` and `Time`
  mutate(datetime = as.POSIXct(paste(Date, Time))) %>%
  select(!c(Date, Time))

# Translate the names of the weekdays into English. Maybe you don't need this,
# but I do. The following command is system-dependent, and probably won't work
# if you're not running Linux.
Sys.setlocale("LC_TIME", "en_US.utf8")

# Create the four plots

# Make the background transparent, and define the layout
par(bg = NA, mfrow = c(2, 2))

# Top left
with(
  dat,
  plot(
    x = datetime,
    y = Global_active_power,
    type = "l",
    xlab = "",
    ylab = "Global Active Power"
  )
)

# Top right
with(
  dat,
  plot(
    x = datetime,
    y = Voltage,
    type = "l"
  )
)

# Bottom left

# 1st time series
with(
  dat,
  plot(
    x = datetime,
    y = Sub_metering_1,
    type = "l",
    xlab = "",
    ylab = "Energy sub metering"
  )
)

# 2nd time series
with(
  dat,
  lines(
    x = datetime,
    y = Sub_metering_2,
    col = "red"
  )
)

# 3rd time series
with(
  dat,
  lines(
    x = datetime,
    y = Sub_metering_3,
    col = "blue"
  )
)

legend(
  legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),
  lty = 1,
  seg.len = 1.6,
  col = c("black", "red", "blue"),
  x = "topright",
  bty = "n",
  cex = 0.9,
  y.intersp = 0.7
)

# Bottom right
with(
  dat,
  plot(
    x = datetime,
    y = Global_reactive_power,
    type = "l"
  )
)

# Export to PNG
dev.copy(png, "plot4.png")
dev.off()
