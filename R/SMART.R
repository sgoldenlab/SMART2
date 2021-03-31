#' SMART (Semi-manual alignment to reference template): a pipeline for whole brain mapping projects.
#'
#' @description
#' This package interfaces with the wholebrain package by Daniel Furth to process
#' whole brain imaging datasets. The pipeline is split into five different
#' parts, with the purpose of each function per part explained below. Note that
#' all functions that are exclusively meant to be used with whole brain datasets
#' will be marked with a **(W)** next to the function. Unmarked functions can be
#' used on single slice datasets across the brain.
#'
#' @details For convention, if a return value is given by a function,
#' the recommended variable name is indicated in italics in the return
#' section of each function's help page. If this return value is a
#' required argument for another function in the pipeline, the
#' the recommended variable name will also be the same name as the argument.
#'
#' @section Part 1. Setup pipeline:
#'
#' 1) [setup_pl()] User friendly way to setup parameters for whole or
#' partial brain pipeline analysis.
#' 2) [im_sort()]  A function to sort image paths for imaging datasets.
#' 3) [get_savepaths()] Generate savepaths and save directories.
#'
#' @section Part 2. Alignment (whole brain dataset):
#'
#' 1) [choice()] **(W)** User friendly choice game to align internal
#'    reference atlas plates.
#' 2) [brainmorph()] **(W)** Generate a brain morph plot.
#' 3) [interpolate()] **(W)** Interpolate all AP and z numbers
#'    for atlas plates in a whole brain project
#'
#' @section Part 3. Registration:
#'
#' 1) [registration2()] Console user interface built on top of
#' registration() function from the wholebrain package.
#' 2) [regi_loop()] Automatically loops through the image registration
#' processs for the imaging dataset.
#'
#' @section Part 4. Segmentation and forward warping:
#'
#' 1) [filter_loop()] Loops through reference slices and allows user to
#' check/change filter settings for segmentation or registration throughout the
#' brain.
#' 2) [seg_loop()] Loop through and segment images in the segmentation channel.
#' 3) [clean_duplicates()] **(W)** Duplicate cell count clean up of segmentation
#' output
#' 4) [cell_counter()] Determines total number of cells segmented, retained,
#' and removed by duplicate cleanup.
#' 5) [forward_warp()] Perform forward warp loop back onto atlas space using
#' segmentation and registration data.
#'
#' @section Part 5. Dataset manipulation and plotting:
#'
#' 1) [isolate_dataset()] Isolates a user-specified subset of the forward warped
#' dataset.
#' 2) [get_rois()] Get subset of the forward warped dataframe of just regions of
#' interest.
#' 3) [get_sunburst()] Generate a sunburst plot using a forward warped dataset.
#' 4) [get_tree()] Create a dataframe of hierarchical region cell count data.
#' 5) [glassbrain2()] Generate 3D plot of cells with option of plotting or
#' removing glassbrain in the background.
#' 6) [get_table()] Generates a dataframe showing region acronyms, their full
#' name, hierachical paths, total cell counts, left and right counts, and cell
#' count percentages.
#'
#' @section Part 6. Aggregating data from multiple analyses:
#'
#' 1) [concatenate()] Combines datasets from multiple brains.
#' 2) [cell_count_compilation()] Compiles cell counts from multiple brains.
#' 3) [get_groups()] Compiles group data from individual brains.
#' 4) [voxelize()] Generate voxel-based heatmaps from multiple brains.
#' 5) [voxel_stats()] Run statistical tests on voxel-based heatmaps.
#'
#' @md
#' @docType package
#' @name SMART
NULL
