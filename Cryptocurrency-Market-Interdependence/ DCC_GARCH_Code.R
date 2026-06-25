library(data.table)
setDTthreads(0)
library(rmgarch)
library(ggplot2)
library(patchwork)
library(dplyr)
library(lubridate)

require(data.table)
require(vars)

rstudioapi::getActiveDocumentContext()$path |> dirname() |> setwd()
####################################################################################################

# Import data:
####################################################################################################
ts_data <- fread("crypto_data.csv")
####################################################################################################

# Converting the long data to the wide data: 
new_data<-dcast(ts_data, timestamp~symbol,value.var="return",)

# Coverting the data into the hourly data
new_data$datetime <- as.POSIXct(new_data$timestamp, origin = "1970-01-01", tz = "UTC")
new_data$datetime_local <- with_tz(new_data$datetime, tzone = "America/Chicago")
new_data$hourly <- floor_date(new_data$datetime_local, unit = 'hour')

hourly_returns <- new_data %>%
  group_by(hourly) %>%
  summarise(
    btc1 = prod(1+BTC, na.rm = TRUE) -1,
    eth1 = prod(1+ETH, na.rm = TRUE) -1,
    bnb1 = prod(1+BNB, na.rm = TRUE) -1,
    xrp1 = prod(1+XRP, na.rm = TRUE) -1,
    doge1 = prod(1+DOGE, na.rm = TRUE) -1,
    .groups = "drop"
  )

# Setting it to the data table
setDT(hourly_returns)

# DCC(1, 1)-GARCH(1, 1)
dcc_garch_mdl <- ugarchspec() |> replicate(5, expr = _) |> multispec() |> dccspec() |>
  dccfit(data = hourly_returns[, .(btc1, eth1, bnb1, xrp1, doge1)])

# Correlation matrix
rcor_matrix<-rcor(dcc_garch_mdl)

# Forecasted DCC-GARCH 
dcc_garch_fcst <- dccforecast(dcc_garch_mdl, n.ahead = 1)

## Forecasted Correlation matrix
fcst_corr<- rcor(dcc_garch_fcst)[[1]][,,1]

## 
install.packages("ggcorrplot")
library(ggcorrplot)

ggcorrplot(fcst_corr,
          hc.order = FALSE,
          lab = TRUE,
          lab_size = 3,
          type  = "lower",
          colors = c("skyblue", "white", 'lightpink'),
          title = "Forecasted Correlation Matrix",
          ggtheme = theme_minimal())

################################################################################

# DCC(1, 1)-GARCH(1, 1)
# BTC and XRP
dcc_garch_mdl_1 <- ugarchspec() |> replicate(2, expr = _) |> multispec() |> dccspec() |>
  dccfit(data = hourly_returns[, .(btc1, xrp1)])

hourly_returns[, corr_2 := as.double (rcor(dcc_garch_mdl_1)[1, 2, ])]

hourly_returns$date <- as.Date(hourly_returns$date)

plot_data1 <- hourly_returns %>%
  filter(!is.na(hourly) & is.finite(corr_2))

fig <- ggplot(plot_data1, mapping = aes(hourly, corr_2)) +
  geom_line(color = "red", linewidth = 0.2) +
  labs(x = NULL, y = "BTC and  XRP")

# BNB and DOGE
dcc_garch_mdl_1 <- ugarchspec() |> replicate(2, expr = _) |> multispec() |> dccspec() |>
  dccfit(data = hourly_returns[, .(bnb1, doge1)])

hourly_returns[, corr_2 := as.double (rcor(dcc_garch_mdl_1)[1, 2, ])]

hourly_returns$date <- as.Date(hourly_returns$date)

plot_data1 <- hourly_returns %>%
  filter(!is.na(hourly) & is.finite(corr_2))

fig <- ggplot(plot_data1, mapping = aes(hourly, corr_2)) +
  geom_line(color = "red", linewidth = 0.2) +
  labs(x = NULL, y = "BNB and  DOGE")

# ETH and BNB
dcc_garch_mdl_1 <- ugarchspec() |> replicate(2, expr = _) |> multispec() |> dccspec() |>
  dccfit(data = hourly_returns[, .(eth1, bnb1)])

hourly_returns[, corr_2 := as.double (rcor(dcc_garch_mdl_1)[1, 2, ])]

hourly_returns$date <- as.Date(hourly_returns$date)

plot_data1 <- hourly_returns %>%
  filter(!is.na(hourly) & is.finite(corr_2))

fig <- ggplot(plot_data1, mapping = aes(hourly, corr_2)) +
  geom_line(color = "red", linewidth = 0.2) +
  labs(x = NULL, y = "ETH and  BNB")

# forecast
dcc_garch_fcst <- dccforecast(dcc_garch_mdl, n.ahead = 1)
####################################################################################################

# export data
####################################################################################################
rm(list = ls())
####################################################################################################
