# 04_cox.R — univariable Cox (Table 2), primary multivariable model via
# pre-specified backward selection (Tables 3-A/3-B), reproduction of the
# preliminary Tables 3-1/3-2, and assumption checks (PH, VIF, EPV).
#
# Per approved plan/analysis_plan.md §4:
# - Candidates: univariable p < 0.05; if both TC and LDL qualify keep LDL only.
# - mac_group forced (exposure), never eligible for removal.
# - Backward elimination by largest Wald p until all covariates p < 0.05,
#   on ONE fixed complete-case dataset (constant N at every step).
#
# Output: table2.csv, table3_full.csv, table3_final.csv,
#         repro_table3_1.csv, repro_table3_2.csv, assumption_checks.txt,
#         04_cox_log.txt (selection path + sessionInfo)

set.seed(20260831)
source(file.path("analysis", "scripts", "00_config.R"))
library(survival)

log_path <- file.path(OUTPUT_DIR, "04_cox_log.txt")
log_con <- file(log_path, open = "wt", encoding = "UTF-8")
logmsg <- function(...) { m <- paste0(...); cat(m, "\n"); writeLines(m, log_con) }
logmsg("04_cox.R run at ", format(Sys.time(), "%Y-%m-%d %H:%M:%S"))

a <- readRDS(file.path(DERIVED_DIR, "tavi_mac_analysis.rds"))

UNIV <- c(age = "Age", sex_female = "Sex (Female)", bmi = "BMI",
          sts = "STS score (%)", htn = "HTN", dm = "DM", ckd = "CKD",
          copd = "COPD", pad = "PAD", cad = "CAD", afib = "A.fib",
          prev_stroke = "Previous stroke", prev_mi = "Previous MI",
          prev_cardiac_op = "Previous cardiac Op",
          tc_10 = "TC (per 10 mg/dL)", tg_10 = "TG (per 10 mg/dL)",
          ldl_10 = "LDL (per 10 mg/dL)", hdl_10 = "HDL (per 10 mg/dL)",
          lvef = "LVEF (%)", mdpg_ge5 = "MDPG (>=5 vs <5 mmHg)",
          # MAC exposures per Amendments 1-2 (continuous / binary / median split)
          log2_mac = "MAC volume (per doubling)",
          any_mac = "MAC (vs No MAC)",
          mac_group_med = "MAC volume group (Ref: None)")
MAC_EXPO <- c("log2_mac", "any_mac", "mac_group_med")

fmt_p <- function(p) ifelse(p < 0.001, "<0.001", sprintf("%.3f", p))
hr_rows <- function(fit, label_map = NULL) {
  s <- summary(fit)
  co <- s$coefficients; ci <- s$conf.int
  data.frame(term = rownames(co),
             `HR (95% CI)` = sprintf("%.2f (%.2f-%.2f)",
                                     ci[, "exp(coef)"],
                                     ci[, "lower .95"], ci[, "upper .95"]),
             `p-value` = fmt_p(co[, "Pr(>|z|)"]),
             p_num = co[, "Pr(>|z|)"], check.names = FALSE)
}

## ---------- Table 2: univariable ----------
t2 <- list(); univ_p <- c()
for (v in names(UNIV)) {
  fit <- coxph(as.formula(paste("Surv(tte_days, death) ~", v)), data = a)
  r <- hr_rows(fit)
  if (v == "mac_group_med") {
    r <- rbind(data.frame(term = UNIV[[v]], `HR (95% CI)` = "", `p-value` = "",
                          p_num = NA, check.names = FALSE),
               transform(r, term = sub("mac_group_med", "  ", term)))
  } else r$term <- UNIV[[v]]
  t2[[v]] <- r
  # variable-level p: Wald (1 df) or overall LR for the factor
  univ_p[v] <- if (v == "mac_group_med")
    summary(fit)$logtest["pvalue"] else r$p_num[1]
}
t2df <- do.call(rbind, t2)[, 1:3]
write.csv(t2df, file.path(OUTPUT_DIR, "table2.csv"), row.names = FALSE,
          fileEncoding = "UTF-8")
logmsg("table2.csv written; N used per model = complete cases per variable")
logmsg("Univariable p<0.05: ",
       paste(setdiff(names(univ_p)[univ_p < 0.05], MAC_EXPO), collapse = ", "))

## ---------- Primary: backward selection ----------
cand <- setdiff(names(univ_p)[univ_p < 0.05], MAC_EXPO)
if (all(c("tc_10", "ldl_10") %in% cand)) {
  cand <- setdiff(cand, "tc_10")
  logmsg("Collinearity rule applied: TC removed, LDL kept")
}
logmsg("Candidate pool: ", paste(cand, collapse = ", "))

cc <- a[complete.cases(a[, c(cand, "mac_group", "tte_days", "death")]), ]
logmsg("Fixed complete-case dataset: N=", nrow(cc),
       ", events=", sum(cc$death))

fit_with <- function(covs) {
  coxph(as.formula(paste("Surv(tte_days, death) ~ mac_group",
                         if (length(covs)) paste("+", paste(covs, collapse=" + ")) else "")),
        data = cc)
}

full_fit <- fit_with(cand)
t3full <- hr_rows(full_fit)[, 1:3]
write.csv(t3full, file.path(OUTPUT_DIR, "table3_full.csv"), row.names = FALSE,
          fileEncoding = "UTF-8")
logmsg("EPV (full candidate model): ", sum(cc$death), " events / ",
       length(coef(full_fit)), " parameters = ",
       round(sum(cc$death) / length(coef(full_fit)), 1),
       if (sum(cc$death) / length(coef(full_fit)) < 10) "  ** EPV < 10 — flag in Limitations **" else "")

covs <- cand
repeat {
  fit <- fit_with(covs)
  p <- summary(fit)$coefficients[, "Pr(>|z|)"]
  p <- p[!grepl("^mac_group", names(p))]        # exposure never removable
  if (!length(p) || max(p) < 0.05) break
  drop_v <- names(which.max(p))
  logmsg("  backward step: drop ", drop_v, " (p=", sprintf("%.3f", max(p)), ")")
  covs <- setdiff(covs, drop_v)
}
logmsg("Final selected covariates: ", paste(covs, collapse = ", "))
final_fit <- fit_with(covs)
t3final <- hr_rows(final_fit)[, 1:3]
write.csv(t3final, file.path(OUTPUT_DIR, "table3_final.csv"), row.names = FALSE,
          fileEncoding = "UTF-8")
logmsg("table3_final.csv written; N=", final_fit$n, ", events=", final_fit$nevent)
saveRDS(list(candidates = cand, selected = covs, cc_ids = cc$id),
        file.path(DERIVED_DIR, "model_selection.rds"))

## ---------- Reproduction of preliminary Tables 3-1 / 3-2 ----------
pre31 <- c("sex_female", "bmi", "sts", "dm", "ckd", "pad", "afib",
           "prev_stroke", "prev_cardiac_op", "ldl_10", "lvef")
pre32 <- c("bmi", "sts", "afib", "ldl_10")
for (nm in c("repro_table3_1", "repro_table3_2")) {
  covs_r <- if (nm == "repro_table3_1") pre31 else pre32
  fit_r <- coxph(as.formula(paste("Surv(tte_days, death) ~",
                                  paste(covs_r, collapse = " + "), "+ mac_group")),
                 data = a)
  write.csv(hr_rows(fit_r)[, 1:3], file.path(OUTPUT_DIR, paste0(nm, ".csv")),
            row.names = FALSE, fileEncoding = "UTF-8")
  logmsg(nm, ": N=", fit_r$n, ", events=", fit_r$nevent)
}

## ---------- Assumption checks ----------
sink_file <- file.path(OUTPUT_DIR, "assumption_checks.txt")
sink(sink_file)
cat("=== Proportional hazards (cox.zph), final selected model ===\n")
print(cox.zph(final_fit))
cat("\n=== Proportional hazards, full candidate model ===\n")
print(cox.zph(full_fit))
cat("\n=== VIF (linear approximation, final model covariates + MAC dummies) ===\n")
X <- model.matrix(final_fit)
vif <- diag(solve(cor(X)))
print(round(vif, 3))
cat("\n=== VIF, full candidate model ===\n")
Xf <- model.matrix(full_fit)
print(round(diag(solve(cor(Xf))), 3))
sink()
logmsg("assumption_checks.txt written")

writeLines("\n--- sessionInfo() ---", log_con)
writeLines(capture.output(sessionInfo()), log_con)
close(log_con)
