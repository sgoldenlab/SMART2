#' @title Plate-by-plate cell counter for *segs* object.
#' @description Loop through all segmented cells to determine how
#' many cells were segmented, removed by [clean_duplicates()], and
#' retained after duplicate cleanup. Prints output in console.
#' @param segs (required) Segmentation data.
#' @md
#' @export

cell_counter <- function(segs = segs){
  cells <- c()
  nas <- c()

  cell_counter <- 0
  na_counter <- 0

  for(i in 1:length(segs$segmentations)){
    for(j in 1:length(segs$segmentations[[i]]$soma$x)){
      if(is.na(segs$segmentations[[i]]$soma$x[[j]]) == FALSE){
        cell_counter <- cell_counter + 1
      }
      if(is.na(segs$segmentations[[i]]$soma$x[[j]]) == TRUE){
        na_counter <- na_counter + 1
      }
    }
    cells <- c(cells, cell_counter)
    nas <- c(nas, na_counter)
    cell_counter <- 0
    na_counter <- 0
  }

  print(paste0("Retained cells by plate: ", toString(cells)))
  print(paste0("Removed cells by plate: ", toString(nas)))
  print(paste0((sum(cells) + sum(nas)), " total cells segmented"))
  print(paste0(sum(cells), " total cells retained"))
  print(paste0(sum(nas), " total cells removed"))
}
