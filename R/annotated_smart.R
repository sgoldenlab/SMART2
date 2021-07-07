#General R Tips
  #quickly run lines of code by selecting a line or lines of interest and pressing (CTRL+ENTER)
  #make sure you're typing in the lower box if you're responding to prompts (ex: Y/N?)
    #if nothing shows up in the lower box, check to see if you accidentally typed in the top box, delete the added text and continue below
  #if you accidentally delete a line of code, press (CTRL+Z)
    #if that doesn't restore the code, close without saving and re-open the R file
    #in the case that you accidentally save, re-copy the master R script and open/continue with the copy
  #to use a line of code you just ran, use the arrow keys while typing in the lower box to navigate to previously used lines of code

#ALWAYS run upon first opening R
library(wholebrain)
library(SMART)
quartz()

#LOAD SAVED PROJECT
  #file -> open file -> navigate to project folder -> output -> R_data

#1. PROJECT SET-UP
  #telling SMART where your images to be analyzed are and where it should put project output
  #do this for each new slice or brain you're analyzing!

#start by creating a folder for the brain you're working on, then create 3 subfolders: output, registration, segmentation
  #this folder setup may vary depending on who you're analyzing brains for!

#making a new project
setup <- setup_pl()
setup <- setup_pl(setup)
setup <- im_sort(setup, extension = "tif")
setup$image_paths
setup <- get_savepaths(setup)
setup$savepaths

#project set-up TIPS: 
  #quickly copy file paths by navigating to folder in file explorer, clicking in top navigational bar, selecting all and copy-pasting into R
  #find atlas plate number by opening "Z:\Protocols\SMART\SMART_alignment_reference_atlas.pdf" and finding the plate that best matches slice in your image
    #this can be hard to match when you're first figuring things out! try to match major landmarks (ex: corpus callosum-- does it join in the middle or not?)
  #z number refers to the number of images in a project (your first image is 1, your second image is 2, etc.)
  #if you get a savepath error at any point, re-run project set-up then return to where you encountered the error, and try to re-run code


#SAVE (use to save project progress throughout)

save.image(setup$savepaths$envir_savepath)

#2. REGISTRATION
  #matching our brain atlas to our slice image so SMART knows which regions of the brain are where in our image!

#Create filter for registration

#default filter 
  #running the entire chunk of code will give filter these settings
  #this is a good place to store settings best suited to your project!
filter<-structure(list(alim = c(50, 50),
                       threshold.range = c(50, 1000L),
                       eccentricity = 999L,
                       Max = 50,
                       Min = 0,
                       brain.threshold = 10L,
                       resize = 0.04,
                       blur = 4L,
                       downsample = .25))

#registration filter GUI
  #use to check and modify filter settings
  #we want the green outline to match the outline of our brain slice
filter <- filter_loop(setup, channel = "regi", filter = filter)

#registration filter TIPS:
  #change MAX and MIN for image exposure
  #change BRAIN THRESHOLD to change how large or small green outline is
  #change BLUR to smooth edges of green outline
  #for ease of exiting GUI, click an opened GUI window then hit ESC

#auto-registration
regi_loop(setup, autoloop = TRUE, filter = filter)

#TIPS:
  #if auto-registration has matrix error, re-run filter and change RESIZE
  #if auto-registration has transformation error, look at original image to see if the slice is close to the image borders
      #to fix this, open original image in imagej
          #imagej -> image -> adjust -> canvas size -> increase height and width values by ~100 pixels
          #if there are any abnormally bright areas, select with selection tools and fill using edit -> fill
          #to save: file -> save as -> TIFF -> keep the SAME FILE NAME AND FILE LOCATION as original image
      #repeat with the same NEW dimensions you used for the SEGMENTATION IMAGE to ensure image sizes match up during processing

#pre-autoregistration
  #run before re-running auto-registration
rm(regis)

#manual registration
  #step 1: open pre-registration script.R (find in "Z:\Protocols\SMART\SMART Master R Scripts\pre-registration script.R")
  #step 2: run all of pre-registration script.R
  #step 3: run regi_loop_new

regi_loop_new(setup, regis = regis, filter = filter, reference = TRUE, touchup = TRUE)

#TIPS
  #when prompted for plate number, use your atlas plate number! (corresponds to AP coordinate)
    #if you don't remember the atlas # you started the project with, open file explorer
      #navigate to your SMART project folder -> output -> Registrations_auto -> within this folder are the auto-registered images
      #auto-registered images have file names in the format "registration_z_1_plate_42_AP_1.2"
        #your atlas plate number is the number after "plate" in file name

#we want the purple outline to line up with the brain tissue of our slice!

#manual registration TIPS:
  #when adding points click the tissue on the right image first, then the orange outline on the left
  #align the midline first! usually involves adjusting points 1 and 17
          #if registration is very messy, deleting all points other than the midline can be helpful: r for remove, then list many points shorthand using a colon (ex: if i have 32 points, I remove all but 1 and 17 using 2:16, 18:32)
  #if adding points, stick to a max of 4 at a time before you get more comfortable placing them!
    #if you mess up positioning a point, finish adding the rest of the points, then use Z to revert to your previous adjustments
  #if there are gaps/tears in the slice tissue, ensure outline traces around them (pretend the slice is perfect)
  #look for landmarks to help with alignment! familiarize yourself with the identification and alignment of several distinct regions in your slice from here (https://mouse.brain-map.org/experiment/thumbnails/100048576?image_type=atlas)
  #if the image is hard to see try to adjust filter settings and re-run loop
          #alternatively open the original image file and use that as a positioning reference
  #if the atlas outline does not move when new points are added/old points are adjusted, try deleting points that may be pinning the outline in the wrong conformation (TRYING TO ADD MORE POINTS WILL NOT HELP)
  #to save in the middle of a manual registration hit F and SAVE (you can always reopen the project and continue later!)

#3. SEGMENTATION
  #taking cell annotation outputs from QuPath and counting how many cells there are per atlas brain region 

#Create filter for segmentation

#default segmentation filter
  #running the entire chunk of code will give filter these settings
  #this is a good place to store settings best suited to your project!

filter<-structure(list(alim = c(0, 200),
                       threshold.range = c(0, 1000L),
                       eccentricity = 999L,
                       Max = 1,
                       Min = 0,
                       brain.threshold = 40,
                       resize = 0.05,
                       blur = 5L,
                       downsample = 0.75))


#segmentation filter GUI
  #use to check and modify filter settings
  #we want all the white dots from segmentation to be marked in red!

filter <- filter_loop(setup, channel = "seg")

#TIPS: click within segmentation image to zoom in on a particular region 
  #increase DOWNSAMPLE and re-run filter to increase size of zoomed-in region
  #ALIM changes the range of cell body sizes the filter looks for
      #if filter is missing larger cells, increase max ALIM
      #if filter is counting two smaller cells as 1, decrease max ALIM
  #to catch more cells after changing ALIM, move around DOWNSAMPLE value
  #segmentation may not catch all your segmented cells! being off by ~100 or fewer is normal, but always check with your grad student to ensure that the cell count is close to the QuPath output
  #for ease of exiting GUI, click an opened GUI window then hit ESC

#segmentation
  #run this to see output cell counts per image in your project
  #for error in wholebrain::segment(setup$image_paths[[c]][z], filter = filter): fix by setting up project again to get savepaths
segs <- seg_loop(setup, filter)

#forward warp
  #run this to have segmented cell counts transformed back onto the allen brain atlas space

dataset <- forward_warp(setup, segs, regis)

#3. DATA COLLECTION
  #viewing and saving the results of segmentation for analysis

#plot
  #figure of cell counts by brain region and hemisphere

dot.plot(dataset)

#get table of cell counts by region and export as .csv 
  #step 1: get table
  #step 2: run write.csv after copy-pasting your savepath into "file path here"
          #make sure formatting is in Z:/Filepath/Filename.csv
          #to save positional data of all segmented cells, replace "table" in write.csv with "dataset"
#get table
table <- get_table(dataset)

View(table)

#write.csv

write.csv(table,"file path here", row.names = FALSE)

#4. COOL FIGURES
  #run any of these to see some badass figures
  #to learn more about any of these, check the SMART documentation (https://github.com/sgoldenlab/SMART/blob/master/docs/tutorial.md)
    #feel free to add additional scripts from the documentation as well :) not all of them are on here!

# Get dataset of just rois
rois <- get_rois(dataset, rois = c("Your ROIS here"))

# Plot region cell counts in a table
quartz()
wholebrain::dot.plot(rois)

# Plot sunburst plot
SMART::get_sunburst(dataset)

# Hierarchical dataframe of just the hypothalamus
tree <- get_tree(dataset, rois = "LS")
View(tree)

# Generate rgl object and plot glassbrain without 3D atlas boundaries
glassbrain <- glassbrain2(dataset, high.res = "OFF", jitter = TRUE) 

# visualize glass brain 
glassbrain

# Example usage:
# Get data table displaying cell counts from Ammon's horn
table <- get_table(dataset, rois = "CA", base = "HIP")
View(table)

# Setting the base argument to "HIP" changes the count percentage to be out of the entire hippocampal formation
# Change base to "CA" bases the percentage counts off cell counts in Ammon's horn exclusively
# Change base and rois to "grey" to get all cell counts of grey matter in the brain


table <- get_table(dataset)

quartz()
wholebrain::dot.plot(rois)


wholebrain::dot.plot(dataset)

