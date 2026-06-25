# GARCH Monte Carlo Risk Simulation

- **Status:** Complete (individual project[, QFE 5340 Financial Econometrics])
- **Tools:** C++

## Overview
Implemented a GARCH(1,1) Monte Carlo simulation from scratch in C++, generating 1 million
simulated return paths to estimate Value-at-Risk and Expected Shortfall at the 1% confidence
level.

## Methodology
- GARCH(1,1) parameters: ω = 0.00001, α = 0.05, β = 0.94
- Simulated 1,000,000 return paths using a fixed-seed Mersenne Twister random number generator
- Computed 1% VaR as the negative of the 1st percentile of simulated returns
- Computed 1% Expected Shortfall as the average loss beyond the VaR threshold

## Results
| Metric | Value |
|---|---|
| Sample Mean | 0.0023% |
| Sample Std Dev | 3.20% |
| 1% Value at Risk (VaR) | 7.88% |
| 1% Expected Shortfall (ES) | 9.70% |

## Files
- `GARCH_Monte_Carlo.cpp` — full simulation code

[← Back to Quant Research Projects](../)
