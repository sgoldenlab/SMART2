# Wholebrain Installation

**5-20-2021 Note**: 

These instructions were originally written by Ben D. Singer in November 2018. 
I, Jia Jie Choong have added modifications to the R, RStudio, Rtools, and ROpenCVLite installation sections and include general suggestions on path setups due to various errors we have encountered in Windows. As I do not provide technical support for Wholebrain, errors in installation that can’t be solved by following these instructions should be directed to Daniel Furth, either through the Wholebrain Gitter chat room (https://gitter.im/tractatus/Lobby) or through his email (furth@cshl.edu).  

## Pre-installation Windows path recommendations 
Because of issues we have encountered previously with spaces in Windows paths, we recommend you check your user profile folder name located in the directory below:  

`C:\Users`

Make sure that your user account folder contains **no spaces**, otherwise the path spaces may cause an error during the installation. 
If you do have a space in your user folder, we suggest renaming your user account along with the user folder using these in-depth instructions: [link here](https://www.repairwin.com/how-to-rename-user-and-user-folder-in-windows-7-8-10/). Alternatively, you can create an entirely new user account with administrative privileges for the purposes of this installation and pipeline usage (this will be entirely separate from your normal account which may be annoying).  
