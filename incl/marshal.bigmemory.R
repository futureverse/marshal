if (requireNamespace("bigmemory", quietly = TRUE)) {
  library(bigmemory)
  
  x <- big.matrix(nrow = 3, ncol = 2, type = "double")
  x[] <- seq_along(x)
  
  ## Marshal
  x_ <- marshal(x)

  ## Unmarshal
  x2 <- unmarshal(x_)

  stopifnot(identical(x2[], x[]))
}

