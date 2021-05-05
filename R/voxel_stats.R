#' @title Run statistical tests on voxel-based heatmaps
#' @description Generate statistical outputs from voxel-based heatmaps created
#' by [voxelize()]. Statistical output resembles input heatmaps, with green/red
#' colors specifying locations where voxels show statistically significant
#' differences between groups.
#' @param input (required) Specify path to input .RData file containing the
#' group matrix.
#' @param group_matrices (required) Specify object name for matrix of groups.
#' @param groups (required, default = c()) Vector of 2 groups to be compared.
#' @param ML_bounds (optional, default = c(-5, 5)) Bounds for ML axis.
#' @param DV_bounds (optional, default = c(-8, 1)) Bounds for DV axis.
#' @param p_value (optional, default = 0.05) P-value threshold for significance.
#' @param output (required) Specify path to output folder to save heatmap and .RData output.
#' @return Returns *stat_matrix* an object containing a matrix with statistical test
#' output (-1 for significantly lower, 0 for no significance, 1 for significantly higher).
#' @export
#' @md

voxel_stats <- function(input, group_matrices, groups = c(), ML_bounds = c(-5, 5), DV_bounds = c(-8, 1), p_value = 0.05, output){

  load(input)

  m <- which(names(group_matrices) %in% groups[1])
  n <- which(names(group_matrices) %in% groups[2])

  stat_matrix <- group_matrices[[1]][[1]]

  for(i in 1:length(stat_matrix)){
    stat_matrix[i] <- 0
  }

  for(y in 1:nrow(stat_matrix)){
    for(x in 1:ncol(stat_matrix)){
      group_1_values <- c()
      group_2_values <- c()

      for(z in 1:(length(group_matrices[[m]]) - 2)){
        group_1_values <- c(group_1_values, group_matrices[[m]][[z]][y, x])
      }
      for(z in 1:(length(group_matrices[[n]]) - 2)){
        group_2_values <- c(group_2_values, group_matrices[[n]][[z]][y, x])
      }

      stat_output <- t.test(group_1_values, group_2_values, conf.level = 0.95)


      heat_value <- 0

      if(!is.na(stat_output$p.value)){
        if(stat_output$p.value < p_value){
          if(stat_output$statistic[[1]] > 0){ # if first group is higher
            heat_value <- 1
          }
          if(stat_output$statistic[[1]] < 0){ # if second group is higher
            heat_value <- -1
          }
        }
      }

      stat_matrix[y,x] <- heat_value
    }
  }

  xlabels <- round(c(seq(ML_bounds[1], ML_bounds[2], by = 1)), digits = 1)
  ylabels <- round(c(seq(DV_bounds[1], DV_bounds[2], by = 1)), digits = 1)

  colorBreaks <- seq(-1, 1, length.out = 6)

  heatmap_colorkey <- list(at = colorBreaks, labels = list(at = colorBreaks, labels = round(colorBreaks, 1)))

  for(z in 1:length(heatmap_colorkey$labels$labels)){
    if((z != 1) & (z != length(heatmap_colorkey$labels$labels))){
      heatmap_colorkey$labels$labels[z] <- ""
    }
  }

  heatmap_plot <- lattice::levelplot(t(apply(stat_matrix, 2, rev)),
                                     col.regions = colorRampPalette(c("green", "white", "red"), space = "rgb"),
                                     scales = list(
                                       y = list(
                                         at = seq(0, nrow(stat_matrix) - nrow(stat_matrix)/(DV_bounds[2] - DV_bounds[1]),
                                                  nrow(stat_matrix)/(DV_bounds[2] - DV_bounds[1])), labels = ylabels),
                                       x = list(
                                         at = seq(0, ncol(stat_matrix) - ncol(stat_matrix)/(ML_bounds[2] - ML_bounds[1]),
                                                  ncol(stat_matrix)/(ML_bounds[2] - ML_bounds[1])), labels = xlabels),
                                       tck = c(1,0)),
                                     main = list(paste0(groups[1], " vs ", groups[2], ", threshold ", p_value)),
                                     xlab = "Medial-Lateral (mm)",
                                     ylab = "Dorsal-Ventral (mm)",
                                     pretty = FALSE,
                                     at = colorBreaks,
                                     colorkey = heatmap_colorkey)

  quartz() #Get plot in its own window
  print(heatmap_plot) #print the plot in the window

  # this code is to properly label the legend

  lattice::trellis.focus("legend", side="right", clipp.off=TRUE, highlight=FALSE) #legend parameters
  grid.text(expression( ), 0.25, 0, hjust = 0.5, vjust = 1.5) #legend parameters and name
  lattice::trellis.unfocus()

  # save the plot

  savepath <- paste0(output, "/", groups[1], " vs ", groups[2], ", threshold ", p_value, ".png")
  curwin <- dev.cur()
  savePlot(filename = savepath, type = "png", device = curwin)
  dev.off()

  save(stat_matrix, file = paste0(output, "/stat_matrix_", groups[1], " vs ", groups[2], ", threshold ", p_value, ".RData"))

  return(stat_matrix)
}
