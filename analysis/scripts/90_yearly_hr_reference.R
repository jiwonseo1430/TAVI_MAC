# 90_yearly_hr_reference.R — INTERNAL REFERENCE, not a manuscript output.
# Year-by-year adjusted HRs for the MAC exposure and a 3-year-split comparison.
# Purpose: reviewer-response material justifying the 1-year period boundary
# (effect already null in year 2; a 3-year split dilutes 0-3 y HR to ~2.0 and
# leaves only ~13 late events). See review/revision_reference_yearly_hr.md.
# Output: <data_dir>/output/yearly_hr_reference.txt

set.seed(20260831)
source(file.path("analysis", "scripts", "00_config.R"))
library(survival)

a <- readRDS(file.path(DERIVED_DIR, "tavi_mac_analysis.rds"))
selc <- readRDS(file.path(DERIVED_DIR, "model_selection_continuous.rds"))
covs <- selc$selected
a$tte_days[a$tte_days == 0] <- 0.5

sink(file.path(OUTPUT_DIR, "yearly_hr_reference.txt"))
cat("Generated", format(Sys.time(), "%Y-%m-%d %H:%M:%S"),
    "- INTERNAL reference (not for manuscript)\n")
cat("Adjusted for:", paste(covs, collapse = ", "), "\n\n")

run_split <- function(cuts, labels) {
  sp <- survSplit(Surv(tte_days, death) ~ ., data = a, cut = cuts,
                  episode = "period")
  sp$period <- factor(sp$period, seq_along(labels), labels)
  cat("events by period:", paste(tapply(sp$death, sp$period, sum),
                                 collapse = " / "), "\n")
  for (expo in c("any_mac", "log2_mac")) {
    f <- as.formula(paste("Surv(tstart, tte_days, death) ~", expo, ":period +",
                          paste(covs, collapse = " + ")))
    s <- summary(coxph(f, data = sp))
    idx <- grep(paste0("^", expo, ":period"), rownames(s$coefficients))
    cat("--", expo, "--\n")
    for (k in seq_along(idx)) {
      ci <- s$conf.int[idx[k], ]
      cat(sprintf("  %-7s HR %.2f (%.2f-%.2f) p=%.3f\n", labels[k],
                  ci[1], ci[3], ci[4], s$coefficients[idx[k], "Pr(>|z|)"]))
    }
  }
}
cat("=== yearly splits ===\n")
run_split(c(365.25, 730.5, 1095.75), c("0-1y", "1-2y", "2-3y", ">3y"))
cat("\n=== single 3-year split (for comparison) ===\n")
run_split(1095.75, c("0-3y", ">3y"))

cat("\n--- sessionInfo ---\n")
print(sessionInfo())
sink()
cat("written: output/yearly_hr_reference.txt\n")
