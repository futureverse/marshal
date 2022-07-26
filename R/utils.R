marshal_class <- function(object) {
  class <- class(object)
  class2 <- c(paste(class, "_marshalled", sep = ""), "marshalled")
  attributes(class2) <- attributes(class)
  class2
}

marshal_unclass <- function(object) {
  class <- class(object)
  class2 <- setdiff(class, "marshalled")
  class2 <- gsub("_marshalled", "", class2, fixed = TRUE)
  attributes(class2) <- attributes(class)
  class2
}
