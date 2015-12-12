library(oro.nifti)
library(WhiteStripe)

# Set working directory
setwd("F:/data/MS-nifti")

# Create a vector containing subject number
subjNum <- c(1:7,9:23, 32, 39, 40, 47, 50, 55, 64, 66, 68, 72, 73)

# Use for loop for normalizing and saving images 
for (i in subjNum){
  
  # Print file names
  preContrast <- sprintf('%03d_Pre.nii',i)
  flair <- sprintf('%03d_Flair.nii',i)
  #postContrast <- sprintf('%03d_Post.nii',i)
  
  normT1 <- sprintf('F:/data/norm_MRI_MS/%03d_norm_Pre',i)
  normFlair <- sprintf('F:/data/norm_MRI_MS/%03d_norm_Flair',i)
  
  # Normalizing pre-contrast and flair images
  t1 <- readNIfTI(preContrast, reorient = FALSE)
  t1.whitestripe <- whitestripe(t1, "T1")
  t1.ind <- t1.whitestripe$whitestripe.ind
  t1.norm <- whitestripe_norm(t1, t1.ind)
  datatype(t1.norm) <- 16
  bitpix(t1.norm) <- 32
  
  t2Flair <- readNIfTI(flair, reorient = FALSE)
  t2.whitestripe <- whitestripe(t2Flair, "T2")
  t2.ind <- t2.whitestripe$whitestripe.ind
  t2.norm <- whitestripe_norm(t2Flair, t2.ind)
  datatype(t2.norm) <- 16
  bitpix(t2.norm) <- 32
  
  writeNIfTI(t1.norm, normT1, gzipped = FALSE, verbose = TRUE )
  writeNIfTI(t2.norm, normFlair, gzipped = FALSE,  verbose = TRUE)
}
