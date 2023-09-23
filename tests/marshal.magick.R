library(marshal)

if (requireNamespace("magick", quietly = TRUE)) {
  img <- magick::logo
  print(img)
  
  ## Marshal read-only connection, which records the
  ## current state, including the current file position.
  res <- tryCatch({
    marshal(img)
  }, error = identity)
  stopifnot(
    inherits(res, "error"),
    inherits(res, "MarshalNotSupportedError")
  )
}
