# header
####################################################################################################
library(data.table)
setDTthreads(0)
library(fixest) # fixed effects model
setFixest_nthreads(0)

rstudioapi::getActiveDocumentContext()$path |> dirname() |> setwd()
####################################################################################################

# import data
####################################################################################################
my_sample <- fread("energy_data.csv")
####################################################################################################


# winsorize columns at 1% and 99%
my_sample1 <- my_sample[capex > quantile(capex, probs = 0.01, na.rm = TRUE) &
                         capex < quantile(capex, probs = 0.99, na.rm = TRUE) &
                         size > quantile(size, probs = 0.01, na.rm = TRUE) &
                         size < quantile(size, probs = 0.99, na.rm = TRUE) & 
                         ocf > quantile(ocf, probs = 0.01, na.rm = TRUE) &
                         ocf < quantile(ocf, probs = 0.99, na.rm = TRUE) &
                         d_to_e > quantile(d_to_e, probs = 0.01, na.rm = TRUE) &
                         d_to_e < quantile(d_to_e, probs = 0.99, na.rm = TRUE)]
  

# Or multiple variables at once
my_sample1[, `:=`(
  log_capex = log(capex),
  log_size = log(size),
  log_capex_lg1=log(capex_lg1)
)]


  
# clean data
####################################################################################################
setorder(my_sample1, ticker, year)

setDT(my_sample1)

my_sample1[, capex_lg1 := shift(capex), by = ticker]


median_d_to_e <- median(my_sample1$d_to_e, na.rm = TRUE)

my_sample1[, d_to_e_dum := ifelse(d_to_e > median_d_to_e, 1, 0)]

# analyze data
####################################################################################################
#pooled model
mdl_ols_pool <- feols(log_capex ~ log_capex_lg1 + d_to_e +ocf+ log_size, data = my_sample1)
summary(mdl_ols_pool)

#firm & year fixed effects
mdl_ols_fe <- feols(log_capex ~ log_capex_lg1 + d_to_e + log_size |
                      ticker + year,
                    data = my_sample1,
                    vcov = "iid")
summary(mdl_ols_fe)

#industry clusters
mdl_ols_fe <- feols(log_capex ~ log_capex_lg1 + d_to_e + log_size |
                      ticker + year,
                    data = my_sample1,
                    vcov = ~ ticker)
summary(mdl_ols_fe)


#industry clusters
mdl_ols_fe <- feols(capex ~ capex_lg1+ d_to_e + ocf + size |
                      ticker + year,
                    data = my_sample1,
                    vcov = ~ ticker)
summary(mdl_ols_fe)
####################################################################################################

# export data
####################################################################################################
rm(list = ls())
####################################################################################################
