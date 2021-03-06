#' collect the \dots and apply them appropriately to gsplot
#' 
#' This function is a higher level internal function that deals with the dirty 
#' work of most of the \code{modify} type things that happen when adding a function 
#' call to a view or a side. This function sequentially filters the arguments into 
#' primary function call arguments, option args (things like view/side par args), and 
#' "extracted" arguments that inherit param values from the primary function call arguments.  
#' These arguments are then used in calls to \code{\link{modify_side}}, 
#' \code{\link{modify_side_par}}, \code{\link{modify_side_par}}, \code{\link{modify_view_par}},
#' \code{\link{add_to_view}}, and \code{\link{add_to_legend}}. Returned object is of class
#' \code{gsplot}
#' 
#' @param object a gsplot object
#' @param fun.name a function name (character)
#' @param \dots arguments to be used in the above mentioned functions
#' @param legend.name the name to use for the legend name (can be \code{NULL})
#' @param side the side(s) that the arguments apply to
#' @param where location to put \code{call.args}.
#' Can be "first" or "last". Used in \code{\link{add_to_view}}
#' @return a code{gsplot} object
#' @keywords internal
gather_function_info <- function(object, fun.name, ..., legend.name, side, where){
  arguments <- filter_arguments(fun.name, ..., custom.config = object[["global"]][["config"]][["config.file"]], side=side)
  
  call.args <- arguments$call.args
  option.args <- arguments$option.args
  extracted.args <- arguments$extracted.args
  side <- set_sides(side)
  
  object <- apply_extracted_args(object, extracted.args, side=side) 
  
  object <- modify_config(object, option.args)
  object <- modify_side(object, c(call.args, option.args), side=side)
  object <- modify_side_par(object, option.args, side=side)
  object <- modify_view_par(object, option.args, side=side)
  
  object <- add_to_view(object, call.args, side=side, where=where)
  
  object <- add_to_legend(object, fun.name, legend.name, call.args[[1]], option.args, where=where)
  
  class(object) <- 'gsplot'
  return(object)
}