This script is used to run GALFIT for a set of images. Script is set to fit galaxy bulge and disk components to object in the center of each image. So this script requires IDL and GALFIT installations to work.

The IDL script has a variable 'cluster' which is set to correct cluster name. The script needs the path of the file with a list of input image names. 

At the first step, the script reads the names of the input images from a list. Second step is to print GALFIT input parameters to a file for the first image of the list. After this, the script runs GALFIT and tests if the GALFIT output file is created. These steps are repeated until all images have been fitted. At the end of the script, the output files are created.

More information: http://urn.fi/URN:NBN:fi:hulib-201801241099

GALFIT: https://users.obs.carnegiescience.edu/peng/work/galfit/galfit.html