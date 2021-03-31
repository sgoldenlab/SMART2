# Installation of SMART:

**First install wholebrain**

If you are running on Linux or Mac OSX, the instructions to install wholebrain can be found [here](http://www.wholebrainsoftware.org/cms/install/).

If you are running windows, manual installation of opencv is no longer necessary. The most updated instructions for installation have been written (with additional modification from me) by Ben D. Singer. The instructions can be downloaded [here](https://osf.io/yejq3/).

Before using SMART, I highly recommend reading through the documentation for wholebrain before using this package. There are a number of tutorials on the wholebrain website that will give you a better idea of the capabilities of the base package.

If you are experiencing issues with installing wholebrain, please contact Daniel Furth, the creator of the package. We recommend posting issues on the Wholebrain Gitter Lobby ([link here](https://gitter.im/tractatus/Lobby)), a messaging chat room supporting users of wholebrain.

**Install SMART**

SMART is easily installed from github using the devtools package:
```diff
# Load devtools
library(devtools) 
 
# Install SMART
install_github("mjin1812/SMART")

# Load SMART
library(SMART)

# Pull up package descriptions and list of functions
?SMART
```

**Technical considerations and recommendations:**

1) SMART and wholebrain should be installed on a computer with at least 16 GB of RAM. 8GB of RAM may be too low and crash R for some of the pipeline processes.
2) The user-experience of this pipeline would be improved with a dual monitor setup, so that any graphics window popups may occur on one monitor, while the command-line interface is visible on the other.
