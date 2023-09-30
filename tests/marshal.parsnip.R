library(marshal)

if (requireNamespace("parsnip", quietly = TRUE) && requireNamespace("xgboost", quietly = TRUE)) {
  library(parsnip)
  
  ## Adopted from example("boost_tree", package = "parsnip")
  model <- boost_tree(mode = "classification", trees = 20L, engine = "xgboost")  
  model <- set_mode(model, "regression")
  fit <- fit(model, mpg ~ ., data = datasets::mtcars)

  ## Assert marshallability
  stopifnot(marshallable(fit))

  ## Marshal
  fit_ <- marshal(fit)

  ## Unmarshal
  fit2 <- unmarshal(fit_)

  ## Marshal again
  fit2_ <- marshal(fit2)

  ## Assert identity
  stopifnot(
    all.equal(fit2_, fit_)
  )
  
  fit3 <- unmarshal(fit2_)

  ## Assert identity
  stopifnot(
    all.equal(fit3, fit2)
  )
}  
