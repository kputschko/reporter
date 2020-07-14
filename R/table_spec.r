
## To Do ##
# Automatic paging and wrapping
# Spanning header function

# ft <- report_table(final, n_format=NULL, page_var=page) %>%
#   define(var="variable", label="Variable", align="left", width=1.25, visible=TRUE) %>%
#   define(var="category", label="", align="left", width=2) %>%
#   define(var="placebo", label="Placebo", align="center", width=1, n=placebo_pop) %>%
#   define(var="drug", label="Drug", align="center",  width=1, n=drug_pop) %>%
#   define(var="overall", label="Overall", align="center", width=1, n=overall_pop, wrap=TRUE) %>%
#   spanning_header(span_cols=c("placebo", "drug"), label="Treatment Groups", label_align="center")




# Table Spec Functions ---------------------------------------------------------
#' A function to create a table_spec object
#' @param x The data frame to create a table spec for.
#' @param n_format The format function to apply to the header n label.
#' @param page_var A variable in the data frame to use for a page variable.
#' @param show_cols Whether to show all column by default.  Valid values are
#' "all", "none", or "some".
#' @param first_row_blank Whether to place a blank row under the table header.
#' @param align Aligns the table on the page.  Valid values are "left", 
#' "right", and "center".  Default value is "center".
#' @export
create_table <- function(x, n_format = upcase_parens, page_var = NULL,
                         show_cols = "all", first_row_blank=FALSE, 
                         align = "center") {

  ret <- structure(list(), class = c("table_spec", "list"))

  if (!"data.frame" %in% class(x)) {
     stop(paste("ERROR: data parameter 'x' on",
                 "page_template() function is invalid.",
                "\n\tValid values are a data.frame or tibble."))
  }


  ret$data <- x
  ret$n_format <- n_format
  ret$page_var <- page_var
  ret$col_defs <- list()
  ret$col_spans <- list()
  ret$show_cols <- show_cols
  ret$first_row_blank <- first_row_blank
  ret$align <- align

  return(ret)

  }

#' Defines a column specification
#' @param x The table spec.
#' @param var The variable to define a column for.
#' @param label The label to use for the column header.
#' @param col_type The column type.
#' @param align The column alignment.  Value values are "left", "right", and
#' "center".
#' @param label_align How to align the header labels for this column.
#' Value values are "left", "right", and "center".
#' @param width The width of the column in inches.
#' @param visible Whether or not the column should be visible on the report.
#' @param n The n value to place in the n header label.
#' @param blank_after Whether to place a blank row after unique values of this
#' variable.
#' @param dedupe Whether to dedupe the values for this variable.  Variables
#' that are deduped only show the value on the first row in a group.
#' @param id_var Whether this variable should be considered an ID variable.
#' ID variables are retained on each page when the page is wrapped.
#' @export
define <- function(x, var, label = NULL, col_type = NULL,
                   align=NULL, label_align=NULL, width=NULL,
                   visible=TRUE, n = NULL, blank_after=FALSE,
                   dedupe=FALSE, id_var = FALSE) {


  def <- list(var = deparse(substitute(var)),
              var_c = as.character(substitute(var)),
              label= label,
              col_type = col_type,
              align = align,
              label_align = if (is.null(label_align) & !is.null(align))
                                align else label_align,
              width = width,
              visible = visible,
              n = n,
              blank_after = blank_after,
              dedupe = dedupe,
              id_var = id_var)

  x$col_defs[[length(x$col_defs) + 1]] <- def

  return(x)
}

#' Defines a spanning header
#' @param x The table spec.
#' @param span_cols The columns to span.
#' @param label The label to apply to the spanning header.
#' @param label_align The alignment to use for the label.
#' @param level The level to use for the spanning header.
#' @param n The n value to use for the n label on the spanning header.
#' @export
spanning_header <- function(x, span_cols, label = "",
                            label_align = "center", level = 1, n = NULL) {

  sh <- list(span_cols = span_cols,
             label = label,
             label_align = label_align,
             level = level,
             n = n)

  x$col_spans[[length(x$col_spans) + 1]] <- sh

  return(x)
}

#' Defines options for the table
#' @param x The table spec.
#' @param first_row_blank Whether to create a blank on the first row after the
#' table header.
#' @export
table_options <- function(x, first_row_blank=FALSE){


  x$first_row_blank = first_row_blank


}

#' Prints the table spec
#' @param x The table spec.
#' @param ... Additional parameters.
#' @export
print.table_spec <- function(x, ...){
  
  
  for (nm in names(x)) {
    
    cat("$", nm, "\n", sep = "")
    if (nm == "data") {

      m <- ncol(x[[nm]]) * 10
      print(x[[nm]], ..., max = m)
    }
    else  {
      
      print(x[[nm]], ...)
    }
    cat("\n")
  }
  
  invisible(x)
}
