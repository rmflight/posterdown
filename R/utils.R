# Most here is from thesisdown for the posterdown_pdf option
find_file <- function(template, file) {
  template <- system.file("rmarkdown", "templates", template, file,
                          package = "rmflightPosterdown")
  if (template == "") {
    stop("Couldn't find template file ", template, "/", file, call. = FALSE)
  }

  template
}

find_resource <- function(template, file) {
  find_file(template, file.path("resources", file))
}

knitr_fun <- function(name) utils::getFromNamespace(name, 'knitr')

output_asis <- knitr_fun('output_asis')

merge_list <- function(x, y) {
  fun <- knitr_fun('merge_list')
  fun(as.list(x), y)
}

#' Render a pandoc template.
#'
#' This is a hacky way to access the pandoc templating engine.
#'
#' @param metadata A named list containing metadata to pass to template.
#' @param template Path to a pandoc template.
#' @param output Path to save output.
#' @return (Invisibly) The path of the generate file.
#' @examples
#' x <- posterdown:::template_pandoc(
#'   list(preamble = "%abc", filename = "wickham"),
#'   posterdown:::find_resource("posterdown_generic", "template.tex"),
#'   tempfile()
#' )
#' if (interactive()) file.show(x)
#' @noRd
template_pandoc <- function(metadata, template, output, verbose = FALSE) {
  tmp <- tempfile(fileext = ".md")
  on.exit(unlink(tmp))

  cat("---\n", file = tmp)
  cat(yaml::as.yaml(metadata), file = tmp, append = TRUE)
  cat("---\n", file = tmp, append = TRUE)
  cat("\n", file = tmp, append = TRUE)

  rmarkdown::pandoc_convert(tmp, "markdown", output = output,
                            options = paste0("--template=", template), verbose = verbose)

  invisible(output)
}
