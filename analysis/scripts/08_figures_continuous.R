# 08_figures_continuous.R — Amendment-1 figures:
#   fig1_km_med — KM by median-split MAC group (None/Low/High = 269/128/128)
#   fig2_spline — adjusted dose-response: HR vs MAC volume (ns df=3 on
#                 log2(vol+1)), reference = 0 mm3, 95% CI, rug of volumes
# Output: fig1_km_med.png/.pdf, fig2_spline.png/.pdf, 08_figures_log.txt

set.seed(20260831)
source(file.path("analysis", "scripts", "00_config.R"))
library(survival)
library(survminer)
library(ggplot2)

log_path <- file.path(OUTPUT_DIR, "08_figures_log.txt")
log_con <- file(log_path, open = "wt", encoding = "UTF-8")
logmsg <- function(...) { m <- paste0(...); cat(m, "\n"); writeLines(m, log_con) }
logmsg("08_figures_continuous.R run at ", format(Sys.time(), "%Y-%m-%d %H:%M:%S"))

a <- readRDS(file.path(DERIVED_DIR, "tavi_mac_analysis.rds"))
selc <- readRDS(file.path(DERIVED_DIR, "model_selection_continuous.rds"))
a$tte_years <- a$tte_days / 365.25

## ---------- KM binary: No MAC vs MAC (Amendment 2; manuscript Figure 1) ----------
a$any_mac_f <- factor(a$any_mac, levels = 0:1, labels = c("No MAC", "MAC"))
fitb <- survfit(Surv(tte_years, death) ~ any_mac_f, data = a)
lrb <- survdiff(Surv(tte_years, death) ~ any_mac_f, data = a)
logmsg("Log-rank (binary): chisq=", sprintf("%.2f", lrb$chisq), ", p=",
       format.pval(pchisq(lrb$chisq, 1, lower.tail = FALSE), digits = 3))
pb <- ggsurvplot(fitb, data = a, risk.table = TRUE, pval = TRUE,
                 xlab = "Years after TAVI", ylab = "Survival probability",
                 legend.title = "", legend.labs = c("No MAC", "MAC"),
                 palette = c("#2E9FDF", "#FC4E07"),
                 break.time.by = 1, xlim = c(0, 8), risk.table.height = 0.25)
png(file.path(OUTPUT_DIR, "fig1_km_binary.png"), width = 2400, height = 2100, res = 300)
print(pb); dev.off()
pdf(file.path(OUTPUT_DIR, "fig1_km_binary.pdf"), width = 8, height = 7)
print(pb); dev.off()
logmsg("fig1_km_binary written")

## ---------- KM by median-split group (supplement) ----------
fit <- survfit(Surv(tte_years, death) ~ mac_group_med, data = a)
lr <- survdiff(Surv(tte_years, death) ~ mac_group_med, data = a)
logmsg("Log-rank (median groups): chisq=", sprintf("%.2f", lr$chisq),
       ", p=", format.pval(pchisq(lr$chisq, 2, lower.tail = FALSE), digits = 3))
p <- ggsurvplot(fit, data = a, risk.table = TRUE, pval = TRUE,
                xlab = "Years after TAVI", ylab = "Survival probability",
                legend.title = "MAC volume", legend.labs = c("None", "Low", "High"),
                palette = c("#2E9FDF", "#E7B800", "#FC4E07"),
                break.time.by = 1, xlim = c(0, 8), risk.table.height = 0.28)
png(file.path(OUTPUT_DIR, "fig1_km_med.png"), width = 2400, height = 2100, res = 300)
print(p); dev.off()
pdf(file.path(OUTPUT_DIR, "fig1_km_med.pdf"), width = 8, height = 7)
print(p); dev.off()
logmsg("fig1_km_med written")

## ---------- adjusted spline dose-response ----------
covs <- selc$selected
cc <- a[a$id %in% selc$cc_ids, ]
kn <- quantile(cc$log2_mac[cc$mac_vol > 0], c(1/3, 2/3))
sfit <- coxph(as.formula(paste(
  "Surv(tte_days, death) ~ splines::ns(log2_mac, knots = kn) +",
  paste(covs, collapse = " + "))), data = cc)

grid_vol <- c(0, 2^seq(log2(1), log2(8000), length.out = 200) - 1)
nd <- cc[rep(1, length(grid_vol)), ]          # covariates fixed (cancel in HR)
nd$log2_mac <- log2(grid_vol + 1)
tt <- predict(sfit, newdata = nd, type = "terms", se.fit = TRUE)
scol <- grep("ns\\(log2_mac", colnames(tt$fit))
lp  <- tt$fit[, scol];  se <- tt$se.fit[, scol]
lp0 <- lp[1]                                   # reference: volume 0
df <- data.frame(vol = grid_vol,
                 hr = exp(lp - lp0),
                 lo = exp((lp - lp0) - 1.96 * sqrt(se^2 + se[1]^2)),
                 hi = exp((lp - lp0) + 1.96 * sqrt(se^2 + se[1]^2)))
logmsg("Spline HR at vol=100: ", sprintf("%.2f", df$hr[which.min(abs(df$vol-100))]),
       " | 717: ", sprintf("%.2f", df$hr[which.min(abs(df$vol-717))]),
       " | 2000: ", sprintf("%.2f", df$hr[which.min(abs(df$vol-2000))]))

g <- ggplot(df, aes(vol + 1, hr)) +
  geom_ribbon(aes(ymin = lo, ymax = hi), alpha = 0.15, fill = "#FC4E07") +
  geom_line(linewidth = 1, color = "#FC4E07") +
  geom_hline(yintercept = 1, linetype = 2) +
  geom_rug(data = data.frame(vol = cc$mac_vol[cc$mac_vol > 0]),
           aes(x = vol + 1), inherit.aes = FALSE, sides = "b",
           alpha = 0.25, length = unit(0.02, "npc")) +
  scale_x_log10(breaks = c(1, 11, 101, 1001, 5001),
                labels = c("0", "10", "100", "1000", "5000")) +
  scale_y_log10() +
  labs(x = expression(paste("MAC volume (", mm^3, ")")),
       y = "Adjusted hazard ratio (95% CI) vs no MAC",
       caption = paste("Cox model: ns(log2(vol+1), df=3) +",
                       paste(covs, collapse = ", "))) +
  theme_classic(base_size = 13)
png(file.path(OUTPUT_DIR, "fig2_spline.png"), width = 2100, height = 1600, res = 300)
print(g); dev.off()
pdf(file.path(OUTPUT_DIR, "fig2_spline.pdf"), width = 7, height = 5.3)
print(g); dev.off()
logmsg("fig2_spline written")

writeLines("\n--- sessionInfo() ---", log_con)
writeLines(capture.output(sessionInfo()), log_con)
close(log_con)
