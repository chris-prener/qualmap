#' Verify Previously Saved Cluster Data
#'
#' @description Users may wish to save long-form combined cluster data as a \code{.csv} file
#'     or similar after combining individual clusters with \code{\link{qm_combine}}. Unless
#'     data are saved as an \code{.rda} file, the class definition of \code{"qm_cluster"}
#'     will be lost. The \code{qm_verify} function allows users to import data from any
#'     file type readable by \code{R}, verify that it has the column names needed for
#'     \code{\link{qm_summarize}}, and re-add the \code{"qm_cluster"} class.
#'
#' @usage qm_verify(clusters)
#'
#' @param clusters An object created by \code{qm_combine} with two or more clusters worth of data
#'    that has been previously saved and requires verification before summarization.
#'
#' @return A tibble stored with a custom class of \code{qm_cluster} to facilitate data validation.
#'
#' @export
qm_verify <- function(clusters){

  # verify columns
  if (ncol(clusters) < 4){
    stop("The object given for 'clusters' has fewer than the minimum 4 columns.")
  }

  if ("RID" %in% names(clusters) == FALSE){
    stop("The variable 'RID' is missing and is required for verification.")
  }

  if ("CID" %in% names(clusters) == FALSE){
    stop("The variable 'CID' is missing and is required for verification.")
  }

  if ("CAT" %in% names(clusters) == FALSE){
    stop("The variable 'CAT' is missing and is required for verification.")
  }

  # ensure clusters is a tibble
  clusters <- dplyr::as_tibble(clusters)

  # add new class
  class(clusters) <- append(class(clusters), "qm_cluster")

  # return output
  return(clusters)

}
