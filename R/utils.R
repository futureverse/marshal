marshal_class <- function(object) {
  class <- class(object)
  c(paste(class, "_marshalled", sep = ""), "marshalled")
}
