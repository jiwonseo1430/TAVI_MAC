# Revision reference — why the period boundary is 1 year (NOT in manuscript)

Kept for reviewer-response use only (decision 2026-09-01). Reproduce with
`Rscript analysis/scripts/90_yearly_hr_reference.R`; full output with
sessionInfo in `<data_dir>/output/yearly_hr_reference.txt`.

## Anticipated comment
"The 1-year cut-point for the period-specific analysis is arbitrary — why not
3 years?"

## Response material

1. **External anchor:** 1 year is the standard evaluation time point in TAVI
   (VARC-3; pivotal trials report 30-day and 1-year mortality as primary time
   points). A 3-year boundary has no such convention.

2. **Empirical confirmation** (year-by-year adjusted HRs, same covariates as
   the primary model; full cohort N=525, 102 deaths):

   | Period | Deaths | MAC vs No MAC | log2 MAC (per doubling) |
   |---|---|---|---|
   | 0–1 y | 57 | 3.46 (1.90–6.30) | 1.16 (1.08–1.24) |
   | 1–2 y | 19 | 1.01 (0.41–2.54) | 1.01 (0.89–1.14) |
   | 2–3 y | 13 | 0.76 (0.25–2.32) | 1.00 (0.86–1.17) |
   | >3 y  | 13 | 1.26 (0.40–3.96) | 0.97 (0.82–1.13) |

   The association is entirely confined to year 1; it is already null in year
   2. The 1-year boundary therefore coincides with the empirical change-point.

3. **A 3-year split is inferior:** 0–3 y HR dilutes to 2.04 (1.31–3.16) by
   mixing the strong first-year effect with two null years, and the >3 y
   stratum contains only 13 deaths (HR 1.26, 0.40–3.95).
