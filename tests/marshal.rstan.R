library(marshal)

if (requireNamespace("BH", quietly = TRUE) && requireNamespace("RcppEigen", quietly = TRUE) && requireNamespace("rstan", quietly = TRUE)) {
  library(rstan)

  code <- "
  data {
    int<lower=0> N;
    real y[N];
  } 
  
  parameters {
    real mu;
  } 
  
  model {
    target += normal_lpdf(mu | 0, 10);
    target += normal_lpdf(y  | mu, 1);
  } 
  "
  
  data <- list(N = 20L, y = rnorm(20L))
  ## WORKAROUND: Avoid "cannot open file 'startup.Rs': No such file or
  ## directory" error. /HB 2023-09-23
  ovalue <- Sys.getenv("R_TESTS")
  Sys.setenv(R_TESTS = "")
  fit <- stan(model_code = code, model_name = "example", 
              data = data, iter = 2L, chains = 2L,
              sample_file = file.path(tempdir(), "norm.csv"))
  Sys.setenv(R_TESTS = ovalue)
  print(fit)
  print(summary(fit))

  ## Assert marshallability
  stopifnot(marshallable(fit))

  fit_ <- marshal(fit)
  fit2 <- unmarshal(fit_)
  print(fit2)
  print(summary(fit2))

  print(list(
    print = identical(capture.output(print(fit2)), capture.output(print(fit))),
    summary = identical(capture.output(summary(fit2)), capture.output(summary(fit)))
  ))
  
  stopifnot(
    identical(capture.output(print(fit2)), capture.output(print(fit))),
    identical(capture.output(summary(fit2)), capture.output(summary(fit)))
  )
}

