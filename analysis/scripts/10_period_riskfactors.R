# 10_period_riskfactors.R — post-hoc supplementary table (plan post-hoc log
# 2026-09-01): risk-factor profile of first-year vs post-1-year mortality.
#
# Two Cox models with identical covariates (primary selected set + age, added
# a priori for the background-mortality hypothesis):
#   model 1: censored at 1 year (first-year deaths)
#   model 2: 1-year survivors, landmark re-baseline (late deaths)
# Also reports median follow-up (observed and reverse-KM).
#
# Output: suppl_period_riskfactors.csv, 10_period_riskfactors_log.txt

set.seed(20260831)
source(file.path("analysis", "scripts", "00_config.R"))
library(survival)

log_path <- file.path(OUTPUT_DIR, "10_period_riskfactors_log.txt")
log_con <- file(log_path, open = "wt", encoding = "UTF-8")
logmsg <- function(...) { m <- paste0(...); cat(m, "\n"); writeLines(m, log_con) }
logmsg("10_period_riskfactors.R run at ", format(Sys.time(), "%Y-%m-%d %H:%M:%S"))

a <- readRDS(file.path(DERIVED_DIR, "tavi_mac_analysis.rds"))
selc <- readRDS(file.path(DERIVED_DIR, "model_selection_continuous.rds"))
cc <- a[a$id %in% selc$cc_ids, ]
cc$tte_days[cc$tte_days == 0] <- 0.5
LM <- 365.25

## median follow-up (whole cohort, n=525)
obs_med <- median(a$tte_days) / 365.25
rkm <- survfit(Surv(tte_days, 1 - death) ~ 1, data = a)  # reverse KM
rkm_med <- summary(rkm)$table["median"] / 365.25
logmsg(sprintf("Median follow-up: observed %.2f y (IQR %.2f-%.2f); reverse-KM %.2f y",
               obs_med, quantile(a$tte_days, .25) / 365.25,
               quantile(a$tte_days, .75) / 365.25, rkm_med))

VARS <- c(log2_mac = "log2 MAC (per doubling)", age = "Age (per year)",
          sex_female = "Sex (Female)", bmi = "BMI", sts = "STS score (%)",
          ckd = "CKD", afib = "A.fib", ldl_10 = "LDL (per 10 mg/dL)")
rhs <- paste(names(VARS), collapse = " + ")
fmt_p <- function(p) ifelse(p < 0.001, "<0.001", sprintf("%.3f", p))

cc$t1 <- pmin(cc$tte_days, LM)
cc$e1 <- as.integer(cc$death == 1 & cc$tte_days <= LM)
f1 <- coxph(as.formula(paste("Surv(t1, e1) ~", rhs)), data = cc)
b <- cc[cc$tte_days > LM, ]
b$t2 <- b$tte_days - LM
f2 <- coxph(as.formula(paste("Surv(t2, death) ~", rhs)), data = b)
logmsg("0-1 y: N=", f1$n, ", events=", f1$nevent,
       " | >1 y landmark: N=", f2$n, ", events=", f2$nevent)

cell <- function(fit, i) {
  s <- summary(fit)
  sprintf("%.2f (%.2f-%.2f); p=%s", s$conf.int[i, 1], s$conf.int[i, 3],
          s$conf.int[i, 4], fmt_p(s$coefficients[i, "Pr(>|z|)"]))
}
tab <- data.frame(
  Variable = unname(VARS),
  `0-1 year, HR (95% CI)` = vapply(seq_along(VARS), function(i) cell(f1, i), ""),
  `>1 year (landmark), HR (95% CI)` = vapply(seq_along(VARS), function(i) cell(f2, i), ""),
  check.names = FALSE)
write.csv(tab, file.path(OUTPUT_DIR, "suppl_period_riskfactors.csv"),
          row.names = FALSE, fileEncoding = "UTF-8")
logmsg("suppl_period_riskfactors.csv written")

writeLines("\n--- sessionInfo() ---", log_con)
writeLines(capture.output(sessionInfo()), log_con)
close(log_con)
