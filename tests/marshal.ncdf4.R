library(marshal)

prune <- function(x) {
  x[["filename"]] <- NA_character_
  x[["id"]] <- NA_integer_
  x[["groups"]] <- lapply(x[["groups"]], FUN = function(xx) {
    xx[["id"]] <- NA_integer_
    xx
  })
  x[["var"]] <- lapply(x[["var"]], FUN = function(xx) {
    xx[["id"]][["group_id"]] <- NA_integer_
    xx
  })
  x
}

if (requireNamespace("ncdf4", quietly = TRUE)) {
  library(ncdf4)
  
  ## Create a temporary NCDF file
  tf <- tempfile(fileext = ".nc")
  
  x <- ncvar_def("x", units = "count", dim = list())
  nf <- nc_create(tf, x)
  ncvar_put(nf, x, 42)
  print(nf)
  nc_close(nf)
  rm(list = c("nf", "x"))

  ## Open NCDF file
  nf <- nc_open(tf)
  y <- ncvar_get(nf, "x")
  stopifnot(identical(y, 42))

  ## Assert marshallability
  stopifnot(marshallable(nf))

  ## Marshal
  nf_ <- marshal(nf)

  ## Unmarshal
  nf2 <- unmarshal(nf_)

  y2 <- ncvar_get(nf2, "x")
  stopifnot(identical(y2, y))

  stopifnot(all.equal(prune(nf2), prune(nf)))

  ## Marshal
  nf2_ <- marshal(nf2)
  stopifnot(identical(nf2_, nf_))
}
