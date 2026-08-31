# Plan — Repository / Data Infrastructure Setup

**Status:** APPROVED (2026-08-31, by JW Seo — "승인")
**Do not execute anything below until Status = APPROVED.**

> Infrastructure task — template sections adapted accordingly. No statistical
> analysis is performed in this task.

## 1. Goal
Separate code (GitHub) from data/outputs (OneDrive), with data paths resolved
via a config file / environment variable so the same code runs on any computer
regardless of the local OneDrive path. De-identify the raw dataset before any
analysis begins.

## 2. Current state (findings)
- `data/raw/total 0408.xlsx` — 525 patients x 59 columns, **contains patient
  identifiers**: `(실명)등록번호`, `(실명)생년월일`. Must not be committed anywhere.
- `data/raw/20260409 table figure-2.docx` — preliminary Tables 1–4, Supplementary
  Table 1, VIF table, Figure (MAC 3-group survival analysis, 102 deaths).
- Folder is not yet a git repository.

## 3. Target layout
```
D:\OneDrive\Research\TAVI_MAC\        ← git repo (code + text only, pushed to GitHub)
├── CLAUDE.md, PROGRESS.md, plan/, review/, reference/
├── analysis/scripts/                 ← R scripts (committed)
├── manuscript/                       ← manuscript text (committed)
├── config/
│   ├── config.example.yml            ← committed template
│   └── config.yml                    ← gitignored, per-computer data path
└── .gitignore                        ← excludes data, outputs, config.yml

~/OneDrive/Research/data/TAVI_MAC/    ← data + outputs (OneDrive only, NEVER in git)
├── raw/                              ← total 0408.xlsx, docx (identifiers stay here, read-only)
├── derived/                          ← de-identified analysis-ready tables (script-generated)
└── output/                           ← tables/figures produced by scripts
```

## 4. Path resolution mechanism
- Environment variable `TAVI_MAC_DATA` takes precedence; fallback to
  `config/config.yml` (key `data_dir`). Helper `analysis/scripts/00_config.R`
  resolves the path and is `source()`d by every script.
- `config/config.example.yml` documents the expected keys; each computer copies
  it to `config.yml` and sets its own OneDrive path.
- CLAUDE.md §9 will be amended: *data* paths come from config/env var; paths
  *within the repo* remain relative to project root.

## 5. De-identification (first derived dataset)
- Script `analysis/scripts/01_deidentify.R`: read `raw/total 0408.xlsx`, drop
  `(실명)등록번호`, `(실명)생년월일`, `엑셀/스캔유무`; keep `No` as study ID;
  convert dates only into derived quantities already present (age, time-to-event)
  then drop raw date columns not needed for analysis — exact column disposition
  listed in the script header and reviewed before running.
- Output: `derived/tavi_mac_deid.rds` (+ `.csv`). All later analysis reads only
  this file.
- Raw xlsx/docx are moved (not copied) out of the repo folder to the OneDrive
  data folder, so no identifier-bearing file remains under the git repo.

## 6. Version control
- `git init` in `TAVI_MAC`, initial commit of code/docs skeleton
  (prefix `plan:` for this approved plan).
- `.gitignore`: `data/`, `analysis/output/`, `config/config.yml`, `*.xlsx`,
  `*.rds`, Office temp files, `.Rhistory` etc.
- GitHub remote: created via `gh repo create` (private) — needs your account
  confirmation, or you create it and give me the URL.

## 7. Deliverables
- `config/config.example.yml`, `config/config.yml` (this computer)
- `analysis/scripts/00_config.R`, `analysis/scripts/01_deidentify.R`
- `.gitignore`, `PROGRESS.md` (checklist + Mermaid flow), CLAUDE.md §9 amendment
- Data files relocated to `~/OneDrive/Research/data/TAVI_MAC/raw/`
- Initial git commit + GitHub private remote

## 8. Explicitly NOT in scope
- Any statistical analysis, table, or figure reproduction (separate plan after
  the derived dataset exists).
- Manuscript text.

---
## Post-hoc log (append-only)
(empty)
