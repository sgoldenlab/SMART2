regi_loop_new <- function (setup, filter = NULL, regis = NULL, plane = "coronal", 
          closewindow = TRUE, filetype = c("tif", "tiff", 
                                           "wmf", "emf", "png", "jpg", "jpeg", 
                                           "bmp", "ps", "eps", "pdf"), autoloop = FALSE, 
          touchup = FALSE, reference = FALSE, popup = TRUE, brightness = 70, 
          font_col = "white", font_size = 40, font_location = "+100+100", 
          gravity = "southwest", width = 18, height = 10.2) 
{
  filetype <- match.arg(filetype)
  if (is.null(regis) & !exists("regis", envir = .GlobalEnv)) {
    regis <<- vector("list", length = length(setup$regi_z))
  }
  else if (is.null(regis) & exists("regis", envir = .GlobalEnv)) {
    stop(paste0("The 'regis' vector already exists in the global environment.\n", 
                "\nPlease assign the 'regis' variable to the regis argument."))
  }
  if (autoloop) {
    tictoc::tic()
    for (s in 1:length(setup$regi_z)) {
      imnum <- setup$regi_z[s]
      AP <- setup$regi_AP[s]
      quartz(width, height)
      regis[[s]] <<- wholebrain::registration(setup$image_paths$regi_paths[imnum], 
                                              AP, plane = plane, filter = filter, display = TRUE, 
                                              output.folder = setup$savepaths$out_registration_warps)
      savepath <- paste0(setup$savepaths$out_auto_registration, 
                         "/registration_z_", toString(imnum), "_plate_", 
                         toString(platereturn(AP)), "_AP_", toString(round(AP, 
                                                                           digits = 2)), ".", filetype)
      curwin <- dev.cur()
      quartz()
      savePlot(filename = savepath, type = filetype, device = curwin)
      graphics.off()
      image <- magick::image_read(savepath)
      image <- magick::image_annotate(image, paste0("Plate ", 
                                                    toString(platereturn(AP)), ", AP ", toString(round(AP, 
                                                                                                       digits = 2)), ", z ", toString(imnum)), 
                                      gravity = gravity, size = font_size, color = font_col, 
                                      location = font_location)
      magick::image_write(image, path = savepath)
    }
    cat("\nRegistration autoloop was successfully completed!\n")
    time <- tictoc::toc(quiet = TRUE)
    cat("\n", toString(round((time$toc - time$tic)/60, 
                             digits = 2)), "min elapsed")
  }
  else {
    if (reference & length(setup) > 9) { # changed 8 to 9
      loop_z <- c(setup$first_z, setup$internal_ref_z, 
                  setup$last_z)
      loop_AP <- c(setup$first_AP, setup$internal_ref_AP, 
                   setup$last_AP)
    }
    else if (isTRUE(touchup) || is.numeric(touchup)) {
      if (isTRUE(touchup)) {
        cat("\nInstructions:\nBelow enter the plate numbers of the registrations you want to modify in ascending order.", 
            "\nNOTE: non-numeric input will be omitted.")
        val <- TRUE
        while (val) {
          plates <- readline(paste0("Which plates do you want to change? ", 
                                    "\nNote: You may use ':' to indicate a range & ',' to separate values."))
          plates <- unlist(strsplit(plates, ","))
          plates_col <- grep(":", plates, value = TRUE)
          plates_sing <- grep(":", plates, value = TRUE, 
                              invert = TRUE)
          if (length(plates_col) != 0) {
            colvec <- c()
            flag <- FALSE
            for (p in 1:length(plates_col)) {
              suppressWarnings(curvec <- as.integer(unlist(strsplit(plates_col[p], 
                                                                    ":"))))
              if (sum(is.na(curvec)) > 0) {
                flag <- TRUE
                break
              }
              else {
                colvec <- c(colvec, curvec[1]:curvec[2])
              }
            }
            plates_sing <- suppressWarnings(as.integer(plates_sing))
            plates <- c(colvec, plates_sing)
            suppressWarnings(if (sum(is.na(plates)) == 
                                 0 & flag == FALSE) {
              val <- FALSE
            })
          }
          else {
            plates <- suppressWarnings(as.integer(plates_sing))
            suppressWarnings(if (!sum(is.na(plates))) {
              val <- FALSE
            })
          }
        }
      }
      else if (is.numeric(touchup)) {
        plates <- as.integer(round(touchup))
      }
      regi_plates <- platereturn(setup$regi_AP)
      indices <- which(regi_plates %in% plates)
      loop_z <- setup$regi_z[indices]
      loop_AP <- setup$regi_AP[indices]
    }
    else {
      regis <- get("regis", envir = .GlobalEnv)
      indices <- which(unlist(lapply(regis, is.null)))
      if (length(indices) == 0) {
        stop("There are no plates that haven't been registered! If you like to change an existing registration, please set touchup = TRUE and regis = regis.")
      }
      loop_z <- setup$regi_z[indices]
      loop_AP <- setup$regi_AP[indices]
    }
    for (s in 1:length(loop_z)) {
      cat(" __________________________________________________________________________\n", 
          "                 You are starting a new registration!               \n", 
          "__________________________________________________________________________\n")
      imnum <- loop_z[s]
      AP <- loop_AP[s]
      print(AP) # added this line
      im_path <- setup$image_paths$regi_paths[imnum]
      index <- which(imnum == setup$regi_z)
      if (popup) {
        image <- magick::image_read(im_path)
        image <- magick::image_normalize(image)
        image <- magick::image_modulate(image, brightness = brightness)
        image <- magick::image_contrast(image)
        image <- magick::image_annotate(image, paste0("Plate ", 
                                                      toString(platereturn(AP)), ", AP ", toString(round(AP, 
                                                                                                         digits = 2)), ", z ", toString(imnum)), 
                                        gravity = gravity, size = font_size, color = font_col, 
                                        location = font_location)
        quartz() # this line replaces the one below
        # quartz(title = paste("z-slice ", toString(imnum)), canvas = "black")
        popup_cur <- dev.cur()
        plot(image)
        quartz(width, height)
        regis[[index]] <<- registration2(im_path, coordinate = AP, 
                                         filter = filter, correspondance = regis[[index]], 
                                         plane = plane, closewindow = closewindow, output.folder = setup$savepaths$out_registration_warps, 
                                         width = width, height = height)
      }
      else {
        quartz(width, height)
        regis[[index]] <<- list(NULL)
        regis[[index]] <<- registration2(im_path, coordinate = AP, 
                                         filter = filter, correspondance = regis[[index]], 
                                         plane = plane, closewindow = closewindow, output.folder = setup$savepaths$out_registration_warps, 
                                         width = width, height = height)
      }
      savepath <- paste0(setup$savepaths$out_registration, 
                         "/registration_z_", toString(imnum), "_plate_", 
                         toString(platereturn(AP)), "_AP_", toString(round(AP, 
                                                                           digits = 2)), ".", filetype)
      curwin <- dev.cur()
      quartz()
      savePlot(filename = savepath, type = filetype, device = curwin)
      graphics.off()
      image <- magick::image_read(savepath)
      image <- magick::image_annotate(image, paste0("Plate ", 
                                                    toString(platereturn(AP)), ", AP ", toString(round(AP, 
                                                                                                       digits = 2)), ", z ", toString(imnum)), 
                                      gravity = gravity, size = font_size, color = font_col, 
                                      location = font_location)
      magick::image_write(image, path = savepath)
      done <- FALSE
      while (!done) {
        input <- readline("Would you like to save the global environment after this registration? Y/N")
        if (input == "Y" | input == "y") {
          save.image(file = setup$savepaths$envir_savepath)
          done <- TRUE
        }
        else if (input == "N" | input == "n") {
          done <- TRUE
        }
      }
    }
  }
}
