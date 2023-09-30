#' Marshalling of R connections
#'
#' @param con A \link[base:connection]{connection}.
#'
#' @param \dots Not used.
#'
#' @return
#' A `marshalled` object as described in [marshal()].
#'
#' @section Limitations:
#' Not all connections can be marshalled, specifically we:
#'
#'  * cannot marshal connections stdin (0), stdout (1), and stderr (2)
#'  * can only marshal _read-only_ connections
#'  * can only marshal _unopened_ or _seekable_ connections
#'
#' @example incl/marshal.file.R
#' @example incl/marshal.url.R
#'
#' @rdname marshal.connection
#' @aliases marshal.connection
#' @export
marshal.connection <- function(con, ...) {
  con_ <- con

  possible <- marshallable_connection(con)
  if (!possible) {
    stop(attr(possible, "reason", exact = TRUE))
  }
  
  ## Invalidate connection (prevent misuse)
  con_[1] <- -1L
  attr(con_, "conn_id") <- NULL
  attr(con_, "state") <- attr(possible, "state", exact = TRUE)

  res <- list(
    marshalled = con_
  )
  class(res) <- marshal_class(con)

  ## IMPORTANT: We don't want any of the input arguments
  ## to be part of the unmarshal() environment
  rm(list = c("con", names(list(...))))

  res[["unmarshal"]] <- unmarshal_connection
  assert_no_references(res)
  res
}


unmarshal_connection <- function(con, ...) {
  con <- con[["marshalled"]]
  
  ## Special cases (stdin, stdout, stderr)
  if (0 <= con && con <= 2L) {
    con2 <- con
    class(con) <- setdiff(class(con), "marshalled")
  } else {
    state <- attr(con, "state")

    src <- state[["description"]]
    opened <- (state[["opened"]] == "opened")
    open <- if (opened) state[["mode"]] else ""
    
    if (grepl("file$", state[["class"]])) {
      make_file <- get(state[["class"]], mode = "function")
      ## Open a file, bzfile, gzfile, or xzfile connection
      con2 <- make_file(src, open = open)
    } else if (grepl("^url", state[["class"]])) {
      ## Open an URL connection
      con2 <- url(src, open = open)
    } else {
      stop(sprintf("Don't know how to unmarshal connection of class %s", state[["class"]]))
    }

    pos <- state[["position"]]
    if (!is.null(pos)) {
      stopifnot(length(pos) == 1L, is.numeric(pos), !is.na(pos), pos >= 0L)
      stopifnot(opened)
      seek(con2, where = pos, start = "origin", rw = "read")
    }
  }

  stopifnot(identical(class(con2), marshal_unclass(con)))
  
  con2
}


#' @rdname marshal.connection
#' @aliases marshallable.connection
#' @export
marshallable.connection <- function(con, ...) {
  as.logical(marshallable_connection(con))
}


marshallable_connection <- function(con) {
  ## Special cases (stdin, stdout, stderr)
  if (con <= 2L) {
    if (con == 0L) {
      reason <- "Cannot marshal the standard input connection"
      return(structure(FALSE, reason = reason))
    }
  } else {
    state <- summary(con)
    
    ## Can only marshal read-only connections
    if (! state[["mode"]] %in% c("r", "rt", "rb")) {
      reason <- sprintf("Can not marshal a writable connection: %s", state[["mode"]])
      return(structure(FALSE, reason = reason))
    }

    ## Can only marshal unopened or seekable connections
    if (state[["opened"]] == "opened") {
      if (!isSeekable(con)) {
        reason <- "Can not marshal a non-seekable open connection"
        return(structure(FALSE, reason = reason))
      }
      ## Record current position
      state[["position"]] <- seek(con, where = NA, origin = "start", rw = "read")
    }

    ## Can only marshal file and URL connections
    if (!grepl("(^url|file$)", state[["class"]])) {
      reason <- sprintf("Don't know how to marshal connection of class %s", state[["class"]])
      return(structure(FALSE, reason = reason))
    }
  }

  structure(TRUE, state = state)
}