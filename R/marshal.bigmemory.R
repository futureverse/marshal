#' Marshalling of 'bigmemory' objects
#'
#' @param x A [bigmemory::big.matrix] object.
#'
#' @param \dots Not used.
#'
#' @return
#' A `marshalled` object as described in [marshal()].
#'
#' @details
#' [bigmemory::write.big.matrix()] is used to produce a marshalled version
#' of the original object.
#' [bigmemory::read.big.matrix()] is used to reconstruct a version of the
#' original object from the marshalled object.
#'
#' @example incl/marshal.bigmemory.R
#'
#' @rdname marshal.bigmemory
#' @aliases marshal.bigmemory
#' @export
marshal.big.matrix <- function(x, ...) {
  marshal_bigmemory(x, ...)
}

marshal_bigmemory <- function(x, ...) {
  tf <- tempfile(fileext = ".bigmemory")
  on.exit(if (!is.null(tf)) file.remove(tf))
  bigmemory::write.big.matrix(x, filename = tf)
  raw <- readBin(tf, what = "raw", n = file.size(tf))
  file.remove(tf)
  tf <- NULL
  
  res <- list(
    marshalled = list(
      typeof = bigmemory::typeof(x),
      raw = raw
    )
  )
  class(res) <- marshal_class(x)
  rm(list = "raw")
  
  res[["unmarshal"]] <- unmarshal_bigmemory
  
  assert_no_references(res)
  res
}

unmarshal_bigmemory <- function(x, ...) {
  object <- x[["marshalled"]]
  raw <- object[["raw"]]
  typeof <- object[["typeof"]]
  
  tf <- tempfile(fileext = ".bigmemory")
  on.exit(if (!is.null(tf)) file.remove(tf))
  writeBin(raw, con = tf)

  res <- bigmemory::read.big.matrix(tf, type = typeof)
  file.remove(tf)
  tf <- NULL

  res
}


#' @rdname marshal.bigmemory
#' @aliases marshallable.big.memory
#' @export
marshallable.big.memory <- function(...) {
  TRUE
}
