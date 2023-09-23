## Run only in interactive mode, because example takes > 5 seconds,
## which is longer than what is allowed on CRAN
if (interactive() && requireNamespace("keras", quietly = TRUE)) {
  library(keras)
  
  ## Create a keras model (adopted from {keras} vignette)
  inputs <- layer_input(shape = shape(32))
  outputs <- layer_dense(inputs, units = 1L)
  model <- keras_model(inputs, outputs)
  model <- compile(model, optimizer = "adam", loss = "mean_squared_error")
  print(model)

  ## Not needed anymore
  rm(list = c("inputs", "outputs"))

  ## Marshal
  model_ <- marshal(model)
  
  ## Unmarshal
  model2 <- unmarshal(model_)
  
  stopifnot(
    identical(summary(model2), summary(model))
  )


  ## Fitted keras model (adopted from {keras} vignette)
  test_input <- array(runif(128 * 32), dim = c(128, 32))
  test_target <- array(runif(128), dim = c(128, 1))
  hist <- fit(model, test_input, test_target)
  print(hist)
  print(model)
  
  ## Not needed anymore
  rm(list = "test_target")
  
  ## Marshal
  model_ <- marshal(model)
  
  ## Unmarshal
  model2 <- unmarshal(model_)
  
  stopifnot(
    identical(summary(model2), summary(model)),
    identical(stats::predict(model2, test_input), stats::predict(model, test_input))
  )
}
