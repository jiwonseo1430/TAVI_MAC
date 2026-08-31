# 00_config.R — resolve data directory; source()d by every analysis script.
#
# Resolution order:
#   1. environment variable TAVI_MAC_DATA
#   2. config/config.yml (key: data_dir), relative to the project root
#
# The project root is taken as the current working directory, which must be
# the repository root (run scripts via Rscript from the repo root).

resolve_data_dir <- function() {
  env <- Sys.getenv("TAVI_MAC_DATA", unset = "")
  if (nzchar(env)) {
    dir <- env
  } else {
    cfg_path <- file.path("config", "config.yml")
    if (!file.exists(cfg_path)) {
      stop("No TAVI_MAC_DATA env var and no config/config.yml. ",
           "Copy config/config.example.yml to config/config.yml and set data_dir.")
    }
    cfg <- yaml::read_yaml(cfg_path)
    if (is.null(cfg$data_dir)) stop("config/config.yml has no 'data_dir' key.")
    dir <- cfg$data_dir
  }
  if (!dir.exists(dir)) stop("data_dir does not exist: ", dir)
  normalizePath(dir, winslash = "/")
}

DATA_DIR    <- resolve_data_dir()
RAW_DIR     <- file.path(DATA_DIR, "raw")
DERIVED_DIR <- file.path(DATA_DIR, "derived")
OUTPUT_DIR  <- file.path(DATA_DIR, "output")

for (d in c(RAW_DIR, DERIVED_DIR, OUTPUT_DIR)) {
  if (!dir.exists(d)) dir.create(d, recursive = TRUE)
}
