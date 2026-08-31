# PROGRESS — TAVI_MAC

**Resume point (for next computer):** Stage 2 (analysis) complete — all tables,
sensitivity analyses, and the KM figure are script-generated in
`<data_dir>/output/`; see `output/discrepancy_report.md` for differences vs the
preliminary docx (A.fib count inversion, Table 3-2 CI typos, MR-grade n=514
decision pending, primary ΔC p=0.061 vs preliminary 0.024). Next step:
manuscript drafting (Methods/Results) — needs a decision on MR-grade handling
(discrepancy 1c) first.

## Checklist

### Stage 0 — Infrastructure (plan/setup_infra_plan.md)
- [x] Plan approved (2026-08-31)
- [x] Data moved out of repo to `~/OneDrive/Research/data/TAVI_MAC/raw/`
- [x] Config mechanism (`config/config.yml` + `TAVI_MAC_DATA` env var, `00_config.R`)
- [x] De-identification script `01_deidentify.R` run → `derived/tavi_mac_deid.rds`
- [x] git init, initial commits, pushed to GitHub (jiwonseo1430/TAVI_MAC)

### Stage 1 — Analysis plan
- [x] `plan/analysis_plan.md` written (primary = backward selection; S1–S3 sensitivity)
- [x] Plan approved (2026-08-31)

### Stage 2 — Analysis (all outputs in `<data_dir>/output/`)
- [x] `02_prepare.R` — analysis dataset (525 x 32), MAC group 269/220/36 verified
- [x] `03_descriptive.R` — table1.csv, suppl_table1.csv
- [x] `04_cox.R` — table2.csv, backward selection (table3_full/final.csv), PH/VIF/EPV
- [x] `04s_sensitivity.R` — S1/S2/S3 (sensitivity_models.csv)
- [x] `05_models_cindex.R` — table4.csv (C 0.708→0.732, ΔC p=0.061)
- [x] `06_km_figure.R` — fig1_km.png/.pdf (log-rank p<0.0001)
- [x] discrepancy_report.md (A.fib inversion, T3-2 CI typos, MR n=514, ΔC p)
- [ ] MR-grade handling decision (discrepancy 1c) — blocks Table 1 finalization

### Stage 3 — Manuscript
- [ ] Draft (Methods/Results first)
- [ ] Reviewer audit (review/reviewer_checklist.md)
- [ ] Submission

## Flow

```mermaid
flowchart TD
    A[raw/total 0408.xlsx<br/>identifiers, OneDrive only] -->|01_deidentify.R| B[derived/tavi_mac_deid.rds<br/>525 x 51, de-identified]
    A2[config.yml / TAVI_MAC_DATA] --> C[00_config.R]
    C --> B
    B -->|02_prepare.R| P[derived/tavi_mac_analysis.rds<br/>525 x 32]
    P -->|03_descriptive.R| T1[table1, suppl_table1]
    P -->|04_cox.R| T2[table2, table3 full/final<br/>PH/VIF/EPV checks]
    P -->|04s_sensitivity.R| S[S1 clinical / S2 LASSO / S3 AIC]
    P -->|05_models_cindex.R| T4[table4: C-index + compareC]
    P -->|06_km_figure.R| F1[fig1_km]
    T1 & T2 & S & T4 & F1 --> DR[discrepancy_report.md]
    DR --> F[manuscript/]
    F --> G[reviewer audit]
    style B fill:#dfd,stroke:#333
    style P fill:#dfd,stroke:#333
    style F fill:#eee,stroke:#999,stroke-dasharray: 5 5
```
