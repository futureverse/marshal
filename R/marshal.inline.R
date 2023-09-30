#' Marshalling of 'inline' objects
#'
#' _WARNING: This is very limited proof of concept!_
#'
#' @param inline
#' A \link[inline:cfunction]{CFunc} function.
#'
#' @param \dots Not used.
#'
#' @return
#' A `marshalled` object as described in [marshal()].
#'
#' @details
#' Currently, it is only possible to marshal a function:
#'
#'  * of class `CFunc` that was created _without_ "includes" or "otherdefs"
#'
#' @example incl/marshal.inline.R
#'
#' @rdname marshal.inline
#' @aliases marshal.inline
#' @export
marshal.CFunc <- function(inline, ...) {
  marshal_CFunc(inline, ...)
}

marshal_CFunc <- function(inline, ...) {
  language <- "C"

  res <- marshallable_CFunc(inline)
  if (!res) {
    stop(attr(res, "reason", exact = TRUE))
  }
  
  ## Reconstruct convention
  convention <- attr(res, "convention", exact = TRUE)
 
  ## Reconstruct signature
  args <- as.list(body(inline))[-(1:2)]
  signature <- character(0L)
  for (name in names(args)) {
    type <- args[[name]]
    type <- as.character(type[[1]])
    type <- gsub("^as[.]", "", type)
    signature[[name]] <- type
  }

  ## Reconstruct native-code body
  body <- inline@code
  body <- strsplit(body, split = "\n", fixed = TRUE)[[1]]
  from <- grep("^void file.*[{]$", body)
  stopifnot(length(from) == 1)
  to <- length(body) - 2L
  body <- body[(from+1L):to]
  body <- body[nzchar(body)]
  body <- paste(body, collapse = "\n")
  
  res <- list(
    marshalled = list(
       signature = signature,
            body = body,
        language = language,
      convention = convention
    )
  )
  class(res) <- marshal_class(inline)

  ## IMPORTANT: We don't want any of the input arguments
  ## to be part of the unmarshal() environment
  rm(list = c("inline", names(list(...))))
  
  res[["unmarshal"]] <- unmarshal_CFunc
  
  assert_no_references(res)
  res
}

unmarshal_CFunc <- function(inline, ...) {
  object <- inline[["marshalled"]]
  res <- inline::cfunction(
                 object[["signature"]],
          body = object[["body"]],
      language = object[["language"]],
    convention = object[["convention"]]
  )
  stopifnot(identical(class(res), marshal_unclass(inline)))
  res
}



#' @rdname marshal.inline
#' @aliases marshallable.CFunc
#' @export
marshallable.CFunc <- function(...) {
  as.logical(marshallable_CFunc(...))
}


marshallable_CFunc <- function(inline, ...) {
  ## Reconstruct convention
  code <- deparse(as.list(body(inline))[[1]])
  
  convention <- gsub('^[.]Primitive[(]"(.*)"[)]$', "\\1", code)
  if (!convention %in% c(".Call", ".C", ".Fortran")) {
    reason <- sprintf("Can not marshal 'inline' %s functions that call .Call(), .C(), or .Fortran()", class(inline)[1])
    return(structure(FALSE, reason = reason))
  }
  
  structure(TRUE, convention = convention)
}
