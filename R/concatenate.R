#' @title Concatenate multiple datasets
#' @description  Loop through datasets across multiple .RData files,
#' corresponding to different SMART analyses, and combine datasets to form
#' one master dataset
#' @param data_list (required, default = c()) Vector of .RData files containing
#' datasets to be combined.
#' @param datasets (required, default = c()) Vector of dataset names, in quotes,
#' corresponding to each .RData file
#' @return Returns *group_dataset* a variable containing cells from all initial
#' datasets.
#' @export
#' @md

concatenate <- function(data_list = c(), datasets = c()){
  for(n in 1:length(data_list)){
    print(n)
    load(data_list[n])
    if(n == 1){
      group_dataset <- eval(parse(text = datasets[n]))
    }
    if(n > 1){
      group_dataset <- rbind(group_dataset, eval(parse(text = datasets[n])))
    }
  }
  return(group_dataset)
}

