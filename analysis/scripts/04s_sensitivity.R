# 04s_sensitivity.R — covariate-selection sensitivity analyses (plan §4a):
#   S1 pre-specified clinical model: STS + CKD + A.fib + MAC group
#   S2 LASSO Cox (glmnet): all Table-2 variables, MAC dummies unpenalized,
#      lambda.1se by 10-fold CV (fixed seed), selected set refit in coxph
#   S3 AIC backward (MASS::stepAIC) on the same fixed complete-case dataset
#      and candidate pool as the primary model; MAC group forced (lower scope)
#
# Output: sensitivity_models.csv (all three, long format), 04s_sensitivity_log.txt

set.seed(20260831)
source(file.path("analysis", "scripts", "00_config.R"))
library(survival)
library(glmnet)
library(MASS)

log_path <- file.path(OUTPUT_DIR, "04s_sensitivity_log.txt")
log_con <- file(log_path, open = "wt", encoding = "UTF-8")
logmsg <- function(...) { m <- paste0(...); cat(m, "\n"); writeLines(m, log_con) }
logmsg("04s_sensitivity.R run at ", format(Sys.time(), "%Y-%m-%d %H:%M:%S"))

a <- readRDS(file.path(DERIVED_DIR, "tavi_mac_analysis.rds"))
sel <- readRDS(file.path(DERIVED_DIR, "model_selection.rds"))

fmt_p <- function(p) ifelse(p < 0.001, "<0.001", sprintf("%.3f", p))
hr_rows <- function(fit, model) {
  s <- summary(fit); ci <- s$conf.int; co <- s$coefficients
  data.frame(model = model, term = rownames(co),
             `HR (95% CI)` = sprintf("%.2f (%.2f-%.2f)", ci[, "exp(coef)"],
                                     ci[, "lower .95"], ci[, "upper .95"]),
             `p-value` = fmt_p(co[, "Pr(>|z|)"]), check.names = FALSE)
}
out <- list()

## ---------- S1: pre-specified clinical model ----------
s1 <- coxph(Surv(tte_days, death) ~ sts + ckd + afib + mac_group, data = a)
out$s1 <- hr_rows(s1, "S1 pre-specified (STS+CKD+A.fib)")
logmsg("S1: N=", s1$n, ", events=", s1$nevent)

## ---------- S2: LASSO Cox ----------
vars2 <- c("age", "sex_female", "bmi", "sts", "htn", "dm", "ckd", "copd",
           "pad", "cad", "afib", "prev_stroke", "prev_mi", "prev_cardiac_op",
           "tc_10", "tg_10", "ldl_10", "hdl_10", "lvef", "mdpg_ge5")
cc2 <- a[complete.cases(a[, c(vars2, "mac_group", "tte_days", "death")]) &
           a$tte_days > 0, ]
logmsg("S2 complete-case: N=", nrow(cc2), ", events=", sum(cc2$death),
       " (glmnet requires time > 0; excluded tte_days==0: ",
       sum(a$tte_days == 0, na.rm = TRUE), ")")
X <- model.matrix(~ . - 1, data = cbind(cc2[, vars2],
                                        model.matrix(~ mac_group, cc2)[, -1]))
pen <- rep(1, ncol(X)); pen[grepl("mac_group", colnames(X))] <- 0
y <- Surv(cc2$tte_days, cc2$death)
cvfit <- cv.glmnet(X, y, family = "cox", alpha = 1, nfolds = 10,
                   penalty.factor = pen)
co <- coef(cvfit, s = "lambda.1se")
sel_lasso <- setdiff(rownames(co)[as.numeric(co) != 0],
                     grep("mac_group", rownames(co), value = TRUE))
logmsg("S2 LASSO (lambda.1se=", signif(cvfit$lambda.1se, 3),
       ") selected: ", if (length(sel_lasso)) paste(sel_lasso, collapse = ", ") else "(none)")
f2 <- as.formula(paste("Surv(tte_days, death) ~ mac_group",
                       if (length(sel_lasso)) paste("+", paste(sel_lasso, collapse = " + ")) else ""))
s2 <- coxph(f2, data = cc2)
out$s2 <- hr_rows(s2, "S2 LASSO-selected (refit)")
logmsg("S2 refit: N=", s2$n, ", events=", s2$nevent)

## ---------- S3: AIC backward on primary candidate pool ----------
cc3 <- a[a$id %in% sel$cc_ids, ]
full <- coxph(as.formula(paste("Surv(tte_days, death) ~ mac_group +",
                               paste(sel$candidates, collapse = " + "))),
              data = cc3)
s3 <- stepAIC(full, direction = "backward",
              scope = list(lower = ~ mac_group), trace = FALSE)
logmsg("S3 AIC-backward kept: ",
       paste(attr(terms(s3), "term.labels"), collapse = ", "))
out$s3 <- hr_rows(s3, "S3 AIC backward")
logmsg("S3: N=", s3$n, ", events=", s3$nevent)

res <- do.call(rbind, out)
write.csv(res, file.path(OUTPUT_DIR, "sensitivity_models.csv"),
          row.names = FALSE, fileEncoding = "UTF-8")
logmsg("sensitivity_models.csv written")

# MAC HRs side by side for quick comparison
mac <- res[grepl("mac_group", res$term), ]
for (i in seq_len(nrow(mac)))
  logmsg("  ", mac$model[i], " | ", mac$term[i], ": ", mac$`HR (95% CI)`[i],
         " p=", mac$`p-value`[i])

writeLines("\n--- sessionInfo() ---", log_con)
writeLines(capture.output(sessionInfo()), log_con)
close(log_con)
