# Wholebrain Installation

**5-20-2021 Note**: 

These instructions were originally written by Ben D. Singer in November 2018. 
I, Jia Jie Choong have added modifications to the R, RStudio, Rtools, and ROpenCVLite installation sections and include general suggestions on path setups due to various errors we have encountered in Windows. As I do not provide technical support for Wholebrain, errors in installation that can’t be solved by following these instructions should be directed to Daniel Furth, either through the Wholebrain Gitter chat room (https://gitter.im/tractatus/Lobby) or through his email (furth@cshl.edu).  

## Pre-installation Windows path recommendations 
Because of issues we have encountered previously with spaces in Windows paths, we recommend you check your user profile folder name located in the directory below:  

`C:\Users`

Make sure that your user account folder contains **no spaces**, otherwise the path spaces may cause an error during the installation. 
If you do have a space in your user folder, we suggest renaming your user account along with the user folder using these in-depth instructions: [link here](https://www.repairwin.com/how-to-rename-user-and-user-folder-in-windows-7-8-10/). Alternatively, you can create an entirely new user account with administrative privileges for the purposes of this installation and pipeline usage (this will be entirely separate from your normal account which may be annoying).  

## Installing Wholebrain on Windows 
Please follow the steps from top to bottom. 

### Pre-installation step
Please go to [this link](https://osf.io/fvbuh/) to download all the installation files needed for wholebrain.

### Install R --version 3.5.2

1. Click on R-3.5.2-win.exe to install. Please install to the default path as shown below.

![](/images/r35.png)

2. Under Select Components, choose "64-bit User Installation." (Make sure to uncheck any files associated with the 32-bit installation!). Please make sure the settings are as shown as the image below.

![](/images/r352.png)

## Install RStudio –version 1.1.463

1.	Click on RStudio-1.1.463.exe and use the default destination folder path.

![](/images/rs1.png)

2.	Once RStudio is working, please install the devtools package from CRAN. 
3.  Open RStudio and copy and paste the lines below to the console, then press “Enter” to run the command: 
4.  Close RStudio.

## Install FFTW --version 3.3.5

1.	Copy the fftw folder into C: drive and add C:\fftw into your environment path.

![](/images/fftw.png)

2.	Add the LIB_FFTW Environment Variable to Windows, click on New.. and LIB_FFTW as the variable name and C:\fftw as the variable value.

![](/images/fftw2.png)

3.	Under Path, add new environment variable C:\fftw

![](/images/fftw3.png)

## Install Rtools --version 3.5

1.	Click on Rtools35.exe and install to the default folder path.

![](/images/rtools1.png)

2.	Under Select Components, choose "R toolset, Cygwin DLLs, and R 3.3.x + 64 bit toolchain" not 32-bit.

![](/images/rtools2.png)

3.	Check both checkboxes.

![](/images/rtools3.png)

4.	Open Rstudio and run the following command, `devtools::install_github("r-lib/devtools")`

5.	If it asks to install the latest update, choose `1. All`

![](/images/rtools4.png)

6.	Once  Rtools is installed, copy everything in C:\Rtools folder and make a folder name “usr” and paste all the files you copied into “usr”. Both the folders should look like the images below.

![](/images/rtools5.png)

![](/images/rtools6.png)

9.	Set System Path To include R, Rtools, and FFTW. 

You will get the option to set the System Path from within the Rtools installer. Check the box. At the top of the list, it should list (add if not) the Rtools bin directories: 

  - C:\Rtools\bin 
  - C:\Rtools\mingw_64\bin 
  - C:\fftw 
  - C:\Program Files\R\R-3.5.2\bin\x64

8.	To check compatibility of the devtools package with the Rtools installation, first restart your RStudio session to ensure the paths are updated in R; then run the command below in the console as a check. The output should be TRUE.
`library(pkgbuild)`
`find_rtools()`

9.	Quit RStudio

## Install CMake -- version 3.8.0-rc2

1.	Click on cmake-3.8.0-rc2-win64-x64.msi and Install to its default location. 

![](/images/cmake.png)

2.	Check the box to update the System PATH ("for all users".) It should add: 

![](/images/cmake2.png)

## Install Wholebrain Part I: ROpenCVLite 

1.	Startup RStudio again. If it was running, quit it first. 
2.	At the console, enter: `devtools::install_github("swarm-lab/ROpenCVLite", ref = "v0.3.410", INSTALL_opts="--no-multiarch")`
3.	This will install the latest working version of ROpenCVLite. If you don’t set the “ref” variable, the development version may throw an error. The install options don't seem to matter but we can keep these original args in there. The package will install without directly installing OpenCV into your R package library. 
4.  Run the line below in the console to install opencv: `ROpenCVLite::installOpenCV()`

![](/images/cv1/png)

5. It will ask the following question, `Select 1. Yes.`
6. NOTE: The function above may generate interactive package update options from CRAN. If any of these updated packages are causing problems, we recommend skipping all package update options. It opencv should build successfully (it will require CMake be installed correctly.) We can now add the opencv path to the System PATH, now that opencv is installed. 
7.	Quit RStudio. 

### Update System Path to include R and ROpenCVLite 

1.	Open up environment variables and make sure the following Path contains all of the variables below, else add them.
- C:\Rtools\bin 
- C:\Rtools\mingw_64\bin 
- C:\fftw 
- C:\Program Files\R\R-3.5.2\bin\x64
- C:\Users\TheGoldenLab\Documents\R\win-library\3.5\ROpenCVLite\opencv\x64\mingw\bin
- C:\Program Files\CMake\bin

## Install Wholebrain Part II: Wholebrain proper 
1.	Make sure that you quit RStudio, since the system PATH has changed. Then start it up again. No need to save the workspace each time it asks, btw. 
2.  Copy the command below into RStudio, `devtools::install_github("tractatus/wholebrain", args="--no-multiarch")`
3.	It will probably ask you this question, select `3. None`

## Test Wholebrain

1.	Quit RStudio and then launch it again, so that you are testing a usual future post-install session with Wholebrain. 
We can test using the same code the author provides in the original instructions: 

`library(wholebrain) `

`filename<-system.file('sample_tiles/rabiesEGFP.tif', package='wholebrain') `

`output<-segment(filename)`

2.	The most important is the first line: can you load the Wholebrain R library without any errors? If so it should be working! 
3.	The next two lines will load a file and plot results. Hit the "q" key to close the figures and get output, which should be a two element list. The output as of version 0.1.35 is: `OUTPUT SEGMENTED CELLS: 248 `

# SMART Installation

1. Close RStudio and open it again.
2. Enter the command `library(devtools)`
3. Enter the command `install_github("mjin1812/SMART")`
4. Enter the command to load SMART to make sure it works. `library(SMART)`
