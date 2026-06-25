# Network-Based Early Warning System for Equity Market Crashes

- **Status:** Co-authored, under journal review
- **Tools:** Python (Pandas, NumPy, scikit-learn, XGBoost)

## Overview
Built a Composite Fragility Score from network biomarkers extracted from rolling
cross-sector correlation matrices across 10 S&P 500 sectors (2000–2024), testing logistic
regression, XGBoost, and a sector-rotation overlay for out-of-sample crash prediction.

## Key Findings
- VIX-only benchmark: 0.6449 AUC
- Logistic regression (network biomarkers): 0.6693 AUC
- XGBoost: 0.7009 AUC
- XGBoost + sector rotation (20-day horizon): 0.7264 AUC
- A long/cash trading strategy on the signal achieved a 0.72 Sharpe ratio vs. 0.68 for
  buy-and-hold SPY, cutting max drawdown from 33.93% to 26.80%

## Files
- `Network_Crash_Early_Warning.docx` — full paper

[← Back to Quant Research Projects](../)
