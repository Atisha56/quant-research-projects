# Betting-Against-Beta Factor Strategy

- **Status:** Complete
- **Tools:** Python (Pandas, NumPy, Statsmodels)

## Overview
Estimated rolling 60-month CAPM betas across 500 stocks annually, forming
long-low-beta/short-high-beta portfolios to test the Betting-Against-Beta anomaly.

## Key Findings
Equal-weighted portfolio results were directionally consistent with BAB theory. An
inconsistency in the value-weighted results was traced to a date-range bug in the
backtest window — noted here rather than silently corrected, since identifying it was
part of the analysis process.

## Files
- `Betting_Against_Beta.html` — full notebook export

[← Back to Quant Research Projects](../)
