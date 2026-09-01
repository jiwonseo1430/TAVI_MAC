# 09_time_interval.R — period-specific HRs (PH remedy, plan Amendment 2).
#
# Counting-process split at 1 year (365.25 d). For each exposure
# (log2_mac continuous; any_mac binary), a single Cox model on the split data
# with exposure x period interaction gives HRs for 0-1 y and >1 y; covariates
# (primary selected set) held constant across periods. Period difference =
# Wald test of the interaction contrast.
#
# Output: table_time_interval.csv, 09_time_interval_log.txt

set.seed(20260831)
source(file.path("analysis", "scripts", "00_config.R"))
library(survival)

log_path <- file.path(OUTPUT_DIR, "09_time_interval_log.txt")
log_con <- file(log_path, open = "wt", encoding = "UTF-8")
logmsg <- function(...) { m <- paste0(...); cat(m, "\n"); writeLines(m, log_con) }
logmsg("09_time_interval.R run at ", format(Sys.time(), "%Y-%m-%d %H:%M:%S"))

a <- readRDS(file.path(DERIVED_DIR, "tavi_mac_analysis.rds"))
selc <- readRDS(file.path(DERIVED_DIR, "model_selection_continuous.rds"))
covs <- selc$selected
cc <- a[a$id %in% selc$cc_ids, ]
logmsg("Dataset: N=", nrow(cc), ", events=", sum(cc$death),
       "; covariates: ", paste(covs, collapse = ", "))

CUT <- 365.25
# survSplit requires strictly positive times; one patient has tte_days = 0
# (event on the day of TAVI). Set to 0.5 day for this analysis only.
n0 <- sum(cc$tte_days == 0)
if (n0 > 0) {
  logmsg("tte_days == 0 in ", n0, " patient(s); set to 0.5 day for the split")
  cc$tte_days[cc$tte_days == 0] <- 0.5
}
sp <- survSplit(Surv(tte_days, death) ~ ., data = cc, cut = CUT,
                episode = "period")
sp$period <- factor(sp$period, levels = 1:2, labels = c("0-1y", ">1y"))
logmsg("Split rows: ", nrow(sp), "; events by period: ",
       paste(tapply(sp$death, sp$period, sum), collapse = " / "))

fmt_p <- function(p) ifelse(p < 0.001, "<0.001", sprintf("%.3f", p))
rows <- list()
for (expo in c("log2_mac", "any_mac")) {
  f <- as.formula(paste("Surv(tstart, tte_days, death) ~", expo, ":period +",
                        paste(covs, collapse = " + ")))
  fit <- coxph(f, data = sp)
  s <- summary(fit)
  idx <- grep(paste0("^", expo, ":period"), rownames(s$coefficients))
  stopifnot(length(idx) == 2)
  # Wald test for equality of the two period coefficients
  b <- coef(fit)[idx]; V <- vcov(fit)[idx, idx]
  dz <- (b[1] - b[2]) / sqrt(V[1, 1] + V[2, 2] - 2 * V[1, 2])
  p_int <- 2 * pnorm(-abs(dz))
  lab <- if (expo == "log2_mac") "log2 MAC (per doubling)" else "MAC vs No MAC"
  for (k in 1:2) {
    ci <- s$conf.int[idx[k], ]
    rows[[length(rows) + 1]] <- data.frame(
      exposure = lab,
      period = c("0-1 y", ">1 y")[k],
      `HR (95% CI)` = sprintf("%.2f (%.2f-%.2f)", ci[1], ci[3], ci[4]),
      `p-value` = fmt_p(s$coefficients[idx[k], "Pr(>|z|)"]),
      `interaction p` = if (k == 1) fmt_p(p_int) else "",
      check.names = FALSE)
    logmsg(lab, " ", c("0-1 y", ">1 y")[k], ": ",
           sprintf("%.2f (%.2f-%.2f) p=%s", ci[1], ci[3], ci[4],
                   fmt_p(s$coefficients[idx[k], "Pr(>|z|)"])))
  }
  logmsg("  period-difference (interaction) p=", fmt_p(p_int))
}
tt <- do.call(rbind, rows)
write.csv(tt, file.path(OUTPUT_DIR, "table_time_interval.csv"),
          row.names = FALSE, fileEncoding = "UTF-8")
logmsg("table_time_interval.csv written")

## ---------- POST-HOC: 3-interval split (0-30 d / 31-365 d / >365 d) ----------
# Distinguishes periprocedural from early-phase mortality (plan post-hoc log
# 2026-09-01; formalized after audit finding #1 — cited numbers must be
# script-generated on the current dataset).
sp3 <- survSplit(Surv(tte_days, death) ~ ., data = cc, cut = c(30, CUT),
                 episode = "period")
sp3$period <- factor(sp3$period, 1:3, c("0-30 d", "31-365 d", ">365 d"))
logmsg("3-split events by period: ",
       paste(tapply(sp3$death, sp3$period, sum), collapse = " / "))
rows3 <- list()
for (expo in c("log2_mac", "any_mac")) {
  f <- as.formula(paste("Surv(tstart, tte_days, death) ~", expo, ":period +",
                        paste(covs, collapse = " + ")))
  s <- summary(coxph(f, data = sp3))
  idx <- grep(paste0("^", expo, ":period"), rownames(s$coefficients))
  lab <- if (expo == "log2_mac") "log2 MAC (per doubling)" else "MAC vs No MAC"
  for (k in seq_along(idx)) {
    ci <- s$conf.int[idx[k], ]
    rows3[[length(rows3) + 1]] <- data.frame(
      exposure = lab, period = levels(sp3$period)[k],
      `HR (95% CI)` = sprintf("%.2f (%.2f-%.2f)", ci[1], ci[3], ci[4]),
      `p-value` = fmt_p(s$coefficients[idx[k], "Pr(>|z|)"]),
      check.names = FALSE)
    logmsg("  ", lab, " ", levels(sp3$period)[k], ": ",
           sprintf("%.2f (%.2f-%.2f) p=%s", ci[1], ci[3], ci[4],
                   fmt_p(s$coefficients[idx[k], "Pr(>|z|)"])))
  }
}
write.csv(do.call(rbind, rows3),
          file.path(OUTPUT_DIR, "table_time_interval_3split.csv"),
          row.names = FALSE, fileEncoding = "UTF-8")
logmsg("table_time_interval_3split.csv written (POST-HOC)")

writeLines("\n--- sessionInfo() ---", log_con)
writeLines(capture.output(sessionInfo()), log_con)
close(log_con)
