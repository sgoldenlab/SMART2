# SMART v1.1 (Semi-Manual Alignment to Reference Templates)

**Pre-print: [SMART: An open source extension of WholeBrain for iDISCO+ LSFM intact mouse brain registration and segmentation](https://www.biorxiv.org/content/10.1101/727529v1)**

## Mar-30-2021: SMART version 1.1 release

It's been a few years since the initial release of [SMART](https://github.com/mjin1812/SMART), and we have a few updates. First off, we've moved the repository from [Michelle's account](https://github.com/mjin1812/SMART) to here! We've also implemented some bug fixes and new features.

The first set of new features allows users to compile data from multiple SMART analyses. To do this, we've added three functions: `concatenate()`, `cell_count_compilation()`, and `get_groups()`. `concatenate()` merges multiple datasets (after forward warp) and saves them in a new .RData file, which can be used to output group cell counts. `cell_count_compilation` determines cell counts from a list of user-specified regions from multiple SMART analyses. For ease of downstream processing (i.e. statistical tests), regional cell counts are output into one .csv file. `get_groups()` uses this .csv file to calculate group mean and standard deviation values for every region.

The second set of new features enables users to conduct a voxel-based analysis (similar to other programs, like [ClearMap](http://christophkirst.github.io/ClearMap/build/html/index.html)). `voxelize()` generates a cell density map (saved as an .RData object, .csv file, and visual heatmap), and `voxel_stats()` runs statistical tests on these maps to determine group differences in cell density.

### New Features
- Bug fixes in registration loop, duplicate cleanup, and forward warp
- Function to count segmented cells before and after duplicate cleanup - `cell_counter()`
- Concatenation function to merge multiple datasets - `concatenate()`
- Function to compile cell counts from multiple datasets into one document - `cell_count_compilation()`
- Function to calculate group data from multiple datasets - `get_groups()`
- Voxelization function to allow users to run a voxel-based analysis, in addition to SMART's conventional region-based analysis, and generate cell density heatmaps - `voxelize()`
- Function to run statistical tests on voxelized datasets - `voxel_stats()`

## What is SMART?

Mapping immediate early gene (IEG) expression across intact brains is becoming a popular approach for identifying the brain-wide activity patterns underlying behavior. Registering whole brains to an anatomical atlas presents a technical challenge that has predominantly been tackled using automated voxel-based registration methods; however, these methods may fail when brains are damaged or only partially imaged, can be challenging to correct, and require substantial computational power. Here we present an open source package in R called SMART (semi-manual alignment to reference templates) as an extension to the WholeBrain framework for automated segmentation and semi-automated registration of experimental images to vectorized atlas plates from the Allen Brain Institute Mouse Common Coordinate Framework (CCF).

The SMART package was created with the novice programmer in mind and introduces a streamlined pipeline for aligning, registering, and segmenting large LSFM volumetric datasets with the CCF across the anterior-posterior axis, using a simple ‘choice game’ and interactive user-friendly menus. SMART further provides the flexibility to register partial brains or discrete user-chosen experimental images across the CCF, making it compatible with analysis of traditionally sectioned coronal brain slices. 

## Pipeline 👷
![](docs/schematics/pipeline_schematic.PNG)

## Installation ⚙️

- [Install SMART](docs/installation.md)

## Tutorial 📚
- [Introduction](docs/index.md) 🔨
- [Full Tutorial](docs/tutorial.md) 🏭

## Notes
- [Updates](docs/updates.md) 🧮
- [Caveats](docs/caveats.md) 🖥️
- [Development info](docs/development_info.md) 💾

## Resources 💾

### Wholebrain webpage
- [Wholebrain by Daniel Furth](https://www.wholebrainsoftware.org/) 🐭

### Open brain map
- [Interactive open brain map](https://www.openbrainmap.org/#2/7345/5135) 🗺️

### SMART example data and references
- [Access sample data here](docs/example_data.md) 📘

### Golden Lab webpage
- [Sam Golden Lab UW](https://goldenneurolab.com/) 🧪🧫🐁

## Contributors 🤼
- [Michelle Jin](https://github.com/mjin1812)
- [Joseph Nguyen](https://github.com/jdknguyen)
- Rajtarun Madangopal
