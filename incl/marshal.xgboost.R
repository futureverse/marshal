if (requireNamespace("xgboost", quietly = TRUE)) {
  library(xgboost)
  
  data(agaricus.train, package = "xgboost")
  data <- xgb.DMatrix(agaricus.train$data, label = agaricus.train$label)

  ## Marshal 'xgb.DMatrix' object
  data_ <- marshal(data)

  ## Unmarshal to restore 'xgb.DMatrix' object
  data2 <- unmarshal(data_)

  ## Assert similar objects
  stopifnot(
    identical(dim(data2), dim(data)),
    identical(dimnames(data2), dimnames(data)),
    identical(getinfo(data2, "label"), getinfo(data, "label"))
  )

  ## Assert identical objects by exporting to file and byte compare
  tf <- tempfile()
  xgb.DMatrix.save(data, fname = tf)
  md5 <- tools::md5sum(tf)
  xgb.DMatrix.save(data2, fname = tf)
  md52 <- tools::md5sum(tf)
  file.remove(tf)
  stopifnot(
    identical(md5, md52)
  )
}

