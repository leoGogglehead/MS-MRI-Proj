# MS-MRI-Proj

#Title: Validation and Optimization of Blood-Brain Barrier Disruption Prediction in Multiple Sclerosis using Contrast-free MRI

# Overview

  Multiple sclerosis (MS) is the most common form of autoimmune disorder affecting the central nervous system. In MS patients, the human's immune system attacks and damages the myelin sheath of nerve cells in the brain and the spinal cord, disrupting the nerve impulses at the damaged sites which cause a wide range of disabling symptoms, physical, mental and psychiatric. Convential standard of MS diagnosis involves the employment of contrast-enhanced MRI using Gadolinium-containing agents which can be costly, requiring extra scanning time and potentially toxic. This projects aims to validate and optimize an existent method for MS prediction using contrast-free MRI [1]. MRI scans from 29 MS patients were used for prediction and validation. I contacted three Penn faculties: Dr. Salin Chahin, Dr. Taki Shinohara and Dr. Lyle Ungar about this project's approach and methodology. I identified and performed manual segmentations of enhancing lesions under Dr. Salim Chahin's guidance; Dr. Shinohara explained to me how he came up with his originial approach for lesion enhancement prediction and Dr. Ungar suggested the prediction models used for prediction and validation.
  
  # I/ Introduction 

  Multiple sclerosis (MS) is an inflammatory demyelinating disease which involves lesion formations in the central nervous system. MS can be diagnosed with magnetic resonance imaging (MRI) using the contrast agent gadolinium which highlights leakages in blood-brain barrier (BBB). However, gadolinium poses certain risks to patients beside increasing medical expense, such as being a potential carcinogen. This project aims to evaluate an existed contrast-agent-free prediction algorithm of BBB breakdown, as described by R.T.Shinohara and collaborators in "Predicting Breakdown of the Blood-Brain Barrier in Multiple Sclerosis without Contrast Agents" . A logistic regression model is applied on candidate voxels in T1-, T2- and T2-weighted FLAIR MRI images and predictions are made based on the resulted area under curve (AUC). In addition, this project intends to explore different parameters of the aforementioned method and other prediction algorithms in order to improve prediction rate.

  This study is interdisciplinary as it involves working with biomedical image analysis, machine learning and data science. A basic understanding of MRI image modalities is required for normalization and registration of MRI images. Prediction of lesion formation demands training of machine learning classification algorithm(s) on processed training data. From my meetings with Dr. Shinohara and a collaborator of his, Dr. Salim Chahin, I've learnt how to apply WhiteStripe normalization and case-control sampling on segmented MRI images in addition to understanding the basics of lesion progression and identification. I was informed by Dr. Lyle Ungar that for many biomedical classification studies, logistic regression and artficial neural networks are the algorithms of choice.

# II/ Materials and Methods

## 1/ Study population
  87 MRI scans of 29 patients with MS were obtained under the University of Pennsylvania's institutional review board- approved protocol. All 29 patients had MS, of which 11 had enhancing and 18 didn't. Each patient might have more than 1 visit for MRI scans, but for this study we used only scans from the most recent visit. All patients were de-indentified with the program MIPAV and were receiving treatments for MS. 3 MRI scans were used per patient: pre-contrast T1-weighted magnetization-prepared 180 degrees radio-frequency pulses and rapid gradient-echo sample (T1 MP RAGE); T2-weighted fluid-attenuated inversion-recovery (T2 FLAIR); and post-contrast T1 MP RAGE. Pre-contrast T1 and T2 FLAIR would be employed as predictors.
  
## 2/ Manual segmentation
  For prediction validation, manual segmentation of enhancing voxels was conducted under supervision by a neuroradiologist (Dr. Salim Chahin) with more than 7 years of experience in MS- MRI analysis. Firstly, using MIPAV, each subject's post-contrast T1 image was registered to the corresponding T2 FLAIR image, with rigid-6 setting. Then ITK-SNAP (version 3.4.0-rc1) was employed for manual segmentation to create a mask of enhancing lesion voxel locations. Segmentations were performed on each patient individually via comparing hyperintense voxels in T2 FLAIR and post-contrast T1. Labels were created using paintbrush tool on ITK-SNAP.
  
## 3/ MRI Processing:

### a) Skull-stripping
  In MRI images, especially in T2 FLAIR images, skull,eye and skin tissues might appear hyperintense, similar to enhancing lesions. To counter this problem, skull stripping was conducted to remove as much non-brain areas in pre-contrast T1 and T2 FLAIR as possible, leaving the two hemispheres and some parts of the brain stem intact, using FSL BET (Brain Extraction Tool). 
  
### b) Registration
  Registration, or alignment of images, is an important stage of image processing, especially with 3-D images such as MRI. Pre-contrast T1 MP RAGE images were registered to corresponding T2 FLAIR images as candidate voxels would firstly be chosen from T2 FLAIR, using FSL FLIRT with rigid body with 6 degrees of freedom setting.
  
### c) Normalization
  As MRI scans were all acquired in arbitrary units for voxel intensity, it was crucial that normalization was applied. For this study, pre-contrast T1 and T2 FLAIR were normalized in R with package WhiteStripe using the script Norm. WhiteStripe used normal appearing white matter (NAWM) as the reference tissue as the white matter is the most contiguous tissue and therefore least confounded by partial volume averaging. WhiteStripe works by firstly creating an intensty histogram of the image that needed to be normalized, then the highest non-background peak (the mode) was estimated. Subsequently, the standard deviation of the intensity histogram would be matched to the aforementioned peak. Note in this case the date type and number of bits per pixel had to be set after normalization of each image, otherwise there would be distortion of images. 
  ```{r eval = FALSE} 
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
  t1 <- readNIfTI(preContrast, reorient = FALSE)  # Read NIfTI image
  t1.whitestripe <- whitestripe(t1, "T1")         # Get the white matter indexes/ mode of the intensity histogram
  t1.ind <- t1.whitestripe$whitestripe.ind        # Get the indexes of voxels whose intensity values need to change
  t1.norm <- whitestripe_norm(t1, t1.ind)         # Do normalization on the voxels need to change and return img
  datatype(t1.norm) <- 16                         # Set data type to unsigned 16
  bitpix(t1.norm) <- 32                           # Set the number of bits per pixel to 32
  
  t2Flair <- readNIfTI(flair, reorient = FALSE)
  t2.whitestripe <- whitestripe(t2Flair, "T2")
  t2.ind <- t2.whitestripe$whitestripe.ind
  t2.norm <- whitestripe_norm(t2Flair, t2.ind)
  datatype(t2.norm) <- 16
  bitpix(t2.norm) <- 32
  
  writeNIfTI(t1.norm, normT1, gzipped = FALSE, verbose = TRUE )
  writeNIfTI(t2.norm, normFlair, gzipped = FALSE,  verbose = TRUE)
}
```
## 4/ Enhancement Prediction and Validation
  Voxels whose intensity values in the top 5, 10, 20 and 25% in FLAIR images were chosen as candiadate voxels, respectively as we wanted to compare the prediction accuracy over a varied range of candidate voxels. Their corresponding intensity values in pre-contrast T1 was obtained. A confounding variable of T1 and T2 was created by multiplying each T2 voxel intensity value with its pre-contrast T1 value. A logistic regression was applied on each voxel, using pre-contrast T1, T2 and confounding variable value, to predict its probability of enhancing.
  For prediction assessment, we nonparametrically bootstrapped (without replacement) the training and testing set 10 times. For each set, a total of 10 randomly chosen subjects were used, 5 with enhancing lesions and 5 without. All voxels in each set was concatenated vertically into an n x 4 array (the last column being the label) before randomly permuted. This allowed for estimation of an average ROC curve and the mean AUC score over 10 validations was calculated. Prediction and validation were done with the MATLAB script logRegwEval.
  
# III/ Results


## 1/ ROC curve performance across the range of top voxels chosen

![meanROC](meanROC.png)
Figure 1. Comparison of ROC curves across different numbers of voxels used for classification

## 2/ Mean AUC scores 
```{r table1, results = "asis", echo=FALSE}
library(stargazer)
col1 <- c(5, 10, 20, 25)
col2 <- c(0.4929,0.5328,0.6856,0.771)
mat1 <- matrix(cbind(col1,col2), nrow = 4)
colnames(mat1) <- c("Percentage of top voxels  ", '  Mean AUC')
stargazer(mat1, type = "html")

```
Figure 2. Comparison of mean AUC score across different numberso of voxels used for classification

As shown in figure 1 and 2, using voxels in the top 5-10% intensity range in FLAIR images for prediction produced predictions that were as good as random predictions without a priori knowledge; however, when the number of voxels used increased to the top 20-25% we observed an increase in prediction accuracy. 

# IV/ Discussion

## 1/ Skull - stripping and normalization
  Upon closer inspection, we discoverd that even after skull-stripping and normalization, certain parts  of the MRI such as the upper part of the spinal cord appears hyperintense in FLAIR images. Voxels corresponding to said parts would be among the firsts to be included as candidate voxels for prediction. In addition, we noticed that WhiteStripe normalization performed well per each slice of the brain but not very well for the entire brain as a 3-D when viewing under ITK-SNAP; this resulted in wildly different values for neighboring voxels that should have similar intensities. Better skull-stripping techniques and optimization of WhiteStripe normalization need to be investigated. 
  
  ![snapshot0001](snapshot0001.png)
  
## 2/ Prediction model and data sampling

  This project has not taken into account that MS is a chronic disorder. It is a fact that new or enlarging MS lesions are more prone to enhance than old, inactive lesions. The SuBLIME method proposed by Sweeney et al. [3] utilized subtration images between various studies could be employed together with this project's logistic regression model to potentially increase prediction accuracy.  Furthermore, considering that lesion enhancement is a very rare event as for each patient, the number of enhancing lesions accounted for less than 1% of the total number of voxels, there is a need for better data sampling for model training. Scan-stratified case-control sampling (SSCC) technique [2] could be used to create better training data set with proportianal number of enhancing and non-enhancing lesions; however, this method could not be employed untill better skull-stripping and normalization are conducted.  Finally, different classification algorithms such as random forest and feedforward neural network will be used for performance comparison.
  
# V/ Conclusion
  
  This project has demonstrated that lesion enhancement in relapse-remitting multiple sclerosis could be predicted without using contrast-enhancing MRI. With further optimization we believe that we could produce a much better lesion enhancement prediction methodology that would be more accurate and computationally efficient.
  

# VI/ References

[1] Carlos E Araya and Vikas R Dharnidharka. Use of contrast agents in children with chronic kidney disease. In Pediatric Dialysis, pages 629–642. Springer, 2012.
[2] US Food, Drug Administration, et al. Fda drug safety communication: New warnings for using gadolinium-based contrast agents in patients with kidney dysfunction, 2010.
[3] Henry F McFarland, Joseph A Frank, Paul S Albert, Mary E Smith, Roland Martin, Jonathan O Harris, Nicholas Patronas, Heidi Maloni, and Dale E McFarlin. Using gadolinium-enhanced magnetic resonance imaging lesions to monitor disease activity in multiple sclerosis. Annals of neurology, 32(6):758–766, 1992.
[4] Beatrice Nardone, Elise Saddleton, Anne E Laumann, Beatrice J Edwards, Dennis W Raisch, June M McKoy, Steven M Belknap, Christian Bull, Anand Haryani, Shawn E Cowper, et al. Pediatric nephrogenic systemic ﬁbrosis is rarely reported: a radar report. Pediatric radiology, 44(2):173–180, 2014.
[5] Chris H Polman, Stephen C Reingold, Brenda Banwell, Michel Clanet, Jeffrey A Cohen, Massimo Filippi, Kazuo Fujihara, Eva Havrdova, Michael Hutchinson, Ludwig Kappos, et al. Diagnostic criteria for multiple sclerosis: 2010 revisions to the mcdonald criteria. Annals of neurology, 69(2):292–302, 2011.
[6] Gina-Maria Pomann, Elizabeth M Sweeney, Daniel S Reich, Ana-Maria Staicu, and Russell T Shinohara. Scan-stratiﬁed case-control sampling for modeling blood–brain barrier integrity in multiple sclerosis. Statistics in medicine, 2015.
[7] RT Shinohara, J Goldsmith, FJ Mateen, C Crainiceanu, and DS Reich. Predicting breakdown of the blood-brain barrier in multiple sclerosis without contrast agents. American Journal of Neuroradiology, 33(8):1586–1590, 2012.
[8] Russell T Shinohara, Elizabeth M Sweeney, Jeff Goldsmith, Navid Shiee, Farrah J Mateen, Peter A Calabresi, Samson Jarso, Dzung L Pham, Daniel S Reich, Ciprian M Crainiceanu, et al. Statistical normalization techniques for magnetic resonance imaging. NeuroImage: Clinical, 6:9–19, 2014.
[9] Francine Wein and Leonard A Levin. Comi g, ﬁlippi m, barkhof f, et al. effect of early interferon treatment on conversion to deﬁnite multiple sclerosis: a randomised study. Journal of Neuro-Ophthalmology, 22(1):65, 2002.
