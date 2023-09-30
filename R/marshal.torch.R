#' Marshalling of 'torch' objects
#'
#' @param model
#' A `luz_module_fitted` object.
#'
#' @param \dots Not used.
#'
#' @return
#' A `marshalled` object as described in [marshal()].
#'
#' @details
#' [luz::luz_save()] is used to produce a marshalled version
#' of the original object.
#' [luz::luz_load()] is used to reconstruct a version of the
#' original object from the marshalled object.
#'
#' @rdname marshal.torch
#' @aliases marshal.luz_module_fitted
#' @export
marshal.luz_module_fitted <- function(model, ...) {
  raw <- suppressWarnings(local({
    con <- rawConnection(raw(), open = "wb")
    on.exit(close(con))
    luz::luz_save(model, con)
    rawConnectionValue(con)
  }))
  
  res <- list(
    marshalled = raw
  )
  class(res) <- marshal_class(model)
  
  ## IMPORTANT: We don't want any of the input arguments
  ## to be part of the unmarshal() environment
  rm(list = c("model", names(list(...))))
  
  res[["unmarshal"]] <- unmarshal_luz_module_fitted
  assert_no_references(res)
  res
}

unmarshal_luz_module_fitted <- function(model, ...) {
  object <- model[["marshalled"]]

  res <- local({
    con <- rawConnection(object)
    on.exit(close(con))
    luz::luz_load(con)
  })
  stopifnot(all.equal(class(res), marshal_unclass(model), check.attributes = FALSE))
  res
}


#' @rdname marshal.torch
#' @aliases marshallable.luz_module_fitted
#' @export
marshallable.luz_module_fitted <- function(...) {
  TRUE
}
