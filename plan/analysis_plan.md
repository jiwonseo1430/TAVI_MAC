# Analysis Plan — Reproduce & Verify Preliminary Analysis (MAC and Mortality after TAVI)

**Status:** APPROVED (2026-08-31, by JW Seo — primary = backward selection; sensitivity = S1, S2, S3)
**Do not execute anything below until Status = APPROVED.**

## 1. Question
Is mitral annular calcification (MAC) burden (None / Low / High by CT volume)
independently associated with all-cause mortality after TAVI, and does adding
MAC group improve model discrimination over clinical risk factors?

This stage reproduces every preliminary Table/Figure in
`<data_dir>/raw/20260409 table figure-2.docx` from the raw data as
script-generated outputs, so the manuscript can cite verified numbers.

## 2. Dataset
- Source: `<data_dir>/derived/tavi_mac_deid.rds` (525 patients, 51 cols; from
  `01_deidentify.R`).
- Inclusion/exclusion: none beyond the curated file (N = 525 as-is). Expected
  events: 102 deaths (`death_final`), time = `time to event` (days).
- MAC grouping: expected No MAC 269 / Low 220 / High 36 with High cut-off
  ≥ 717.2 (volume units to confirm). The grouping column
  (`MAC_vol_transform_group` vs. recomputed from `MAC_vol_transform`) will be
  verified to reproduce 269/220/36 **before** any model is fitted; the exact
  column and cut-off used are then recorded in the script header and Methods.
- Missing data: quantified per variable in `02_*` output. Primary approach:
  complete-case within each model, with each model's N and event count printed
  next to it. No imputation at this stage.

## 3. Variables
| Role | Variable | Type | Units / coding | Rescaling |
|---|---|---|---|---|
| Outcome | death_final + time to event | survival | days from TAVI | none |
| Primary exposure | MAC group | 3-level factor | None (ref) / Low (<717.2) / High (≥717.2) | none |
| Covariates | Age | continuous | years | none |
| | Sex | binary | Female vs Male | none |
| | BMI | continuous | kg/m² | none |
| | STS score | continuous | % | none |
| | HTN, DM, CKD, COPD, PAD, CAD, A.fib, prev. stroke, prev. MI, prev. cardiac op | binary | yes vs no | none |
| | TC, TG, LDL, HDL | continuous | mg/dL | HR per 10 mg/dL |
| | LVEF | continuous | % | none |
| | MDPG | binary | ≥5 vs <5 mmHg | none |
| | RSVP, E/e', MR grade | per Table 1 only | — | none |

## 4. Pre-specified analysis
All models: Cox proportional hazards, `survival::coxph`, Efron ties. Seed fixed;
sessionInfo logged per script.

1. **Table 1** — characteristics by MAC group (None/Low/High): mean±SD or n (%);
   ANOVA / χ² (Fisher if expected <5); matching the preliminary layout.
2. **Supplementary Table 1** — same variables by vital status (t-test / χ²).
3. **Table 2** — univariable Cox for each variable listed in preliminary Table 2.
4. **Multivariable model (PRIMARY) — pre-specified selection procedure**
   (the original covariate-selection rationale of preliminary Tables 3-1/3-2 is
   unknown; per decision 2026-08-31 the multivariable analysis is re-done with
   an explicit procedure):
   - Candidate pool: all variables with univariable p < 0.05 in step 3.
   - Collinearity rule (fixed in advance): if both TC and LDL qualify, keep
     **LDL** only; VIF checked after selection, any VIF > 5 reported.
   - **MAC group is the exposure and is forced into the model** (never eligible
     for removal).
   - Backward elimination on the candidate pool: iteratively remove the
     covariate with the largest Wald p until all remaining covariates have
     p < 0.05. Elimination runs on ONE fixed complete-case dataset (complete on
     the full candidate pool + MAC group + outcome), so N is identical at every
     step and in the final model (CLAUDE.md §3).
   - Output: full-candidate model (Table 3-A) and final selected model
     (Table 3-B), each with N and events.
5. **Reproduction of preliminary Tables 3-1 / 3-2** — the exact covariate sets
   from the docx are fit once, for verification/discrepancy reporting only
   (labeled "preliminary reproduction", not used in the manuscript unless they
   coincide with the selected model).
6. **Table 4 (C-index)** — Model 1 = final selected clinical covariates
   (without MAC), Model 2 = Model 1 + MAC group, both on the same complete-case
   dataset; Harrell's C, ΔC tested with `compareC` (Kang et al.). The
   preliminary C-index pairs (0.708→0.732, 0.687→0.722) are reproduced for the
   discrepancy report only.
7. **Figure** — Kaplan-Meier by MAC group with log-rank p and number at risk.
8. **Assumption checks** — Schoenfeld residuals (global + per-covariate PH test)
   for models 4–5; VIF (reproduce preliminary VIF table); linearity of
   continuous covariates checked by martingale residuals (reported, not acted on).
9. **EPV note** — the full candidate model has ~13–14 parameters / 102 events
   (EPV ≈ 7–8 < 10); reported in output and flagged for Methods/Limitations per
   CLAUDE.md §3. No covariate is dropped for this reason without a plan update.

### 4a. Sensitivity analyses for covariate selection (choose at approval)
Selected at approval: **S1, S2, S3** (S4 not included — out of scope).
- **S1. Clinically pre-specified model (no data-driven selection)** — fixed a
  priori: STS score + CKD + A.fib + MAC group (STS already aggregates age, sex,
  DM, LVEF, etc., so it serves as the composite clinical confounder). This is
  the reviewer-preferred approach; robustness of the MAC HR across S1 vs the
  primary model is the key claim.
- **S2. LASSO Cox (`glmnet`)** — all Table 2 variables as candidates, MAC group
  unpenalized (forced), λ by 10-fold CV (lambda.1se), fixed seed; selected
  covariates refit in an unpenalized Cox for interpretable HRs.
- **S3. AIC-based backward selection (`MASS::stepAIC`)** — same candidate pool
  as primary; retains marginal confounders that p<0.05 elimination discards.
- ~~S4. Bootstrap stability~~ — not selected; would be post-hoc if added later.

## 5. Decision rules stated in advance
- Reproduction tolerance: HRs/C-indices matching to published rounding (2 dp)
  = reproduced. Any mismatch is **reported as a discrepancy**, not "fixed" by
  changing the model. Discrepancies land in `output/discrepancy_report.md`.
- Known issues to adjudicate (found while reading the docx — verification
  targets, not things to silently correct):
  a. **A.fib inconsistency**: Table 1 reports A.fib 413/525 (78.8%) but
     Suppl Table 1 reports 82+29=111 (21.1%). One is likely miscoded/inverted.
     The reproduction will establish which matches the raw data.
  b. **Table 3-2 CI typos**: BMI 0.94 (2.45–2.69) and A.fib 1.68 (2.96–13.4)
     have CIs inconsistent with their HRs — presumed transcription errors;
     reproduction provides the correct values.
- PH violation (p<0.05): report it; remedy (stratification, time interaction)
  is a plan amendment, not an on-the-fly change.
- No threshold, covariate set, or grouping may change to improve any p-value.

## 6. Deliverables
Scripts (repo, `analysis/scripts/`):
- `02_prepare.R` — variable derivation/labels, MAC group verification, missingness table → `derived/tavi_mac_analysis.rds`
- `03_descriptive.R` — Table 1, Supplementary Table 1
- `04_cox.R` — Table 2 (univariable), primary backward selection (Tables 3-A/3-B),
  preliminary 3-1/3-2 reproduction, PH/VIF/EPV checks
- `04s_sensitivity.R` — sensitivity analyses S1 (pre-specified clinical model),
  S2 (LASSO Cox, MAC unpenalized), S3 (AIC backward)
- `05_models_cindex.R` — Tables 4, 4-2 (C-index + compareC)
- `06_km_figure.R` — KM figure
Outputs (`<data_dir>/output/`): `table1.csv`, `suppl_table1.csv`, `table2.csv`,
`table3_1.csv`, `table3_2.csv`, `table4.csv`, `fig1_km.png` (+ .pdf),
`assumption_checks.txt`, `discrepancy_report.md`, per-script logs with sessionInfo.

## 7. Anything explicitly NOT in scope
- Manuscript text (separate stage after outputs are verified).
- Any new analysis not in the preliminary docx (e.g., continuous MAC volume
  spline, competing risks, imputation) — would be post-hoc and needs a plan update.
- Changing the MAC cut-off (717.2) or group definitions.

---
## Amendment 1 — MAC exposure re-specification (APPROVED 2026-08-31, by JW Seo)

**Reason (structural, not p-driven):** the 717.2 cut-off was verified to be a
maximally-selected-rank-statistic optimal cutpoint derived from this cohort
(`surv_cutpoint`, minprop=0.05, returns 717.23 exactly); no literature basis
exists (nearest external values are device-trial enrollment criteria, 750 /
1000 mm³). An uncorrected optimal cutpoint inflates type I error and biases
the High-MAC HR upward; groups are also badly unbalanced (269/220/36, 14
deaths in High). Decided after seeing the Stage-2 reproduction results —
recorded here for transparency.

**Supersedes §3 (exposure) and §4 items 4–6:**
1. **Primary exposure (continuous):** `log2(mac_vol + 1)`, HR per doubling.
   Same selection procedure as before: candidate covariates = univariable
   p<0.05 (TC dropped for LDL), exposure forced, backward elimination at
   Wald p<0.05 on one fixed complete-case dataset.
2. **Dose–response:** natural cubic spline `ns(log2(mac_vol+1), df=3)` in the
   adjusted model; LR test spline vs linear for nonlinearity; figure of HR vs
   volume (reference = 0 mm³) with 95% CI.
3. **Presentation categories (option a):** None (0) / Low (0 < vol ≤ median of
   positive volumes) / High (> median). Expected 269/128/128, deaths 39/31/32.
   Used for Table 1, KM figure, and a secondary categorical Cox model.
4. **Old 717.2 grouping:** sensitivity analysis only, explicitly labeled
   "data-derived optimal cutpoint (maximally selected rank statistics)";
   maxstat-adjusted p reported if the maxstat package is available.
5. **Sensitivity S1–S3:** re-run with the continuous exposure (S1 clinical
   model = STS + CKD + A.fib + log2 MAC; S2 LASSO with exposure unpenalized;
   S3 AIC backward).
6. **Incremental value:** Model 1 = selected clinical covariates; Model 2 =
   Model 1 + log2 MAC (continuous). Harrell's C + compareC. Secondary: Model 1
   + median-split categories.
7. **Deliverables added:** `07_continuous_primary.R`, `08_figures_continuous.R`;
   updated `02_prepare.R` (new exposure/group variables), `03_descriptive.R`
   (Table 1 by median grouping). Outputs: `table3c_*.csv`,
   `sensitivity_continuous.csv`, `table4c.csv`, `table1_medgroup.csv`,
   `fig2_spline.png/.pdf`, `fig1_km_med.png/.pdf`.
Stage-2 outputs from the original grouping remain on disk as the reproduction
record; the manuscript uses the Amendment-1 outputs.

---
## Amendment 2 — presentation, PH remedy, MR-grade recode (APPROVED 2026-09-01, by JW Seo)

1. **Presentation categories become binary**: No MAC (vol=0, n=269) vs MAC
   (vol>0, n=256). Manuscript Table 1 and the main KM figure use this split;
   an adjusted binary Cox model (same covariates as the primary) is reported
   as a secondary model. The median-split 3-group Table 1 / KM / Cox move to
   the supplement. Continuous log2 MAC remains the PRIMARY inference.
2. **PH remedy (violation p=0.016/0.023/0.015)**: period-specific HRs via
   counting-process split at 1 year (survSplit at 365.25 d): report HRs for
   0-1 y and >1 y for the continuous exposure and the binary exposure
   (covariates held constant; period difference tested by interaction Wald p).
   Whole-period HRs remain reported with the PH note.
3. **MR-grade recode (resolves discrepancy 1c)**: half-grades map DOWN:
   Trivial→No, G I-II→I, G II-III→II, G III-IV→III. Final levels
   No/I/II/III/IV = 262/210/39/12/2 (all 525 classified, no exclusions).
   Used in all manuscript tables; the old 3-category variable is kept only for
   the preliminary-reproduction record.
4. **Deliverables**: `09_time_interval.R` (new); updates to `02_prepare.R`
   (any_mac, mr_grade5), `03_descriptive.R` (table1_binary.csv = manuscript
   Table 1; med-group and by-death tables switch to mr_grade5),
   `07_continuous_primary.R` (adjusted binary model added),
   `08_figures_continuous.R` (fig1_km_binary = main; fig1_km_med = supplement).
   Outputs: table1_binary.csv, table_time_interval.csv, fig1_km_binary.png/.pdf.

---
## Post-hoc log (append-only)
- 2026-09-01 — **3-interval period HRs (0-30 d / 31-365 d / >365 d)**, run to
  distinguish periprocedural from early-phase mortality (user request).
  Result: binary MAC HR 3.84 / 3.58 / 0.99 — excess risk spans the whole first
  year, not the 30-day window. To be reported as post-hoc in the manuscript.
- 2026-09-01 — **1-year landmark KM figures** added (Figure 3 = 3-group median
  split; supplement = binary): first-year log-rank p<0.001 (both), post-landmark
  p=0.41 / 0.71 — visual counterpart of the period-HR interaction. Post-hoc
  (motivated by the PH finding), labeled as such.
- 2026-09-01 — Figure 1 x-axis capped at 7 years (at-risk n beyond 7 y: 0-2);
  presentation-only change.
- 2026-09-01 — **Figure 2 re-based to 1-year mortality** (Cox censored at 1 y):
  linear log2 MAC HR 1.17 (1.09-1.25), nonlinearity p=0.136 (linearity holds in
  the 1-y frame). Whole-period spline (nonlinearity p=0.008) moved to
  supplement as justification. Post-hoc, motivated by the time-structure finding.
- 2026-09-01 — **2-panel main figures** (decision): Figure 1 = whole-period KM,
  A binary / B median 3-group (fig1_km_2panel; replaces separate
  fig1_km_binary + fig1_km_med). Figure 2 = spline, A 1-year mortality /
  B whole follow-up (single fig2_spline; separate supplement spline dropped).
  Presentation-only changes.
- 2026-09-01 — **Supplementary period risk-factor table** (10_period_riskfactors.R,
  primary covariates + age): first-year deaths driven by MAC/CKD/A.fib (age NS);
  post-1-y deaths driven by age (1.07/y) and STS (1.14) with all cardiac
  covariates null — supports the background-mortality interpretation of the
  landmark convergence. Post-hoc.
