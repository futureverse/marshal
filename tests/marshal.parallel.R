library(marshal)

if (requireNamespace("parallel", quietly = TRUE)) {
  cl <- parallel::makeCluster(1L)
  print(cl)

  node <- cl[[1]]
  print(node)

  ## Marshal read-only connection, which records the
  ## current state, including the current file position.
  res <- tryCatch({
    marshal(node)
  }, error = identity)
  stopifnot(
    inherits(res, "error"),
    inherits(res, "MarshalNotSupportedError")
  )

  ## Marshal read-only connection, which records the
  ## current state, including the current file position.
  res <- tryCatch({
    marshal(cl)
  }, error = identity)
  stopifnot(
    inherits(res, "error"),
    inherits(res, "MarshalNotSupportedError")
  )

  parallel::stopCluster(cl)
}
