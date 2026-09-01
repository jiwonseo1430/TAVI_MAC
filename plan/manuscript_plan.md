# Plan — Manuscript Draft (MAC and Mortality after TAVI)

**Status:** DRAFT
**Do not execute anything below until Status = APPROVED.**

## 1. Deliverable
`manuscript/manuscript.md` — full original-article draft in English, IMRaD,
~3,000–3,500 words + Table/Figure legends + supplement list. Generic
cardiology-journal format (no journal-specific styling yet; adjustable once a
target journal is chosen).

## 2. Core message (agreed through analysis stage)
1. CT-quantified MAC volume is independently associated with all-cause
   mortality after TAVI (per doubling HR 1.09; any MAC HR 1.94).
2. The excess risk is confined to the **first year** (0–1 y HR 3.63 vs >1 y
   0.99; interaction p=0.003) and is not merely periprocedural (31–365 d HR
   3.58) — MAC marks early post-TAVI vulnerability.
3. Robust across covariate-selection strategies (S1–S3); dose-response shown
   by spline; discrimination gain (C-index) modest and non-significant —
   framed as prognostic marker, NOT as an incremental discrimination claim.

## 3. Numbers policy (CLAUDE.md §4)
Every number is taken verbatim from `<data_dir>/output/` files (table1_binary,
table2, table3c_*, table_time_interval, table4c, sensitivity_continuous,
suppl_*, logs for FU/median, assumption checks). No numbers from memory; a
final verification pass re-reads each cited file.

## 4. Section outline
- **Title page**: title (working: "Quantified Mitral Annular Calcification and
  Early Mortality after Transcatheter Aortic Valve Implantation"), authors TBD.
- **Abstract** (structured, ~300 words): background/methods/results/conclusion.
- **Introduction** (~3 paragraphs): MAC prevalence & prognosis in AS/TAVI;
  gap = qualitative grading, unknown time-structure; aim.
- **Methods**: population (N=525, single-center retrospective, TAVI, dates
  **[TO CONFIRM: enrollment period, center, ethics/IRB statement]**); CT MAC
  quantification (**[TO CONFIRM: scanner/protocol, contrast→noncontrast volume
  transformation method]**); covariates & echo; outcome = all-cause death,
  follow-up (median 3.18 y reverse-KM); statistics — per approved plan +
  Amendments 1–2, post-hoc analyses explicitly labeled (landmark KM,
  3-interval HRs, period risk-factor table); R version & packages.
- **Results**: cohort & Table 1; univariable (Table 2); primary continuous
  model + binary/3-group (Table 3); time-structure (Table 4, Fig 1 C/D);
  dose-response (Fig 2); C-index in text; sensitivity (suppl).
- **Discussion** (~5 paragraphs): summary; comparison with prior MAC-TAVR
  literature; mechanism — first-year vulnerability, background mortality in
  the elderly (suppl period risk-factor table), depletion-of-susceptibles
  caveat; clinical implications (first-year surveillance); limitations
  (retrospective single-center, no cause-of-death/competing risks, EPV 7.7 in
  full candidate model, post-hoc time-structure analyses, MAC-positive median
  cut is cohort-defined).
- **Legends** for Figures 1–2, Tables 1–4; supplement inventory.
- **References**: real citations where established (position statement, MAC
  prognosis literature from the earlier search), `[REF]` placeholders
  elsewhere; finalized in a later pass.

## 5. NOT in scope
- Journal-specific formatting/submission files, cover letter.
- New analyses. Any number not already in `output/` triggers stop-and-report.

---
## Post-hoc log (append-only)
(empty)
