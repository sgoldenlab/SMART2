#' @title Generate voxel-based heatmaps
#' @description Generate voxel-based cell density heatmaps based on datasets
#' from SMART analysis. Generate group mean and SD heatmaps to show trends across
#' test groups. Generate .csv files containing raw heatmap data for downstream
#' statistical analysis.
#' @param data_list (required, default = c()) Vector of .RData files (including
#' file paths) to be accessed.
#' @param datasets (required, default = c()) Vector of dataset names (in quotes)
#' corresponding to the relevant dataset in each .RData file. To generate heatmaps
#' for individual brain slices, use [isolate_dataset()] to isolate cells from a
#' specific plate.
#' @param groups_list (required, default = c()) Vector corresponding to brains_list
#' that specifies the group name for each brain.
#' @param groups (required, default = c()) Vector of groups.
#' @param ML_bounds (optional, default = c(-5, 5)) Bounds for ML axis.
#' @param DV_bounds (optional, default = c(-8, 1)) Bounds for DV axis.
#' @param detection_bounds (optional, default = c(0.1, 0.1)) Side length (in mm) of
#' detection square around each search point.
#' @param resolution (optional, default = 50) Number of search points in each dimension,
#' per millimeter (e.g. resolution 50 divides each square mm into a 50 x 50 grid with
#' 2,500 search points).
#' @param heatmaps (optional, default = TRUE) Specify whether to output heatmaps.
#' @param save (optional, default = TRUE) Specify whether to save .csv files.
#' @param output (required, default = NULL) Specify path to output folder to output
#' .csv files, heatmaps, and .RData files.
#' @return Returns *group_matrices* an object containing all brain matrices, as well
#' as group mean and SD matrices.
#' @export
#' @md

voxelize <- function(brains_list = c(), data_list = c(), datasets = c(), groups_list = c(), groups = c(), ML_bounds = c(-5, 5), DV_bounds = c(-8, 1),
                     detection_bounds = c(0.1, 0.1), resolution = 50, heatmaps = TRUE, save = TRUE, output = NULL){

  #create overarching matrix

  group_matrices <- vector("list", length = length(groups))
  names(group_matrices) <- groups

  # loop through groups

  for(k in 1:length(groups)){

    # figure out which brains are in the relevant group

    current_brains <- c()
    current_brains <- which(groups_list %in% groups[k])

    current_brain_names <- c()

    for(j in 1:length(current_brains)){
      current_brain_names <- c(current_brain_names, brains_list[current_brains[j]])
    }

    brain_matrices <- vector("list", length = (length(current_brains) + 2))
    names(brain_matrices) <- c(current_brain_names, "mean", "SD")

    # loop through brains

    for(j in 1:length(current_brains)){

      print(paste0(current_brains[j], ", ", brains_list[current_brains[j]], ", ", toString(datasets[current_brains[j]])))

      load(data_list[current_brains[j]])

      # generate matrix

      cell_matrix <- matrix(c(0), ncol = (ML_bounds[2] - ML_bounds[1]) * resolution, nrow = (DV_bounds[2] - DV_bounds[1]) * resolution)

      row_names <- (DV_bounds[1] * resolution + 1):(DV_bounds[2] * resolution)
      column_names <- (ML_bounds[1] * resolution + 1):(ML_bounds[2] * resolution)

      rownames(cell_matrix) <- row_names / resolution
      colnames(cell_matrix) <- column_names / resolution

      # populate matrix

      x_bounds <- (detection_bounds[1] / 2)
      y_bounds <- (detection_bounds[2] / 2)

      all_cells_x <- eval(parse(text = datasets[current_brains[j]]))$ML
      all_cells_y <- eval(parse(text = datasets[current_brains[j]]))$DV

      for(y in 1:nrow(cell_matrix)){
        print(paste0(y, " of ", nrow(cell_matrix)))
        y_estimate <- (y - 1)/resolution + DV_bounds[1]
        for(x in 1:ncol(cell_matrix)){
          x_estimate <- (x - 1)/resolution + ML_bounds[1]
          counter <- 0

          for(z in 1:length(all_cells_x)){
            if((abs(all_cells_x[z] - x_estimate) < x_bounds) & (abs(all_cells_y[z] - y_estimate) < y_bounds)){
              counter <- counter + 1
            }
          }
          cell_matrix[y,x] <- counter / (detection_bounds[1] * detection_bounds[2] * (max(eval(parse(text = datasets[current_brains[j]]))$AP) - min(eval(parse(text = datasets[current_brains[j]]))$AP)))
        }
      }

      # save cell matrix in list

      brain_matrices[[j]] <- cell_matrix

    }

    # make group mean/SD tables

    mean_matrix <- matrix(c(0), ncol = (ML_bounds[2] - ML_bounds[1]) * resolution, nrow = (DV_bounds[2] - DV_bounds[1]) * resolution)
    SD_matrix <- matrix(c(0), ncol = (ML_bounds[2] - ML_bounds[1]) * resolution, nrow = (DV_bounds[2] - DV_bounds[1]) * resolution)

    # populate matrices

    for(y in 1:nrow(mean_matrix)){
      for(x in 1:ncol(mean_matrix)){
        values <- c()
        for(z in 1:(length(brain_matrices) - 2)){
          values <- c(values, brain_matrices[[z]][y, x])
        }

        mean_matrix[y,x] <- mean(values)
        SD_matrix[y,x] <- sd(values)
      }
    }

    # save matrix in list

    brain_matrices[[length(brain_matrices) - 1]] <- mean_matrix
    brain_matrices[[length(brain_matrices)]] <- SD_matrix

    # flip matrices

    for(n in 1:length(brain_matrices)){
      brain_matrices[[n]] <- apply(brain_matrices[[n]], 2, rev)
    }

    # save matrix in group matrix

    group_matrices[[k]] <- brain_matrices

    # save matrices as .csv

    if(save == TRUE){
      for(n in 1:length(brain_matrices)){
        write.csv(brain_matrices[[n]], file = paste0(output, "/", groups[k], "_group_", names(brain_matrices)[n], "_cell_densities_", 1000 / resolution, "_um_voxels", ".csv"),
                  row.names = rev(row_names / resolution))
      }
    }

    # generate heatmaps

    if(heatmaps == TRUE){
      for(n in 1:length(brain_matrices)){
        xlabels <- round(c(seq(ML_bounds[1], ML_bounds[2], by = 1)), digits = 1)
        ylabels <- round(c(seq(DV_bounds[1], DV_bounds[2], by = 1)), digits = 1)

        colorBreaks <- seq(0, max(brain_matrices[[n]]), length.out = 20)

        heatmap_colorkey <- list(at = colorBreaks, labels = list(at = colorBreaks, labels = round(colorBreaks, 1)))

        for(z in 1:length(heatmap_colorkey$labels$labels)){
          if((z - 1) %% 2 != 0){
            heatmap_colorkey$labels$labels[z] <- ""
          }
        }

        # make and plot the plot

        heatmap_plot <- lattice::levelplot(t(apply(brain_matrices[[n]], 2, rev)),
                                           col.regions = colorRampPalette(c("white", "red"), space = "rgb"),
                                           scales = list(
                                             y = list(
                                               at = seq(0, nrow(brain_matrices[[n]]) - nrow(brain_matrices[[n]])/(DV_bounds[2] - DV_bounds[1]),
                                                        nrow(brain_matrices[[n]])/(DV_bounds[2] - DV_bounds[1])), labels = ylabels),
                                             x = list(
                                               at = seq(0, ncol(brain_matrices[[n]]) - ncol(brain_matrices[[n]])/(ML_bounds[2] - ML_bounds[1]),
                                                        ncol(brain_matrices[[n]])/(ML_bounds[2] - ML_bounds[1])), labels = xlabels),
                                             tck = c(1,0)),
                                           main = list(paste0(groups[k], " group, ", stringr::str_to_upper(names(brain_matrices)[n]), ", ", 1000 / resolution, " um resolution, ",
                                                              detection_bounds[1], " mm x ", detection_bounds[2], " mm detection radius")),
                                           xlab = "Medial-Lateral (mm)",
                                           ylab = "Dorsal-Ventral (mm)",
                                           pretty = FALSE,
                                           at = colorBreaks,
                                           colorkey = heatmap_colorkey)

        quartz() # get plot in its own window
        print(heatmap_plot) # print the plot in the window

        # this code is to properly label the legend

        lattice::trellis.focus("legend", side="right", clipp.off=TRUE, highlight=FALSE) #legend parameters
        grid.text(expression(cells/mm^3), 0.25, 0, hjust = 0.5, vjust = 1.5) #legend parameters and name
        lattice::trellis.unfocus()

        # save the plot

        savepath <- paste0(output, "/", groups[k], "_group_", names(brain_matrices)[n], "_cell_densities_", 1000 / resolution, "_um_voxels", ".png")
        curwin <- dev.cur()
        savePlot(filename = savepath, type = "png", device = curwin)
        dev.off()
      }
    }
  }

  save(group_matrices, file = paste0(output, "/group_matrices_", 1000 / resolution, "_um_voxels.RData"))

  return(group_matrices)
}
