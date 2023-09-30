library(marshal)

if (requireNamespace("DBI", quietly = TRUE) &&
    requireNamespace("RSQLite", quietly = TRUE)) {
  con <- DBI::dbConnect(RSQLite::SQLite(), ":memory:")
  print(con)

  ## Assert non-marshallability
  stopifnot(!marshallable(con))

  ## Marshal read-only connection, which records the
  ## current state, including the current file position.
  res <- tryCatch({
    marshal(con)
  }, error = identity)
  stopifnot(
    inherits(res, "error"),
    inherits(res, "MarshalNotSupportedError")
  )
}
