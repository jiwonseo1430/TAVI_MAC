# 01_deidentify.R — build the de-identified analysis-ready dataset.
#
# Input : <data_dir>/raw/total 0408.xlsx  (sheet "total", 525 patients x 59 cols)
# Output: <data_dir>/derived/tavi_mac_deid.rds
#         <data_dir>/derived/tavi_mac_deid.csv
#         <data_dir>/output/01_deidentify_log.txt   (log + sessionInfo)
#
# Column disposition (per approved plan/setup_infra_plan.md §5):
#   DROP  (실명)등록번호        direct identifier
#   DROP  (실명)생년월일        direct identifier (age at imaging already present)
#   DROP  엑셀/스캔유무          data-source bookkeeping, not analysis
#   DROP  TAVI_date, CT date, death_date, last_FU_date, death or last F/U
#         calendar dates are quasi-identifiers; the derived quantities
#         (영상 검사시 나이, time to event) are kept. Before dropping,
#         'time to event' is validated against the date columns (log only).
#   KEEP  all remaining columns, including 'No' as the study ID.

set.seed(20260831)

source(file.path("analysis", "scripts", "00_config.R"))

log_path <- file.path(OUTPUT_DIR, "01_deidentify_log.txt")
log_con <- file(log_path, open = "wt", encoding = "UTF-8")
logmsg <- function(...) {
  msg <- paste0(...)
  cat(msg, "\n")
  writeLines(msg, log_con)
}

logmsg("01_deidentify.R run at ", format(Sys.time(), "%Y-%m-%d %H:%M:%S"))

raw_file <- file.path(RAW_DIR, "total 0408.xlsx")
stopifnot(file.exists(raw_file))

dat <- readxl::read_excel(raw_file, sheet = "total")
logmsg("Raw data: ", nrow(dat), " rows x ", ncol(dat), " cols")

id_cols   <- grep("^\\(실명\\)", names(dat), value = TRUE)
book_cols <- grep("엑셀/스캔유무", names(dat), value = TRUE)
date_cols <- intersect(
  c("TAVI_date", "CT date", "death_date", "last_FU_date", "death or last F/U"),
  names(dat)
)
drop_cols <- c(id_cols, book_cols, date_cols)

stopifnot(length(id_cols) == 2)  # both direct identifiers must be found
logmsg("Dropping ", length(drop_cols), " columns: ",
       paste(drop_cols, collapse = " | "))

# --- validate 'time to event' against date columns before dropping (log only)
tryCatch({
  # 'death or last F/U' is stored as character: mostly 5-digit Excel serial
  # dates, some ISO "YYYY-MM-DD" strings — parse both.
  parse_mixed_date <- function(x) {
    x <- as.character(x)
    out <- rep(as.Date(NA), length(x))
    serial <- grepl("^\\d{5}$", x)
    out[serial] <- as.Date(as.numeric(x[serial]), origin = "1899-12-30")
    iso <- grepl("^\\d{4}-\\d{2}-\\d{2}", x)
    out[iso] <- as.Date(substr(x[iso], 1, 10))
    out
  }
  t_start <- as.Date(dat[["TAVI_date"]])
  t_end   <- parse_mixed_date(dat[["death or last F/U"]])
  tte     <- suppressWarnings(as.numeric(dat[["time to event"]]))
  d_days  <- as.numeric(t_end - t_start)
  ok      <- !is.na(d_days) & !is.na(tte)
  logmsg("time-to-event validation: n with both dates and tte = ", sum(ok))
  if (sum(ok) > 2) {
    logmsg("  corr(tte, end - start in days) = ",
           round(cor(tte[ok], d_days[ok]), 4))
    logmsg("  median ratio tte/days = ",
           round(median(tte[ok] / d_days[ok], na.rm = TRUE), 4),
           "  (1 => tte in days)")
    mismatch <- sum(abs(tte[ok] - d_days[ok]) > 31)
    logmsg("  rows where |tte - days| > 31: ", mismatch,
           " (only meaningful if tte is in days)")
  }
}, error = function(e) logmsg("  validation skipped: ", conditionMessage(e)))

deid <- dat[, setdiff(names(dat), drop_cols)]

# safety net: no remaining column may look like an identifier or a date
stopifnot(!any(grepl("실명|등록번호|생년월일", names(deid))))
stopifnot(!any(vapply(deid, function(x)
  inherits(x, c("Date", "POSIXct", "POSIXt")), logical(1))))

logmsg("De-identified data: ", nrow(deid), " rows x ", ncol(deid), " cols")

saveRDS(deid, file.path(DERIVED_DIR, "tavi_mac_deid.rds"))
write.csv(deid, file.path(DERIVED_DIR, "tavi_mac_deid.csv"),
          row.names = FALSE, fileEncoding = "UTF-8", na = "")
logmsg("Written: derived/tavi_mac_deid.rds, derived/tavi_mac_deid.csv")

writeLines("\n--- sessionInfo() ---", log_con)
writeLines(capture.output(sessionInfo()), log_con)
close(log_con)
cat("Log written to", log_path, "\n")
