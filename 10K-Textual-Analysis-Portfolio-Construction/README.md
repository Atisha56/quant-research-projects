# 10-K Textual Analysis & Portfolio Construction

- **Status:** Complete
- **Tools:** Python (NLTK/spaCy, scikit-learn, Pandas)

## Overview
Built an NLP pipeline extracting MD&A (Management Discussion & Analysis) sections from
63 SEC 10-K filings, scoring sentiment across 7 Loughran-McDonald categories and computing
TF-IDF and binary document-similarity matrices across filings.

## Methodology
- Extracted MD&A text from 63 10-K filings via SEC EDGAR
- Scored each filing's language across 7 Loughran-McDonald financial sentiment categories
- Computed TF-IDF vectors and a pairwise document-similarity matrix across all 63 filings
- Constructed a 20-stock portfolio from the least textually-similar filings, testing
  whether textual dissimilarity predicts return dispersion

## Key Findings
Results across portfolio weighting schemes were mixed — the dissimilarity-based portfolio
did not show a consistent, reliable signal, with performance more attributable to
concentration risk from the small stock count than to the textual dissimilarity construct
itself.

## Files
- `10K_Textual_Analysis.html` — full notebook export

[← Back to Quant Research Projects](../)
