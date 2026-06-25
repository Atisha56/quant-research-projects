# header
####################################################################################################
require(data.table)
setDTthreads(0)
require(e1071)
require(tseries)
require(ggplot2)
require(patchwork)

rstudioapi::getActiveDocumentContext()$path |> dirname() |> setwd()
####################################################################################################

# import data
####################################################################################################
ts_data <- fread("XOM_Daily_Info.csv")
ts_data[, Date := as.Date(Date)]  # Convert to Date type
####################################################################################################
head(ts_data)
str(ts_data)

my_sample <- ts_data[Price > quantile(Price, probs = 0.01, na.rm = TRUE) &
                       Price < quantile(Price, probs = 0.99, na.rm = TRUE) &
                       Return > quantile(Return, probs = 0.01, na.rm = TRUE) & 
                       Return < quantile(Return, probs = 0.99, na.rm = TRUE)]
# analyze data
####################################################################################################
# evolution
fig1a <- ggplot(my_sample, mapping = aes(Date, Price)) +
  geom_line(color = "blue", linewidth = 0.2) +
  labs(x = NULL, y = "XOM Stock Price")

fig1b <- ggplot(my_sample, mapping = aes(Date, Return)) +
  geom_line(color = "red", linewidth = 0.2) +
  labs(x = NULL, y = "XOM Stock Return")
fig1 <- fig1a / fig1b

# autocorrelation
my_sample[, acf(Return, lag.max = 30)]

# augmented dickey-fuller test (h0: non-stationarity)
my_sample[, adf.test(Price)]
my_sample[, adf.test(Return)]

# volatility clustering
my_sample[, acf(Return^2, lag.max = 30)]

# heavy tail
my_sample[, kurtosis(Return)]

# QQ plot
fig2 <- ggplot(my_sample, mapping = aes(sample = Return)) +
  stat_qq(size = 0.001, color = "red") +
  stat_qq_line(linewidth = 0.3, color = "green") +
  labs(title = "XOM Stock Return", x = "Theoretical Quantile", y = "Sample Quantile")

# nonlinear dependence
#my_sample[, year := year(Date)][, corr := cor(Return, spx_ret), keyby = year]

#fig3 <- ggplot(ts_data, mapping = aes(date, corr)) +
  #geom_line(color = "blue", linewidth = 0.2) +
  #labs(x = NULL, y = "Apple Stock and S&P 500 Return Correlation")
####################################################################################################

# export data
####################################################################################################
ggsave("fig1.png",
       plot = fig1,
       width = 8,
       height = 8)
####################################################################################################
library(data.table)
setDTthreads(0)
library(rugarch) # ARMA and GARCH models
library(ggplot2)
library(patchwork)

####################################################################################################

arma_spec <- arfimaspec()

arma_mdl <- arfimafit(arma_spec, data = my_sample[, Return])

my_sample[, XOM_ret_fitted := fitted(arma_mdl) |> as.double()]

panel_data <- melt(
  my_sample[, .(Date, Return, XOM_ret_fitted)],
  id.vars = "Date",
  measure.vars = c("Return", "XOM_ret_fitted"),
  variable.factor = FALSE
)
fig <- ggplot(panel_data,
              mapping = aes(Date, value, group = variable, color = variable)) +
  geom_line(linewidth = 0.2) +
  labs(x = NULL, y = NULL)
arma_fcst <- arfimaforecast(arma_mdl, n.ahead = 1)


library(data.table)
setDTthreads(0)
library(rugarch)
library(ggplot2)
library(patchwork)

# analyze data
###################################################################################
#################
# GARCH model
garch_spec <- ugarchspec()

garch_mdl <- ugarchfit(garch_spec, data = my_sample[, Return])

my_sample[, ":="(
  XOM_ret_fitted = fitted(garch_mdl) |> as.double(),
  XOM_vol = sigma(garch_mdl) |> as.double()
)]

fig1a_data <- melt(
  my_sample[, .(Date, Return, XOM_ret_fitted)],
  id.vars = "Date",
  measure.vars = c("Return", "XOM_ret_fitted"),
  variable.factor = FALSE
)
fig1a <- ggplot(fig1a_data,
                mapping = aes(Date, value, group = variable, color = variable)) +
  geom_line(linewidth = 0.2) +
  labs(x = NULL, y = NULL)
fig1b <- ggplot(my_sample, mapping = aes(Date, XOM_vol)) +
  geom_line(color = "red", linewidth = 0.2) +
  labs(x = NULL, y = "XOM Stock Daily Conditional Volatility")
fig1 <- fig1a / fig1b

garch_fcst <- ugarchforecast(garch_mdl, n.ahead = 1)
###################################################################################
#################

# APARCH model
aparch_spec1 <- ugarchspec(list(model = "apARCH"))

aparch_mdl1 <- uaparchfit(aparch_spec1, data = my_sample[, Return])

my_sample[, ":="(
  XOM_ret_fitted = fitted(aparch_mdl1) |> as.double(),
  XOM_vol = sigma(aparch_mdl1) |> as.double()
)]
fig1a_data <- melt(
  ts_data[, .(date, aapl_ret, aapl_ret_fitted)],
  id.vars = "date",
  measure.vars = c("aapl_ret", "aapl_ret_fitted"),
  variable.factor = FALSE
)
fig1a <- ggplot(fig1a_data,
                mapping = aes(date, value, group = variable, color = variable)) +
  geom_line(linewidth = 0.2) +
  labs(x = NULL, y = NULL)
fig1b <- ggplot(ts_data, mapping = aes(date, aapl_vol)) +
  geom_line(color = "red", linewidth = 0.2) +
  labs(x = NULL, y = "Apple Stock Daily Conditional Volatility")
fig1 <- fig1a / fig1b
rm(fig1a, fig1b)
garch_fcst <- ugarchforecast(garch_mdl, n.ahead = 1)
###################################################################################
#################
