#' @title Compile group data from individual brains.
#' @description Uses output of [cell_count_compilation()] to calculate
#' the mean and standard deviation of every user-specified test group.
#' @param input (required, default = NULL) Path to .csv file to be used,
#' the output of [cell_count_compilation()].
#' @param brains_list (required, default = c()) Vector of brain names (column
#' headers in .csv file).
#' @param groups_list (required, default = c()) Vector corresponding to brains_list
#' that specifies the group name for each brain.
#' @param groups (required, default = c()) Vector of groups.
#' @param output (required, default = NULL) Path to .csv file to be created.
#' @return Returns an object containing regional cell count means and
#' standard deviations for each test group.
#' @md
#' @export

get_groups <- function(input = NULL, brains_list = c(), groups_list = c(), groups = c(), output = NULL){

  # load data

  region_table <- read.csv(input)
  region_table <- region_table[2:length(region_table)]

  group_table <- data.frame(acronym = region_table[1])

  # calculate mean/SD and add to table

  for(i in 1:length(groups)){

    # figure out which brains are in the current group of interest

    current_brains <- c()
    current_brains <- which(groups_list %in% groups[i])

    # calculate means/SDs for all regions (among brains in the group of interest)

    standard_deviations <- c()

    means <- c()

    for(j in 1:length(region_table$acronym)){
      counts <- c()
      for(h in 1:length(current_brains)){
        counts <- c(counts, region_table[[current_brains[h] + 1]][j])
      }

      options(digits = 2)
      new_mean <- mean(counts)
      new_standard_deviation <- sd(counts)

      means <- c(means, new_mean)
      standard_deviations <- c(standard_deviations, new_standard_deviation)
    }

    group_table[paste0(toString(groups[i]), "_mean")] <- means
    group_table[paste0(toString(groups[i]), "_SD")] <- standard_deviations
  }

  setwd("C:/")
  write.csv(group_table, file = output)
  return(group_table)
}
