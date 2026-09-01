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

## ---------- Figure 1 (2-panel, decision 2026-09-01): whole-period KM ----------
# A = No MAC vs MAC (binary), B = None/Low/High (median split).
# x-axis capped at 7 years (at-risk n beyond 7 y is 0-2).
a$any_mac_f <- factor(a$any_mac, levels = 0:1, labels = c("No MAC", "MAC"))

km_panel <- function(gvar, labs, pal, title) {
  fit <- eval(bquote(survfit(Surv(tte_years, death) ~ .(as.name(gvar)),
                             data = a)))
  df <- length(labs) - 1
  p <- pchisq(eval(bquote(survdiff(Surv(tte_years, death) ~ .(as.name(gvar)),
                                   data = a)))$chisq, df, lower.tail = FALSE)
  logmsg("Fig1 ", title, ": log-rank p=", format.pval(p, digits = 3))
  ptxt <- if (p < 1e-4) "p < 0.0001" else sprintf("p = %.3f", p)
  ggsurvplot(fit, data = a, risk.table = TRUE, pval = ptxt,
             xlab = "Years after TAVI", ylab = "Survival probability",
             legend.title = "", legend.labs = labs, palette = pal,
             break.time.by = 1, xlim = c(0, 7),
             risk.table.height = 0.3, title = title)
}
k1 <- km_panel("any_mac_f", c("No MAC", "MAC"),
               c("#2E9FDF", "#FC4E07"), "A. MAC presence")
k2 <- km_panel("mac_group_med", c("No MAC", "Low MAC", "High MAC"),
               c("#2E9FDF", "#E7B800", "#FC4E07"), "B. MAC volume group")
g1 <- ggpubr::ggarrange(k1$plot + theme(legend.position = "top"),
                        k2$plot + theme(legend.position = "top"),
                        k1$table, k2$table,
                        ncol = 2, nrow = 2, heights = c(3, 1.2))
png(file.path(OUTPUT_DIR, "fig1_km_2panel.png"), width = 3600, height = 2000,
    res = 300)
print(g1); dev.off()
pdf(file.path(OUTPUT_DIR, "fig1_km_2panel.pdf"), width = 12, height = 6.7)
print(g1); dev.off()
logmsg("fig1_km_2panel written")

## ---------- adjusted spline dose-response ----------
# fig2_spline (2-panel, decision 2026-09-01): A = 1-year mortality (Cox
# censored at 1 y), B = whole follow-up. Panel B is the average HR under the
# PH violation; its nonlinearity p documents why the 1-y frame leads.
covs <- selc$selected
cc <- a[a$id %in% selc$cc_ids, ]
kn <- quantile(cc$log2_mac[cc$mac_vol > 0], c(1/3, 2/3))
cc$t1 <- pmin(cc$tte_days, 365.25); cc$t1[cc$t1 == 0] <- 0.5
cc$e1 <- as.integer(cc$death == 1 & cc$tte_days <= 365.25)

spline_panel <- function(tvar, evar, stem, ylab, title) {
  sfit <- coxph(as.formula(paste(
    "Surv(", tvar, ",", evar, ") ~ splines::ns(log2_mac, knots = kn) +",
    paste(covs, collapse = " + "))), data = cc)
  lfit <- coxph(as.formula(paste(
    "Surv(", tvar, ",", evar, ") ~ log2_mac +",
    paste(covs, collapse = " + "))), data = cc)
  ci <- summary(lfit)$conf.int
  logmsg(stem, ": events=", sfit$nevent,
         sprintf("; linear log2 MAC HR %.2f (%.2f-%.2f)", ci[1, 1], ci[1, 3], ci[1, 4]),
         "; nonlinearity p=",
         format.pval(anova(lfit, sfit)[2, "Pr(>|Chi|)"], digits = 3))
  grid_vol <- c(0, 2^seq(log2(1), log2(8000), length.out = 200) - 1)
  nd <- cc[rep(1, length(grid_vol)), ]        # covariates fixed (cancel in HR)
  nd$log2_mac <- log2(grid_vol + 1)
  tt <- predict(sfit, newdata = nd, type = "terms", se.fit = TRUE)
  scol <- grep("ns\\(log2_mac", colnames(tt$fit))
  lp <- tt$fit[, scol]; se <- tt$se.fit[, scol]
  df <- data.frame(vol = grid_vol, hr = exp(lp - lp[1]),
                   lo = exp((lp - lp[1]) - 1.96 * sqrt(se^2 + se[1]^2)),
                   hi = exp((lp - lp[1]) + 1.96 * sqrt(se^2 + se[1]^2)))
  logmsg("  HR at vol 100/717/2000: ",
         paste(sprintf("%.2f", df$hr[sapply(c(100, 717, 2000),
               function(v) which.min(abs(df$vol - v)))]), collapse = " / "))
  g <- ggplot(df, aes(vol + 1, hr)) +
    geom_ribbon(aes(ymin = lo, ymax = hi), alpha = 0.15, fill = "#FC4E07") +
    geom_line(linewidth = 1, color = "#FC4E07") +
    geom_hline(yintercept = 1, linetype = 2) +
    geom_rug(data = data.frame(vol = cc$mac_vol[cc$mac_vol > 0]),
             aes(x = vol + 1), inherit.aes = FALSE, sides = "b",
             alpha = 0.25, length = unit(0.02, "npc")) +
    scale_x_log10(breaks = c(1, 11, 101, 1001, 5001),
                  labels = c("0", "10", "100", "1000", "5000")) +
    scale_y_log10(limits = c(0.1, 130)) +
    labs(x = expression(paste("MAC volume (", mm^3, ")")), y = ylab,
         title = title) +
    theme_classic(base_size = 12)
  g
}
g2a <- spline_panel("t1", "e1", "fig2A (0-1y)",
                    "Adjusted HR for 1-year mortality (95% CI) vs no MAC",
                    "A. First-year mortality")
g2b <- spline_panel("tte_days", "death", "fig2B (whole follow-up)",
                    "Adjusted HR (95% CI) vs no MAC",
                    "B. Whole follow-up")
g2 <- ggpubr::ggarrange(g2a, g2b, ncol = 2)
png(file.path(OUTPUT_DIR, "fig2_spline.png"), width = 3600, height = 1500,
    res = 300)
print(g2); dev.off()
pdf(file.path(OUTPUT_DIR, "fig2_spline.pdf"), width = 12, height = 5)
print(g2); dev.off()
logmsg("fig2_spline (2-panel A/B) written")

## ---------- 1-year landmark KM (post-hoc, plan post-hoc log 2026-09-01) ----------
# Panel A: truncated at 1 year (months axis). Panel B: 1-year survivors,
# clock restarted at the landmark. Two versions: 3-group (median split;
# manuscript Figure 3) and binary (supplement).
LM <- 365.25
a$t_a <- pmin(a$tte_days, LM) / 30.4375
a$e_a <- as.integer(a$death == 1 & a$tte_days <= LM)
b <- a[a$tte_days > LM, ]
b$t_b <- (b$tte_days - LM) / 365.25

landmark_fig <- function(gvar, labs, pal, stem) {
  # embed the grouping symbol in the call so survminer can re-evaluate it
  fa <- eval(bquote(survfit(Surv(t_a, e_a) ~ .(as.name(gvar)), data = a)))
  fb <- eval(bquote(survfit(Surv(t_b, death) ~ .(as.name(gvar)), data = b)))
  df <- nlevels(factor(a[[gvar]])) - 1
  pa <- pchisq(survdiff(as.formula(paste("Surv(t_a, e_a) ~", gvar)),
                        data = a)$chisq, df, lower.tail = FALSE)
  pb <- pchisq(survdiff(as.formula(paste("Surv(t_b, death) ~", gvar)),
                        data = b)$chisq, df, lower.tail = FALSE)
  logmsg(stem, ": panel A log-rank p=", format.pval(pa, digits = 3),
         "; panel B (n=", nrow(b), ") p=", format.pval(pb, digits = 3))
  # pass pre-computed log-rank p as text (survminer cannot re-evaluate the
  # formula built inside this function)
  ptxt <- function(p) if (p < 1e-4) "p < 0.0001" else sprintf("p = %.3f", p)
  gA <- ggsurvplot(fa, data = a, risk.table = TRUE, pval = ptxt(pa),
                   pval.coord = c(0.5, 0.78),
                   xlab = "Months after TAVI", ylab = "Survival probability",
                   legend.title = "", legend.labs = labs, palette = pal,
                   break.time.by = 3, xlim = c(0, 12), ylim = c(0.75, 1),
                   risk.table.height = 0.32, title = "A. First year after TAVI")
  gB <- ggsurvplot(fb, data = b, risk.table = TRUE, pval = ptxt(pb),
                   pval.coord = c(0.3, 0.55),
                   xlab = "Years after 1-year landmark",
                   ylab = "Survival probability",
                   legend.title = "", legend.labs = labs, palette = pal,
                   break.time.by = 1, xlim = c(0, 5), ylim = c(0.5, 1),
                   risk.table.height = 0.32,
                   title = "B. Conditional on 1-year survival")
  gg <- ggpubr::ggarrange(gA$plot + theme(legend.position = "top"),
                          gB$plot + theme(legend.position = "top"),
                          gA$table, gB$table,
                          ncol = 2, nrow = 2, heights = c(3, 1.2))
  png(file.path(OUTPUT_DIR, paste0(stem, ".png")), width = 3600, height = 2000,
      res = 300)
  print(gg); dev.off()
  pdf(file.path(OUTPUT_DIR, paste0(stem, ".pdf")), width = 12, height = 6.7)
  print(gg); dev.off()
  logmsg(stem, " written")
}
landmark_fig("mac_group_med", c("No MAC", "Low MAC", "High MAC"),
             c("#2E9FDF", "#E7B800", "#FC4E07"), "fig3_landmark_3group")
landmark_fig("any_mac_f", c("No MAC", "MAC"),
             c("#2E9FDF", "#FC4E07"), "figS_landmark_binary")

writeLines("\n--- sessionInfo() ---", log_con)
writeLines(capture.output(sessionInfo()), log_con)
close(log_con)
