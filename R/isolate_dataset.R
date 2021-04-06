#' @title Selectively isolate forward-warped cells **(W)**.
#' @description  Isolate a user-specified subset of the forward warped dataset.
#' The user may use any or all of the available parameters they choose to isolate
#' their cells of interest. An explanation of the isolate_dataset() parameters is
#' provided below
#' @param setup (required) Setup list from [setup_pl()].
#' @param dataset (required) Dataset output from [forward_warp()].
#' @param start_AP (optional, default = NULL) Most anterior AP to retain
#' cells.
#' @param end_AP (optional, default = NULL) Most posterior AP to retain
#' cells.
#' @param hemisphere (optional, default = "B") Hemisphere to retain cells
#' from ("L", "R", or "B").
#' @param plates (optional, default = c(1:length(unique(dataset$image))))
#' Vector of registration plates to retain plates from; specify plate numbers
#' relative to the first registration plate in the current analysis.
#' @param mirror (optional, default = FALSE) Boolean to specify whether all
#' cells will be mirrored across the midline.
#' @param flip (optional, default = FALSE) Boolean to specify whether all cells
#' will be flipped across the midline.
#' @param bounds (optional, default = c()) Vector to specify whether cells within
#' a circular or rectangular area should be retained. For circles, the vector
#' should be formatted as: c("circle", ML-center, DV-center, radius). For
#' rectangles, the vector should be formatted as: c("rectangle",
#' ML-top-left-corner, DV-top-left-corner, width, height).
#' @param rois (optional, default = c("grey")) Vector to specify regions of interest
#' to retain cells from.
#' @return Returns *isolated_dataset* a variable storing all cells retained from
#' *dataset*.
#' @md
#' @export

isolate_dataset <- function (setup, dataset, start_AP = NULL, end_AP = NULL, hemisphere = "B",
                             plates = c(1:length(unique(dataset$image))), mirror = FALSE, flip = FALSE, bounds = c(), rois = c("grey"))
{

  isolated_dataset <- dataset

  if(is.null(start_AP)){
    start_AP <- setup$first_AP
  }
  if(is.null(end_AP)){
    end_AP <- setup$last_AP
  }

  # isolate based on AP and hemisphere

  wrong_hemi <- c()
  for(i in 1:length(dataset$animal)){
    if((dataset$AP[i] >= start_AP) | (dataset$AP[i] <= end_AP) | ((hemisphere == "R") & (dataset$right.hemisphere[i] == FALSE)) | ((hemisphere == "L") & (dataset$right.hemisphere[i] == TRUE))){
      wrong_hemi <- c(wrong_hemi, i)
    }
  }
  if(length(wrong_hemi) > 0){
    isolated_dataset <- isolated_dataset %>% dplyr::slice(-c(wrong_hemi))
  }

  # isolate based on regi image

  if(length(plates) != length(unique(dataset$image))){
    wrong_plate <- c()
    all_regi_plates <- unique(dataset$image)
    specific_regi_plates <- c()
    for(i in 1:length(plates)){
      specific_regi_plates <- c(specific_regi_plates, all_regi_plates[plates[i]])
    }
    for(i in 1:length(isolated_dataset$animal)){
      if((isolated_dataset$image[i] %in% specific_regi_plates) == FALSE){
        wrong_plate <- c(wrong_plate, i)
      }
    }
    if(length(wrong_plate) > 0){
      isolated_dataset <- isolated_dataset %>% dplyr::slice(-c(wrong_plate))
    }
  }

  # keep cells within circle/rectangle coordinates, if user specified

  if(length(bounds) > 0){

    #circle

    if(bounds[1] == "circle"){
      outside_circle <- c()
      for(i in 1:length(isolated_dataset$animal)){
        distance_score <- sqrt((isolated_dataset$ML[i] - as.numeric(bounds[2]))^2 + (isolated_dataset$DV[i] - as.numeric(bounds[3]))^2)
        if(distance_score > as.numeric(bounds[4])){
          outside_circle <- c(outside_circle, i)
        }
      }
      if(length(outside_circle) > 0){
        isolated_dataset <- isolated_dataset %>% dplyr::slice(-c(outside_circle))
      }
    }

    # rectangle

    if(bounds[1] == "rectangle"){
      outside_rectangle <- c()
      for(i in 1:length(isolated_dataset$animal)){
        if((isolated_dataset$ML[i] < as.numeric(bounds[2])) | (isolated_dataset$ML[i] > (as.numeric(bounds[2]) + as.numeric(bounds[4]))) | (isolated_dataset$DV[i] < as.numeric(bounds[3])) | (isolated_dataset$DV[i] > (as.numeric(bounds[3]) + as.numeric(bounds[5])))){
          outside_rectangle <- c(outside_rectangle, i)
        }
      }
      if(length(outside_rectangle) > 0){
        isolated_dataset <- isolated_dataset %>% dplyr::slice(-c(outside_rectangle))
      }
    }
  }

  # isolate specific rois, if user specified

  if(rois[1] != "grey"){
    outside_regions <- c()
    all_rois <- c()
    for(i in 1:length(rois)){
      all_rois <- c(all_rois, SMART::get_all_children(rois[i]))
    }
    all_rois <- unique(all_rois)
    for(i in 1:length(isolated_dataset$animal)){
      if((isolated_dataset$acronym[i] %in% all_rois) == FALSE){
        outside_regions <- c(outside_regions, i)
      }
    }
    if(length(ouside_regions) > 0){
      isolated_dataset <- isolated_dataset %>% dplyr::slice(-c(outside_regions))
    }
  }

  # mirror cells, if user specified

  if(mirror == TRUE){
    flipped_dataset <- isolated_dataset
    flipped_dataset$right.hemisphere <- !flipped_dataset$right.hemisphere
    flipped_dataset$ML <- flipped_dataset$ML * -1
    isolated_dataset <- rbind(isolated_dataset, flipped_dataset)
  }

  # flip cells, if user specified

  if(flip == TRUE){
    isolated_dataset$right.hemisphere <- !isolated_dataset$right.hemisphere
    isolated_dataset$ML <- isolated_dataset$ML * -1
  }

  print(paste0(length(dataset$animal), " cells in initial dataset, ", length(dataset$animal) - length(isolated_dataset$animal), " cells deleted, ", length(isolated_dataset$animal), " cells retained."))

  return(isolated_dataset)
}
