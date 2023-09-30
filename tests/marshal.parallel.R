library(marshal)

if (requireNamespace("parallel", quietly = TRUE)) {
  cl <- parallel::makeCluster(1L)
  print(cl)

  ## Assert non-marshallability
  stopifnot(!marshallable(cl))

  ## Marshal read-only connection, which records the
  ## current state, including the current file position.
  res <- tryCatch({
    marshal(cl)
  }, error = identity)
  stopifnot(
    inherits(res, "error"),
    inherits(res, "MarshalNotSupportedError")
  )

  node <- cl[[1]]
  print(node)

  ## Assert non-marshallability
  stopifnot(!marshallable(node))

  ## Marshal read-only connection, which records the
  ## current state, including the current file position.
  res <- tryCatch({
    marshal(node)
  }, error = identity)
  stopifnot(
    inherits(res, "error"),
    inherits(res, "MarshalNotSupportedError")
  )

  parallel::stopCluster(cl)
}
