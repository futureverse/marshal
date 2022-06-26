#' @param node An \link[XML:XMLAbstractNode-class]{XML::XMLAbstractNode} object.
#'
#' @example incl/marshal.XML.R
#'
#' @rdname marshal
#' @export
marshal.XMLAbstractNode <- function(node, ...) {
  ## Marshal to a raw array
  con <- rawConnection(raw(), open = "wb")
  on.exit(if (!is.null(con)) close(con))
  saveRDS(node, file = con, refhook = XML::xmlSerializeHook)
  raw <- rawConnectionValue(con)
  close(con)
  con <- NULL
  class(raw) <- c(paste(class(node), "_marshalled", sep = ""), "marshalled")
  raw
}

#' @export
unmarshal.XMLAbstractNode_marshalled <- function(node, ...) {
  ## Marshal to a raw array
  con <- rawConnection(node, open = "rb")
  on.exit(if (!is.null(con)) close(con))
  res <- readRDS(con, refhook = XML::xmlDeserializeHook)
  close(con)
  con <- NULL
  res
}
