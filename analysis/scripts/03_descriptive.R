# 03_descriptive.R — Table 1 (by MAC group) and Supplementary Table 1 (by
# vital status), matching the preliminary layout.
#
# Input : <data_dir>/derived/tavi_mac_analysis.rds
# Output: <data_dir>/output/table1.csv
#         <data_dir>/output/suppl_table1.csv
#         <data_dir>/output/03_descriptive_log.txt
#
# Tests: continuous = one-way ANOVA (3 groups) / Welch t-test (2 groups);
# categorical = Pearson chi-square, Fisher's exact if any expected count < 5.

set.seed(20260831)
source(file.path("analysis", "scripts", "00_config.R"))

log_path <- file.path(OUTPUT_DIR, "03_descriptive_log.txt")
log_con <- file(log_path, open = "wt", encoding = "UTF-8")
logmsg <- function(...) { m <- paste0(...); cat(m, "\n"); writeLines(m, log_con) }
logmsg("03_descriptive.R run at ", format(Sys.time(), "%Y-%m-%d %H:%M:%S"))

a <- readRDS(file.path(DERIVED_DIR, "tavi_mac_analysis.rds"))

CONT <- c(age = "Age", bmi = "BMI", sts = "STS score (%)",
          tc = "TC (mg/dL)", tg = "TG (mg/dL)", ldl = "LDL (mg/dL)",
          hdl = "HDL (mg/dL)", lvef = "LVEF (%)", rsvp = "RSVP (mmHg)",
          ee_prime = "E/e'")
BIN <- c(sex_female = "Sex (Female)", htn = "HTN", dm = "DM", ckd = "CKD",
         copd = "COPD", pad = "PAD", cad = "CAD", afib = "A.fib",
         prev_stroke = "Previous stroke", prev_mi = "Previous MI",
         prev_cardiac_op = "Previous cardiac Op",
         mdpg_ge5 = "MDPG >=5 mmHg", death = "Death")
FACT <- c(mr_grade = "MR grade")
ORDER <- c("age", "sex_female", "bmi", "sts", "htn", "dm", "ckd", "copd",
           "pad", "cad", "afib", "prev_stroke", "prev_mi", "prev_cardiac_op",
           "tc", "tg", "ldl", "hdl", "lvef", "mdpg_ge5", "rsvp", "ee_prime",
           "mr_grade", "death")

fmt_p <- function(p) ifelse(is.na(p), NA,
                     ifelse(p < 0.001, "<0.001", sprintf("%.3f", p)))
msd <- function(x) sprintf("%.1f ± %.1f", mean(x, na.rm=TRUE), sd(x, na.rm=TRUE))
npct <- function(x, lev = 1) {
  n <- sum(x == lev, na.rm = TRUE); N <- sum(!is.na(x))
  sprintf("%d (%.1f%%)", n, 100 * n / N)
}

cat_p <- function(x, g) {
  tb <- table(x, g)
  ch <- suppressWarnings(chisq.test(tb))
  if (any(ch$expected < 5)) fisher.test(tb, simulate.p.value = (nrow(tb)*ncol(tb) > 4),
                                        B = 1e5)$p.value else ch$p.value
}

build_table <- function(g, glabels) {
  rows <- list()
  add <- function(...) rows[[length(rows) + 1]] <<- c(...)
  ncol_g <- length(glabels)
  for (v in ORDER) {
    if (v %in% names(CONT)) {
      cells <- c(msd(a[[v]]), vapply(glabels, function(l) msd(a[[v]][g == l]), ""))
      p <- if (ncol_g == 2) t.test(a[[v]] ~ g)$p.value
           else summary(aov(a[[v]] ~ g))[[1]][["Pr(>F)"]][1]
      add(CONT[[v]], cells, fmt_p(p))
    } else if (v %in% names(BIN)) {
      cells <- c(npct(a[[v]]), vapply(glabels, function(l) npct(a[[v]][g == l]), ""))
      add(BIN[[v]], cells, fmt_p(cat_p(a[[v]], g)))
    } else {
      add(FACT[[v]], rep("", ncol_g + 1), fmt_p(cat_p(a[[v]], g)))
      for (lev in levels(a[[v]])) {
        cells <- c(npct(a[[v]], lev),
                   vapply(glabels, function(l) npct(a[[v]][g == l], lev), ""))
        add(paste0("  ", lev), cells, "")
      }
    }
  }
  out <- as.data.frame(do.call(rbind, rows), stringsAsFactors = FALSE)
  names(out) <- c("Characteristic", "Overall", glabels, "p-value")
  out
}

# Table 1: by MAC group
g1 <- a$mac_group
t1 <- build_table(g1, levels(g1))
names(t1)[3:5] <- sprintf("%s MAC (N=%d)", c("No", "Low", "High"), table(g1))
write.csv(t1, file.path(OUTPUT_DIR, "table1.csv"), row.names = FALSE,
          fileEncoding = "UTF-8")
logmsg("table1.csv written (", nrow(t1), " rows)")

# Supplementary Table 1: by vital status (exclude the death row itself)
gd <- factor(a$death, levels = c(0, 1), labels = c("Survived", "Deceased"))
ORDER <- setdiff(ORDER, "death")
ts <- build_table(gd, levels(gd))
ts <- rbind(ts, {
  p <- fmt_p(cat_p(a$mac_group, gd))
  hdr <- c("MAC Group", "", "", "", p)
  hdr
})
for (lev in levels(a$mac_group)) {
  n0 <- sum(a$mac_group == lev & a$death == 0); N0 <- sum(a$death == 0)
  n1 <- sum(a$mac_group == lev & a$death == 1); N1 <- sum(a$death == 1)
  ts <- rbind(ts, c(paste0("  ", lev, " MAC"),
                    npct(a$mac_group, lev),
                    sprintf("%d (%.1f%%)", n0, 100*n0/N0),
                    sprintf("%d (%.1f%%)", n1, 100*n1/N1), ""))
}
names(ts)[3:4] <- sprintf("%s (N=%d)", levels(gd), table(gd))
write.csv(ts, file.path(OUTPUT_DIR, "suppl_table1.csv"), row.names = FALSE,
          fileEncoding = "UTF-8")
logmsg("suppl_table1.csv written (", nrow(ts), " rows)")

writeLines("\n--- sessionInfo() ---", log_con)
writeLines(capture.output(sessionInfo()), log_con)
close(log_con)
