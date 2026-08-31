# 05_models_cindex.R — incremental value of MAC group (Table 4).
#
# Model 1 = final selected clinical covariates (04_cox.R): BMI, STS, CKD,
#           A.fib, LDL/10  (identical to preliminary Table 4 Model 1)
# Model 2 = Model 1 + MAC group
# Both fitted on ONE complete-case dataset (all Model-2 variables non-missing).
# Harrell's C via survival::concordance; delta-C tested with compareC.
# Also reproduces the preliminary Table 4-2 pair (BMI+STS+A.fib+LDL).
#
# Output: table4.csv, 05_models_cindex_log.txt

set.seed(20260831)
source(file.path("analysis", "scripts", "00_config.R"))
library(survival)
library(compareC)

log_path <- file.path(OUTPUT_DIR, "05_models_cindex_log.txt")
log_con <- file(log_path, open = "wt", encoding = "UTF-8")
logmsg <- function(...) { m <- paste0(...); cat(m, "\n"); writeLines(m, log_con) }
logmsg("05_models_cindex.R run at ", format(Sys.time(), "%Y-%m-%d %H:%M:%S"))

a <- readRDS(file.path(DERIVED_DIR, "tavi_mac_analysis.rds"))
sel <- readRDS(file.path(DERIVED_DIR, "model_selection.rds"))
logmsg("Selected clinical covariates (from 04_cox.R): ",
       paste(sel$selected, collapse = ", "))

pair_cindex <- function(clin_covs, label) {
  vars <- c(clin_covs, "mac_group", "tte_days", "death")
  cc <- a[complete.cases(a[, vars]), ]
  f1 <- coxph(as.formula(paste("Surv(tte_days, death) ~",
                               paste(clin_covs, collapse = " + "))), data = cc)
  f2 <- update(f1, . ~ . + mac_group)
  c1 <- concordance(f1); c2 <- concordance(f2)
  cmp <- compareC(cc$tte_days, cc$death, predict(f1, type = "lp"),
                  predict(f2, type = "lp"))
  logmsg(label, ": N=", nrow(cc), ", events=", sum(cc$death))
  logmsg("  Model 1 C=", sprintf("%.3f (SE %.3f)", c1$concordance, sqrt(c1$var)))
  logmsg("  Model 2 C=", sprintf("%.3f (SE %.3f)", c2$concordance, sqrt(c2$var)))
  logmsg("  compareC p=", sprintf("%.3f", cmp$pval))
  data.frame(
    pair = label,
    model = c(paste("Model 1:", paste(clin_covs, collapse = " + ")),
              "Model 2: Model 1 + MAC group"),
    C_index = sprintf("%.3f", c(c1$concordance, c2$concordance)),
    SE = sprintf("%.3f", sqrt(c(c1$var, c2$var))),
    N = nrow(cc), events = sum(cc$death),
    delta_C_p = c("", sprintf("%.3f", cmp$pval)))
}

t4 <- rbind(
  pair_cindex(sel$selected, "Primary (selected clinical model)"),
  pair_cindex(c("bmi", "sts", "afib", "ldl_10"),
              "Repro Table 4-2 (BMI+STS+A.fib+LDL)"))
write.csv(t4, file.path(OUTPUT_DIR, "table4.csv"), row.names = FALSE,
          fileEncoding = "UTF-8")
logmsg("table4.csv written")

writeLines("\n--- sessionInfo() ---", log_con)
writeLines(capture.output(sessionInfo()), log_con)
close(log_con)
