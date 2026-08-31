# 06_km_figure.R — Kaplan-Meier survival by MAC group (Figure 1).
# Time axis in years (tte_days / 365.25); log-rank p; number-at-risk table.
# Output: fig1_km.png (300 dpi), fig1_km.pdf, 06_km_figure_log.txt

set.seed(20260831)
source(file.path("analysis", "scripts", "00_config.R"))
library(survival)
library(survminer)

log_path <- file.path(OUTPUT_DIR, "06_km_figure_log.txt")
log_con <- file(log_path, open = "wt", encoding = "UTF-8")
logmsg <- function(...) { m <- paste0(...); cat(m, "\n"); writeLines(m, log_con) }
logmsg("06_km_figure.R run at ", format(Sys.time(), "%Y-%m-%d %H:%M:%S"))

a <- readRDS(file.path(DERIVED_DIR, "tavi_mac_analysis.rds"))
a$tte_years <- a$tte_days / 365.25

fit <- survfit(Surv(tte_years, death) ~ mac_group, data = a)
lr <- survdiff(Surv(tte_years, death) ~ mac_group, data = a)
logmsg("Log-rank chisq=", sprintf("%.2f", lr$chisq), ", df=2, p=",
       format.pval(pchisq(lr$chisq, 2, lower.tail = FALSE), digits = 3))

p <- ggsurvplot(
  fit, data = a,
  risk.table = TRUE, pval = TRUE, conf.int = FALSE,
  xlab = "Years after TAVI", ylab = "Survival probability",
  legend.title = "MAC", legend.labs = c("None", "Low", "High"),
  palette = c("#2E9FDF", "#E7B800", "#FC4E07"),
  break.time.by = 1, xlim = c(0, 8),
  risk.table.height = 0.28, censor = TRUE)

png(file.path(OUTPUT_DIR, "fig1_km.png"), width = 2400, height = 2100,
    res = 300)
print(p)
dev.off()
pdf(file.path(OUTPUT_DIR, "fig1_km.pdf"), width = 8, height = 7)
print(p)
dev.off()
logmsg("fig1_km.png / fig1_km.pdf written")

writeLines("\n--- sessionInfo() ---", log_con)
writeLines(capture.output(sessionInfo()), log_con)
close(log_con)
