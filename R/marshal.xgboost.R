#' Marshalling of 'xgboost' objects
#'
#' @param x
#' An [xgboost::xgb.DMatrix] or an `xgboost:xgb.Booster` object.
#'
#' @param \dots Not used.
#'
#' @return
#' A `marshalled` object as described in [marshal()].
#'
#' @details
#' [xgboost::xgb.DMatrix.save()] is used to produce a marshalled version
#' of the original object.
#' [xgboost::xgb.DMatrix()] is used to reconstruct a version of the
#' original object from the marshalled object.
#'
# @example incl/marshal.xgb.DMatrix.R
#'
#' @rdname marshal.xgboost
#' @aliases marshal.xgb.Booster
#' @aliases marshal.xgb.DMatrix
#' @export
marshal.xgb.DMatrix <- function(x, ...) {
  res <- list(
    marshalled = to_raw.xgb.DMatrix(x)
  )
  class(res) <- marshal_class(x)
  object <- NULL
  
  ## IMPORTANT: We don't want any of the input arguments
  ## to be part of the unmarshal() environment
  rm(list = c("x", names(list(...))))
  
  res[["unmarshal"]] <- unmarshal_xgb.DMatrix
  assert_no_references(res)
  res
  
}

unmarshal_xgb.DMatrix <- function(x, ...) {
  object <- x[["marshalled"]]
  res <- from_raw.xgb.DMatrix(object)
  stopifnot(all.equal(class(res), marshal_unclass(x), check.attributes = FALSE))
  res
}


to_raw.xgb.DMatrix <- function(x) {
  tf <- tempfile()
  on.exit(file.remove(tf))
  xgboost::xgb.DMatrix.save(x, fname = tf)      
  readBin(tf, what = raw(), n = file.size(tf), endian = "little")
}


from_raw.xgb.DMatrix <- function(raw) {
  tf <- tempfile()
  on.exit(file.remove(tf))
  writeBin(raw, con = tf, endian = "little")
  
  ## Muffle stray output
  sink(nullfile())
  on.exit(sink(NULL), add = TRUE)
  
  xgboost::xgb.DMatrix(tf)
}


#' @rdname marshal.xgboost
#' @export
marshal.xgb.Booster <- function(x, ...) {
  raw <- xgboost::xgb.save.raw(x, raw_format = "ubj")
  names <- setdiff(names(x), c("handle", "raw"))
  extra <- x[names]
  t <- extra[["evaluation_log"]]
  attr(t, ".internal.selfref") <- NULL
  extra[["evaluation_log"]] <- t
  attr(raw, "extra") <- extra

  res <- list(
    marshalled = raw
  )
  class(res) <- marshal_class(x)
  object <- NULL
  
  ## IMPORTANT: We don't want any of the input arguments
  ## to be part of the unmarshal() environment
  rm(list = c("x", names(list(...))))
  
  res[["unmarshal"]] <- unmarshal_xgb.Booster
  assert_no_references(res)
  res
}


unmarshal_xgb.Booster <- function(x, ...) {
  object <- x[["marshalled"]]
  extra <- attr(object, "extra")
  res <- xgboost::xgb.load.raw(object, as_booster = TRUE)
  for (name in names(extra)) res[name] <- extra[name]
  stopifnot(all.equal(class(res), marshal_unclass(x), check.attributes = FALSE))
  res
}




#' @rdname marshal.xgboost
#' @aliases marshallable.xgb.Booster
#' @export
marshallable.xgb.Booster <- function(...) {
  TRUE
}


#' @rdname marshal.xgboost
#' @aliases marshallable.xgb.DMatrix
#' @export
marshallable.xgb.DMatrix <- function(...) {
  TRUE
}
