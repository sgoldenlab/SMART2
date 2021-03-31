#' @title Compile cell counts from multiple brains.
#' @description  Loop through datasets across multiple .RData files,
#' corresponding to different SMART analyses, and compile cell counts
#' from each of them into a data table.
#' @param regions (optional, default = c("grey")) Vector of parent regions.
#' @param subregions (optional, default = 5) Number of hierarchical levels
#' below parent regions to include cell counts for.
#' @param clean_zeros (optional, default = FALSE) Boolean to specify whether
#' regions with 0 cells in all brains are removed.
#' @param datasets (required, default = c()) Vector of dataset names (in quotes)
#' corresponding to the relevant dataset in each .RData file.
#' @param files_list (required, default = c()) Vector of .RData files (including
#' file paths) to be accessed.
#' @param brains_list (required, default = c()) Vector of brain names (to be used as
#' column headers).
#' @param output (required, default = NULL) Path to .csv file to be created.
#' @return Returns an object containing regional cell counts from
#' all specified datasets.
#' @md
#' @export

cell_count_compilation <- function(regions = c("grey"), subregions = 5, clean_zeros = FALSE, hierarchy_level = FALSE, datasets = c(), files_list = c(), brains_list = c(), output = NULL){

  # create region list and create global region table

  region_list <- regions

  for(i in 1:subregions){
    temp_region_list <- c()
    for(j in 1:length(region_list)){
      child_regions <- wholebrain::get.acronym.child(region_list[j])
      new_child_regions <- c()
      if(is.na(child_regions) == FALSE){
        child_regions <- sort(child_regions)
        for(h in 1:length(child_regions)){
          if(((child_regions[h] %in% region_list) == FALSE) && ((child_regions[h] %in% temp_region_list) == FALSE)){
            new_child_regions <- c(new_child_regions, child_regions[h])
          }
        }
      }
      temp_region_list <- c(temp_region_list, region_list[j], new_child_regions)
    }
    temp_region_list <- temp_region_list[!is.na(temp_region_list)]
    region_list <- temp_region_list
  }

  region_list <- region_list[!is.na(region_list)]
  region_list <- unique(region_list)

  region_table <- data.frame(acronym = region_list)

  # iterate through RData files and add cell count data from each file to the global region table

  for(h in 1:length(files_list)){
    print(brains_list[h])
    load(files_list[h])

    new_counts <- c()

    for(j in 1:length(region_table$acronym)){
      new_region_count <- SMART::get_count(eval(parse(text = datasets[h])), roi = region_table$acronym[j])
      new_counts <- c(new_counts, new_region_count$cell.count)
    }

    region_table[toString(brains_list[h])] <- new_counts
  }

  # clean zeros, if user specified

  if(clean_zeros == TRUE){
    counter <- 0
    toggle <- FALSE

    for(i in 1:length(region_table$acronym)){
      n <- 2
      if(hierarchy_level == TRUE){
        n <- 3
      }
      for(j in n:length(region_table)){
        if(region_table[[j]][i - counter] != 0){
          toggle <- TRUE
        }
        else{
        }
      }

      if(toggle == FALSE){
        region_table <- region_table[-c(i - counter),]
        counter <- counter + 1
      }
      else{
      }
      toggle <- FALSE
    }
  }
  setwd("C:/")
  write.csv(region_table, file = output)
  return(region_table)
}
