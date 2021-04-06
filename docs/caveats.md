# Caveats

### We have noted some parts of the base WholeBrain package that are currently works-in-progress:

1) The plates anterior to +4.84 and posterior to -4.77 are either not available or throw errors during registration. Users should set the first and last usable images to within this range for the pipeline to run correctly.
2) We have experienced issues in processing images where the coronal tissue is cut off by the boundaries of the image. In such cases, we recommend creating a boundary of just black image background around all four edges of the imaged tissue.
3) During the manual registration correction process, a manual edit of correspondence points may not seem to warp the atlas appropriately according to the new changes. We have found that adding, deleting, or changing the correspondence points can cause the warp to ‘snap-back’ to an appropriate position matching the correspondence points. This requires some trial and error.
4) Very high resolution image datasets (>10x) that are tiled cannot be processed during segmentation due to heavier computational segmentation requirements. If this is the case, we suggest using other segmentation algorithms, e.g. from Fiji ImageJ, to segment features of interest and create a binary mask of positive cell counts; then, users shoudl use the binarized images to feed into the SMART pipeline as the segmentation channel.

### Caveats to the SMART pipeline:
1) When running the `forward_warp()` function or `regi_loop()` function on autoloop, do not exit out of the current graphics window manually. This will interfere with saving the graphics that are generated and the function will need to be rerun from the beginning.
