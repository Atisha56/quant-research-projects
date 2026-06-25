library(data.table)
setDTthreads(0)
library(rmgarch)
library(ggplot2)
library(patchwork)

require(data.table)
require(vars)

install.packages("psych")        # For describe()
install.packages("summarytools") # For dfSummary()

library(psych)
library(summarytools)

rstudioapi::getActiveDocumentContext()$path |> dirname() |> setwd()
####################################################################################################

# Import data:
####################################################################################################
ts_data <- fread("crypto_data.csv")
####################################################################################################

# Converting the long data to the wide data: 
new_data<-dcast(ts_data, timestamp~symbol,value.var="return",)

#Exporting data
install.packages("openxlsx")
library(openxlsx)

write.xlsx(new_data, file = "data.xlsx")

# Analyze data:

# VAR(1)
data_imputed <- new_data[, c("BTC", "ETH", "BNB", "XRP","DOGE")]
data_imputed[is.na(data_imputed)] <-0
var_mdl <- VAR(data_imputed[1:45000], p = 1)
summary(var_mdl)

#Diagonists Test
serial.test(var_mdl)       # Autocorrelation in residuals
arch.test(var_mdl)         # ARCH effects
normality.test(var_mdl)    # Normality of residuals

# forecast
var_forecast <- predict(var_mdl, n.ahead = 10)
plot(var_forecast)

# forecast error variance decomposition
fevd(var_mdl) |> plot()
###################################################################################
################

# impulse response function

irf_xrp_doge <- irf(var_mdl, impulse = "XRP", response = "DOGE", n.ahead = 10, boot = TRUE, ci=0.95)
plot(irf_xrp_doge, main = "IRF: DOGE response to XRP shock")

irf_eth_bnb <- irf(var_mdl, impulse = "ETH", response = "BNB", n.ahead = 10, boot = TRUE, ci = 0.95)
plot(irf_eth_bnb, main = "IRF: BNB response to ETH shock")

irf_xrp_btc <- irf(var_mdl, impulse = "XRP", response = "BTC", n.ahead = 10, boot = TRUE, boot.runs = 1000, ci = 0.95)
plot(irf_xrp_btc, main = "IRF: BTC response to XRP shock")






