#' @example incl/marshal.file.R
#' @example incl/marshal.url.R
#'
#' @param con A \link[base:connection]{connection}.
#'
#' @rdname marshal
#' @export
marshal.connection <- function(con, ...) {
  con_ <- con
  
  ## Special cases (stdin, stdout, stderr)
  if (con_ <= 2L) {
    if (con_ == 0L) {
      stop("Cannot marshal the standard input connection")
    }
  } else {
    state <- summary(con_)
    
    ## Can only marshal read-only connections
    if (! state[["mode"]] %in% c("r", "rt", "rb")) {
      stop(sprintf("Can not marshal a writable connection: %s", state[["mode"]]))
    }

    ## Can only marshal unopened or seekable connections
    if (state[["opened"]] == "opened") {
      if (!isSeekable(con_)) {
        stop("Can not marshal a non-seekable open connection")
      }
      ## Record current position
      state[["position"]] <- seek(con_, where = NA, origin = "start", rw = "read")
    }

    ## Invalidate connection (prevent misuse)
    con_[1] <- -1L
    attr(con_, "state") <- state
  }

  ## Drop external pointer reference
  attr(con_, "conn_id") <- NULL

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
