if (requireNamespace("caret", quietly = TRUE)) {
  ## Adopted from example("train", package = "caret")
  train_data <- head(datasets::iris, n = -25)
  test_data  <- head(datasets::iris, n =  25)
  
  fit <- caret::train(
    x = train_data[, c("Sepal.Length", "Sepal.Width",
                       "Petal.Length", "Petal.Width")],
    y = train_data[["Species"]],
    method = "knn",
    preProcess = c("center", "scale"),
    tuneLength = 10L,
    trControl = caret::trainControl(method = "cv")
  )

  ## Marshal 'train' object
  fit_ <- marshal(fit)

  ## Unmarshal to restore 'train' object
  fit2 <- unmarshal(fit_)

  ## Assert identical model fits
  stopifnot(
    identical(fit2, fit)
  )

  ## Assert identical predictions
  pred <- predict(fit, test_data)
  rm("fit") ## Not needed anymore
  
  pred2 <- predict(fit2, test_data)
  
  stopifnot(
    identical(pred2, pred)
  )
}  

