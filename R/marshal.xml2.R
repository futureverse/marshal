#' Marshalling of 'xml2' objects
#'
#' @param xml2
#' A \link[xml2:xml_document-class]{xml2::xml_document} or similar.
#'
#' @param \dots Not used.
#'
#' @return
#' A `marshalled` object as described in [marshal()].
#'
#' @details
#' [xml2::xml_serialize()] is used to produce a marshalled version
#' of the original object.
#' [xml2::xml_unserialize()] is used to reconstruct a version of the
#' original object from the marshalled object.
#'
#' @example incl/marshal.xml2.R
#'
#' @rdname marshal.xml2
#' @aliases marshal.xml2
#' @export
marshal.xml_document <- function(xml2, ...) {
  marshal_xml2(xml2, ...)
}

#' @rdname marshal.xml2
#' @export
marshal.xml_nodeset <- function(xml2, ...) {
  marshal_xml2(xml2, ...)
}

marshal_xml2 <- function(xml2, ...) {
  res <- list(
    marshalled = xml2::xml_serialize(xml2, connection = NULL)
  )
  class(res) <- marshal_class(xml2)

  ## IMPORTANT: We don't want any of the input arguments
  ## to be part of the unmarshal() environment
  rm(list = c("xml2", names(list(...))))
  
  res[["unmarshal"]] <- unmarshal_xml2
  
  assert_no_references(res)
  res
}

unmarshal_xml2 <- function(xml2, ...) {
  object <- xml2[["marshalled"]]
  res <- xml2::xml_unserialize(object)
  stopifnot(identical(class(res), marshal_unclass(xml2)))
  res
}
