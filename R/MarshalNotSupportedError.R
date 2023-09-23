MarshalNotSupportedError <- function(message = NULL, call = NULL, ..., object = NULL) {
  stopifnot(!is.null(message) || !is.null(object))
  
  if (is.null(message)) {
    class <- class(object)
    message <- sprintf("Do not know how to marshal an object of class %s",
                       paste(sQuote(class), collapse = ", "))
    pkg <- attr(class, "package")
    if (!is.null(pkg)) {
      message <- sprintf("%s [package %s]", message, sQuote(pkg))
    }
  }
  
  ex <- simpleError(message, call = call)
  class(ex) <- c("MarshalNotSupportedError", class(ex))
  ex
}
