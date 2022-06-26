marshal_class <- function(object) {
  class <- class(object)
  c(paste(class, "_marshalled", sep = ""), "marshalled")
}

marshal_unclass <- function(object) {
  class <- class(object)
  class <- setdiff(class, "marshalled")
  class <- gsub("_marshalled", "", class, fixed = TRUE)
  class
}
