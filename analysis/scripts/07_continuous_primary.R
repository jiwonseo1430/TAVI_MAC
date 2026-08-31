# 07_continuous_primary.R — Amendment-1 primary analysis: continuous MAC.
#
# Exposure: log2_mac = log2(MAC volume + 1), HR per doubling of (vol+1).
# Selection: candidates = univariable p<0.05 pool from 04_cox.R (TC dropped),
#   exposure FORCED, backward elimination Wald p<0.05, one fixed complete-case
#   dataset (same as 04_cox.R).
# Also: secondary categorical model (median-split), 717.2-grouping sensitivity
#   (labeled data-derived; maxstat-adjusted p), S1/S2/S3 with continuous
#   exposure, C-index incremental value (compareC).
#
# Output: table3c_full.csv, table3c_final.csv, table3c_categories.csv,
#         sensitivity_continuous.csv, table4c.csv,
#         assumption_checks_continuous.txt, 07_continuous_primary_log.txt

set.seed(20260831)
source(file.path("analysis", "scripts", "00_config.R"))
library(survival)
library(glmnet)
library(MASS)
library(compareC)

log_path <- file.path(OUTPUT_DIR, "07_continuous_primary_log.txt")
log_con <- file(log_path, open = "wt", encoding = "UTF-8")
logmsg <- function(...) { m <- paste0(...); cat(m, "\n"); writeLines(m, log_con) }
logmsg("07_continuous_primary.R run at ", format(Sys.time(), "%Y-%m-%d %H:%M:%S"))

a <- readRDS(file.path(DERIVED_DIR, "tavi_mac_analysis.rds"))
sel <- readRDS(file.path(DERIVED_DIR, "model_selection.rds"))
cand <- sel$candidates
logmsg("Candidate pool (from 04_cox.R): ", paste(cand, collapse = ", "))

cc <- a[complete.cases(a[, c(cand, "log2_mac", "tte_days", "death")]), ]
logmsg("Fixed complete-case dataset: N=", nrow(cc), ", events=", sum(cc$death))

fmt_p <- function(p) ifelse(p < 0.001, "<0.001", sprintf("%.3f", p))
hr_rows <- function(fit, model = NULL) {
  s <- summary(fit); ci <- s$conf.int; co <- s$coefficients
  r <- data.frame(term = rownames(co),
                  `HR (95% CI)` = sprintf("%.2f (%.2f-%.2f)", ci[, "exp(coef)"],
                                          ci[, "lower .95"], ci[, "upper .95"]),
                  `p-value` = fmt_p(co[, "Pr(>|z|)"]), check.names = FALSE)
  if (!is.null(model)) r <- cbind(model = model, r)
  r
}
fit_with <- function(covs, expo = "log2_mac", data = cc) {
  coxph(as.formula(paste("Surv(tte_days, death) ~", expo,
                         if (length(covs)) paste("+", paste(covs, collapse=" + ")) else "")),
        data = data)
}

## ---------- univariable continuous exposure ----------
u <- coxph(Surv(tte_days, death) ~ log2_mac, data = a)
logmsg("Univariable log2 MAC: ", hr_rows(u)$`HR (95% CI)`,
       " p=", hr_rows(u)$`p-value`, " (N=", u$n, ")")

## ---------- primary: backward selection, exposure forced ----------
full_fit <- fit_with(cand)
write.csv(hr_rows(full_fit)[, 1:3], file.path(OUTPUT_DIR, "table3c_full.csv"),
          row.names = FALSE, fileEncoding = "UTF-8")
logmsg("EPV full model: ", round(sum(cc$death) / length(coef(full_fit)), 1))

covs <- cand
repeat {
  fit <- fit_with(covs)
  p <- summary(fit)$coefficients[, "Pr(>|z|)"]
  p <- p[names(p) != "log2_mac"]
  if (!length(p) || max(p) < 0.05) break
  drop_v <- names(which.max(p))
  logmsg("  backward step: drop ", drop_v, " (p=", sprintf("%.3f", max(p)), ")")
  covs <- setdiff(covs, drop_v)
}
logmsg("Final selected covariates: ", paste(covs, collapse = ", "))
final_fit <- fit_with(covs)
write.csv(hr_rows(final_fit)[, 1:3], file.path(OUTPUT_DIR, "table3c_final.csv"),
          row.names = FALSE, fileEncoding = "UTF-8")
logmsg("Primary continuous model: N=", final_fit$n, ", events=", final_fit$nevent)
saveRDS(list(selected = covs, cc_ids = cc$id),
        file.path(DERIVED_DIR, "model_selection_continuous.rds"))

## ---------- nonlinearity: spline vs linear (LR test) ----------
lin <- fit_with(covs)
# interior knots at tertiles of the POSITIVE volumes (51% of log2_mac is 0,
# so default quantile knots would collapse onto the boundary)
kn <- quantile(cc$log2_mac[cc$mac_vol > 0], c(1/3, 2/3))
spl <- coxph(as.formula(paste(
  "Surv(tte_days, death) ~ splines::ns(log2_mac, knots = kn) +",
  paste(covs, collapse = " + "))), data = cc)
lr <- anova(lin, spl)
logmsg("Nonlinearity LR test (ns df=3 vs linear): p=",
       fmt_p(lr[2, "Pr(>|Chi|)"]))

## ---------- secondary: median-split categories ----------
catfit <- fit_with(covs, expo = "mac_group_med")
write.csv(hr_rows(catfit)[, 1:3],
          file.path(OUTPUT_DIR, "table3c_categories.csv"),
          row.names = FALSE, fileEncoding = "UTF-8")
logmsg("Median-split categorical model: N=", catfit$n)

## ---------- sensitivity: old 717.2 grouping (data-derived label) ----------
oldfit <- fit_with(covs, expo = "mac_group")
mx <- maxstat::maxstat.test(Surv(tte_days, death) ~ mac_vol, data = a,
                            smethod = "LogRank", pmethod = "Lau92",
                            minprop = 0.05, maxprop = 0.95)
logmsg("717.2-grouping sensitivity (DATA-DERIVED cutpoint): maxstat estimated cut=",
       round(mx$estimate, 1), ", adjusted p=", format.pval(mx$p.value, digits = 3))

## ---------- S1-S3 with continuous exposure ----------
out <- list(
  primary = hr_rows(final_fit, "Primary (backward, log2 MAC forced)"),
  categories = hr_rows(catfit, "Secondary categorical (median split)"),
  old717 = hr_rows(oldfit, "Sensitivity: 717.2 grouping (data-derived cutpoint)"))

s1 <- coxph(Surv(tte_days, death) ~ sts + ckd + afib + log2_mac, data = a)
out$s1 <- hr_rows(s1, "S1 pre-specified (STS+CKD+A.fib)")
logmsg("S1: N=", s1$n)

vars2 <- c("age", "sex_female", "bmi", "sts", "htn", "dm", "ckd", "copd",
           "pad", "cad", "afib", "prev_stroke", "prev_mi", "prev_cardiac_op",
           "tc_10", "tg_10", "ldl_10", "hdl_10", "lvef", "mdpg_ge5")
cc2 <- a[complete.cases(a[, c(vars2, "log2_mac", "tte_days", "death")]) &
           a$tte_days > 0, ]
X <- as.matrix(cbind(cc2[, vars2], log2_mac = cc2$log2_mac))
pen <- c(rep(1, length(vars2)), 0)
cvfit <- cv.glmnet(X, Surv(cc2$tte_days, cc2$death), family = "cox",
                   alpha = 1, nfolds = 10, penalty.factor = pen)
co2 <- coef(cvfit, s = "lambda.1se")
sel_lasso <- setdiff(rownames(co2)[as.numeric(co2) != 0], "log2_mac")
logmsg("S2 LASSO selected: ",
       if (length(sel_lasso)) paste(sel_lasso, collapse = ", ") else "(none)")
s2 <- fit_with(sel_lasso, data = cc2)
out$s2 <- hr_rows(s2, "S2 LASSO-selected (refit)")

# fit at top level with an explicit data symbol (stepAIC re-evaluates the call)
full_for_step <- coxph(as.formula(paste("Surv(tte_days, death) ~ log2_mac +",
                                        paste(cand, collapse = " + "))),
                       data = cc)
s3 <- stepAIC(full_for_step, direction = "backward",
              scope = list(lower = ~ log2_mac), trace = FALSE)
logmsg("S3 AIC kept: ", paste(attr(terms(s3), "term.labels"), collapse = ", "))
out$s3 <- hr_rows(s3, "S3 AIC backward")

res <- do.call(rbind, out)
write.csv(res, file.path(OUTPUT_DIR, "sensitivity_continuous.csv"),
          row.names = FALSE, fileEncoding = "UTF-8")
mac <- res[grepl("log2_mac|mac_group", res$term), ]
for (i in seq_len(nrow(mac)))
  logmsg("  ", mac$model[i], " | ", mac$term[i], ": ", mac$`HR (95% CI)`[i],
         " p=", mac$`p-value`[i])

## ---------- incremental value (C-index) ----------
pair_cindex <- function(add_term, label) {
  f1 <- coxph(as.formula(paste("Surv(tte_days, death) ~",
                               paste(covs, collapse = " + "))), data = cc)
  f2 <- coxph(as.formula(paste("Surv(tte_days, death) ~",
                               paste(covs, collapse = " + "), "+", add_term)),
              data = cc)
  c1 <- concordance(f1); c2 <- concordance(f2)
  cmp <- compareC(cc$tte_days, cc$death, predict(f1, type = "lp"),
                  predict(f2, type = "lp"))
  logmsg(label, ": C ", sprintf("%.3f -> %.3f, compareC p=%.3f",
                                c1$concordance, c2$concordance, cmp$pval))
  data.frame(pair = label,
             model = c(paste("Model 1:", paste(covs, collapse = " + ")),
                       paste("Model 2: Model 1 +", add_term)),
             C_index = sprintf("%.3f", c(c1$concordance, c2$concordance)),
             SE = sprintf("%.3f", sqrt(c(c1$var, c2$var))),
             N = nrow(cc), events = sum(cc$death),
             delta_C_p = c("", sprintf("%.3f", cmp$pval)))
}
t4c <- rbind(pair_cindex("log2_mac", "Primary: + log2 MAC (continuous)"),
             pair_cindex("mac_group_med", "Secondary: + median-split group"))
write.csv(t4c, file.path(OUTPUT_DIR, "table4c.csv"), row.names = FALSE,
          fileEncoding = "UTF-8")

## ---------- assumption checks ----------
sink(file.path(OUTPUT_DIR, "assumption_checks_continuous.txt"))
cat("=== cox.zph, primary continuous model ===\n"); print(cox.zph(final_fit))
cat("\n=== cox.zph, categorical (median) model ===\n"); print(cox.zph(catfit))
cat("\n=== VIF, primary model ===\n")
print(round(diag(solve(cor(model.matrix(final_fit)))), 3))
sink()
logmsg("assumption_checks_continuous.txt written")

writeLines("\n--- sessionInfo() ---", log_con)
writeLines(capture.output(sessionInfo()), log_con)
close(log_con)
