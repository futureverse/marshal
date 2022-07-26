library(marshal)

if (requireNamespace("inline", quietly = TRUE)) {
  code <- "
    int i;  
    for (i = 0; i < *n; i++) x[0] = x[0] + (i+1);  
  "
  sum_1_to_n <- inline::cfunction(
    signature(n = "integer", x = "numeric"),
    code,
    language = "C", convention = ".C"
  )

  ## Marshal CFunc function
  sum_1_to_n_ <- marshal(sum_1_to_n)

  ## Unarshal CFunc function
  sum_1_to_n2 <- unmarshal(sum_1_to_n_)

  y <- sum_1_to_n(10, 0)$x
  print(y)

  y2 <- sum_1_to_n2(10, 0)$x
  print(y2)

  stopifnot(identical(y2, y))
}
