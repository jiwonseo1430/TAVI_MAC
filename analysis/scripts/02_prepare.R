# 02_prepare.R — analysis-ready dataset with clean names / factors.
#
# Input : <data_dir>/derived/tavi_mac_deid.rds
# Output: <data_dir>/derived/tavi_mac_analysis.rds
#         <data_dir>/output/02_prepare_log.txt (incl. missingness, sessionInfo)
#
# Coding decisions (verified against raw frequencies, 2026-08-31):
# - mac_group: from MAC_vol_transform_group (1=None, 2=Low, 3=High); verified
#   identical to cut(MAC_vol_transform, c(0, 717.2)) with 0 = None. 269/220/36.
# - sex_female: 성별 == 1 (n=296 matches preliminary Table 1 Female count).
# - afib: a.fib coerced numeric; 1 = AF present (n=111). Preliminary Table 1
#   (78.8%) had this inverted — see discrepancy report.
# - mdpg_ge5: Echo_MDPG numeric >= 5; "NoMS" (n=382) = no mitral stenosis,
#   counted as < 5 (reproduces preliminary 496/29 split).
# - mr_grade: No/Trivial | I-II (G I, G I-II, G II) | III-IV (G III, G III-IV,
#   G IV); "G II-III" (n=11) set NA to reproduce the preliminary grouping
#   (their MR rows sum to 514) — flagged in discrepancy report.
# - Lipids: *_10 variables = mg/dL / 10 (HR per 10 mg/dL).
# - time to event: days (validated in 01_deidentify log).

set.seed(20260831)
source(file.path("analysis", "scripts", "00_config.R"))

log_path <- file.path(OUTPUT_DIR, "02_prepare_log.txt")
log_con <- file(log_path, open = "wt", encoding = "UTF-8")
logmsg <- function(...) { m <- paste0(...); cat(m, "\n"); writeLines(m, log_con) }
logmsg("02_prepare.R run at ", format(Sys.time(), "%Y-%m-%d %H:%M:%S"))

d <- readRDS(file.path(DERIVED_DIR, "tavi_mac_deid.rds"))
stopifnot(nrow(d) == 525)

num <- function(x) suppressWarnings(as.numeric(x))

a <- data.frame(
  id          = d[["No"]],
  age         = num(d[["영상 검사시 나이"]]),
  sex_female  = as.integer(num(d[["성별"]]) == 1),
  bmi         = num(d[["BMI"]]),
  sts         = num(d[["STS SCORE(%)"]]),
  htn         = num(d[["HTN"]]),
  dm          = num(d[["DM"]]),
  ckd         = num(d[["CKD"]]),
  copd        = num(d[["COPD"]]),
  pad         = num(d[["PAD"]]),
  cad         = num(d[["CAD"]]),
  afib        = num(d[["a.fib"]]),
  prev_stroke = num(d[["prev.stroke"]]),
  prev_mi     = num(d[["prev.MI"]]),
  prev_cardiac_op = num(d[["prev.cardiac op"]]),
  tc          = num(d[["TotalCholerterol"]]),
  tg          = num(d[["TG"]]),
  ldl         = num(d[["LDL"]]),
  hdl         = num(d[["HDL"]]),
  lvef        = num(d[["Echo_LVEF"]]),
  rsvp        = num(d[["Echo_RSVP"]]),
  ee_prime    = num(d[["Echo_E/e'"]]),
  mac_vol     = num(d[["MAC_vol_transform"]]),
  death       = num(d[["death_final"]]),
  tte_days    = num(d[["time to event"]])
)

# MAC group: use provided group, verify against volume cut-off
grp <- num(d[["MAC_vol_transform_group"]])
recomputed <- ifelse(a$mac_vol == 0, 1, ifelse(a$mac_vol < 717.2, 2, 3))
stopifnot(identical(as.integer(grp), as.integer(recomputed)))
a$mac_group <- factor(grp, levels = 1:3, labels = c("None", "Low", "High"))
logmsg("mac_group verified vs volume cut-off 717.2: ",
       paste(table(a$mac_group), collapse = "/"))
stopifnot(all(table(a$mac_group) == c(269, 220, 36)))

# MDPG >= 5 (NoMS counted as < 5)
mdpg_raw <- as.character(d[["Echo_MDPG"]])
a$mdpg_ge5 <- as.integer(!is.na(num(mdpg_raw)) & num(mdpg_raw) >= 5)
a$mdpg_ge5[is.na(mdpg_raw)] <- NA
logmsg("mdpg_ge5: ", paste(table(a$mdpg_ge5, useNA='ifany'), collapse = "/"),
       " (expect 496/29)")

# MR grade (preliminary grouping; G II-III -> NA)
mr_raw <- trimws(as.character(d[["Echo_Mrgrade"]]))
a$mr_grade <- factor(
  ifelse(mr_raw %in% c("No", "Trivial"), "No/Trivial",
  ifelse(mr_raw %in% c("G I", "G I-II", "G II"), "I-II",
  ifelse(mr_raw %in% c("G III", "G III-IV", "G IV"), "III-IV", NA))),
  levels = c("No/Trivial", "I-II", "III-IV"))
logmsg("mr_grade (G II-III n=", sum(mr_raw == "G II-III", na.rm = TRUE),
       " set NA): ", paste(table(a$mr_grade, useNA='ifany'), collapse = "/"))

# per-10 mg/dL lipids
for (v in c("tc", "tg", "ldl", "hdl")) a[[paste0(v, "_10")]] <- a[[v]] / 10

# non-numeric coercions introduced how many NAs?
logmsg("hdl non-numeric -> NA: ", sum(is.na(a$hdl)) ,
       " | afib NA: ", sum(is.na(a$afib)))

stopifnot(sum(a$death, na.rm = TRUE) == 102)

# missingness table
miss <- sort(colSums(is.na(a)), decreasing = TRUE)
logmsg("\nMissingness (n of 525):")
for (v in names(miss[miss > 0])) logmsg("  ", v, ": ", miss[[v]])

saveRDS(a, file.path(DERIVED_DIR, "tavi_mac_analysis.rds"))
logmsg("\nWritten derived/tavi_mac_analysis.rds: ", nrow(a), " x ", ncol(a))

writeLines("\n--- sessionInfo() ---", log_con)
writeLines(capture.output(sessionInfo()), log_con)
close(log_con)
