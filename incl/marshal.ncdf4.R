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

  ## Marshal
  nf_ <- marshal(nf)

  ## Unmarshal
  nf2 <- unmarshal(nf_)

  y2 <- ncvar_get(nf2, "x")
  stopifnot(identical(y2, y))
}
