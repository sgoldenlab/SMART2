# Updates

**Update 3-30-2021**
- Duplicate cleanup bug fix
- Forward warp bug fix
- Function to count segmented cells before and after duplicate cleanup - `cell_counter()`
- Concatenation function to merge multiple datasets - `concatenate()`
- Function to compile cell counts from multiple datasets into one document - `cell_count_compilation()`
- Function to calculate group data from multiple datasets - `get_groups()`
- Voxelization function to allow users to run a voxel-based analysis, in addition to SMART's conventional region-based analysis, and generate cell density heatmaps - `voxelize()`
- Function to run statistical tests on voxelized datasets - `voxel_stats()`

**Update 8-6-2019**
- Added link to SMART YouTube tutorials in the ‘Example data & references’ page. Go check it out!

**Update 7-23-2019**
- Uploaded a new standardized reference PDF in the example data page.
- New entry made in the Caveats page.

**Update 2-28-2019**
- Added the new data visualization function `get_table()`.

**Update 1-30-2019**
- Updated the visuals in the `brainmorph()` function and added more user plotting options.

**Patch & update 1-26-2019**
- In the `choice()` function, the atlas argument was added. atlas allows users to automatically pull up the appropriate atlas plates when the choice game is played.
- A bug was fixed in `registration2()` and `regi_loop()` where users accidentally enter no numbers during correspondence point modifications and R crashes.
