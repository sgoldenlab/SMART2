# Example Data and References

## Raw image dataset

Our compressed raw example image dataset is provided online courtesy of The Open Science Framework, a free online project management repository. It is easily extractable using 7-Zip, an open-source file archiver.

### [Download raw dataset!](https://osf.io/y9uax/)

**Extraction directions:**
1) Download the 7-Zip free archiving software.
2) Due to storage limitations, we split data from each channel into two compressed files. The file extensions ending ‘7z.001’ and ‘7z.002’ belong to the same channel. “C01” indicates the segmentation channel files while “C02” indicated autofluoresence channel files.
3) Download both 7-Zip files belonging to the segmentation channel from the repository. Highlight both files in the downloads folder and select ‘extract files’ using 7-Zip. Set the extraction to your preferred folder and click ‘Okay.’
4) Repeat step 3 for the autofluorescence channel.

## User reference atlases
In the same repository, we provide a standardazed PDF atlas that includes all the plates in the WholeBrain package that are legal to register. Plates that exist in the Allen Mouse Common Coordinate Framework that are not provided in the atlas will generate errors (see Caveats page). Below each plate we provide the interpolated Anterior-Posterior coordinate used in the WholeBrain framework, as well as the plate number

### [Download standardized atlas!](https://osf.io/cpt5w/)

For additional reference, we also include a custom generated atlas in a pptx file that contains coronal sections from a cleared and imaged mouse brain that we qualitatively aligned to atlas plates from WholeBrain.

### [Download custom atlas!](https://osf.io/kafq3/)

## Interactive web applet

Check out our interactive data visualization environment written with RShiny showcasing the output generated from this example dataset.

### [Web applet](https://smartrpackage.shinyapps.io/smart_sample_dataset/)

## YouTube tutorial walkthrough

Check out our YouTube tutorial with the example dataset!

### [YouTube tutorial](https://www.youtube.com/watch?v=9ifnjeESgvg&feature=youtu.be)
