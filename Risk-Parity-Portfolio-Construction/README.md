# Risk Parity Portfolio Construction

- **Status:** Complete
- **Tools:** Python (scipy.optimize, Pandas, NumPy)

## Overview
Built an 8-ETF risk parity portfolio via convex optimization, rebalanced annually using a
5-year rolling lookback (2020–2024), plus a levered version matched to S&P 500 volatility
for a fair risk-adjusted comparison.

## Results

| Portfolio | Avg Return | Std Dev | Max Drawdown | Sharpe-like Ratio |
|---|---|---|---|---|
| Risk Parity (unlevered) | 0.93% | 0.69% | 0.37% | 1.36 |
| Risk Parity (levered to SPY vol) | 6.24% | 4.60% | 3.60% | 1.36 |
| Equal-Weight (8 ETFs) | 0.75% | 1.87% | 2.93% | 0.40 |
| S&P 500 | 1.80% | 3.06% | 4.58% | 0.59 |

Risk parity (both versions) achieved a substantially higher Sharpe-like ratio than either
equal-weighting or the S&P 500 benchmark — confirming that risk-balanced allocation, not
just diversification by count, drives better risk-adjusted performance.

## Files
- `Risk_Parity_Portfolio.html` — full notebook export

[← Back to Quant Research Projects](../)
