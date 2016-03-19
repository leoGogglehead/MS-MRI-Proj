# MS-MRI-Proj
# Validation and Optimization of Blood-Brain Barrier Disruption Prediction in Multiple Sclerosis using Contrast-free MRI.

# Overview

  Multiple sclerosis (MS) is the most common form of autoimmune disorder affecting the central nervous system. In MS patients, the human's immune system attacks and damages the myelin sheath of nerve cells in the brain and the spinal cord, disrupting the nerve impulses at the damaged sites which cause a wide range of disabling symptoms, physical, mental and psychiatric. Convential standard of MS diagnosis involves the employment of contrast-enhanced MRI using Gadolinium-containing agents which can be costly, requiring extra scanning time and potentially toxic. This projects aims to validate and optimize an existent method for MS prediction using contrast-free MRI [7]. MRI scans from 29 MS patients were used for prediction and validation. 


# List of scripts
Norm.R - Normalizing pre-registered images in R using White Stripe Normalization.

logRegwEval.m - Logistic Regression prediction of lesion enhancement without Scan-Stratified Case-Control Sampling, with ROC curves plotted for evaluation.

logRegwEvalwSSCC.m - Logistic Regression prediction of lesion enhancement with Scan-Stratified Case-Control Sampling, with ROC curves plotted for evaluation.

treeBaggerwEvalwSSCC.m - Ensemble of bagged decision tree prediction of lesion enhancement with Scan-Stratified Case-Control Sampling, with ROC curves plotted for evaluation.

# References

[1] Carlos E Araya and Vikas R Dharnidharka. Use of contrast agents in children with chronic kidney disease. In Pediatric Dialysis, pages 629–642. Springer, 2012.

[2] US Food, Drug Administration, et al. Fda drug safety communication: New warnings for using gadolinium-based contrast agents in patients with kidney dysfunction, 2010.

[3] Henry F McFarland, Joseph A Frank, Paul S Albert, Mary E Smith, Roland Martin, Jonathan O Harris, Nicholas Patronas, Heidi Maloni, and Dale E McFarlin. Using gadolinium-enhanced magnetic resonance imaging lesions to monitor disease activity in multiple sclerosis. Annals of neurology, 32(6):758–766, 1992.

[4] Beatrice Nardone, Elise Saddleton, Anne E Laumann, Beatrice J Edwards, Dennis W Raisch, June M McKoy, Steven M Belknap, Christian Bull, Anand Haryani, Shawn E Cowper, et al. Pediatric nephrogenic systemic ﬁbrosis is rarely reported: a radar report. Pediatric radiology, 44(2):173–180, 2014.

[5] Chris H Polman, Stephen C Reingold, Brenda Banwell, Michel Clanet, Jeffrey A Cohen, Massimo Filippi, Kazuo Fujihara, Eva Havrdova, Michael Hutchinson, Ludwig Kappos, et al. Diagnostic criteria for multiple sclerosis: 2010 revisions to the mcdonald criteria. Annals of neurology, 69(2):292–302, 2011.

[6] Gina-Maria Pomann, Elizabeth M Sweeney, Daniel S Reich, Ana-Maria Staicu, and Russell T Shinohara. Scan-stratiﬁed case-control sampling for modeling blood–brain barrier integrity in multiple sclerosis. Statistics in medicine, 2015.

[7] RT Shinohara, J Goldsmith, FJ Mateen, C Crainiceanu, and DS Reich. Predicting breakdown of the blood-brain barrier in multiple sclerosis without contrast agents. American Journal of Neuroradiology, 33(8):1586–1590, 2012.

[8] Russell T Shinohara, Elizabeth M Sweeney, Jeff Goldsmith, Navid Shiee, Farrah J Mateen, Peter A Calabresi, Samson Jarso, Dzung L Pham, Daniel S Reich, Ciprian M Crainiceanu, et al. Statistical normalization techniques for magnetic resonance imaging. NeuroImage: Clinical, 6:9–19, 2014.

[9] Francine Wein and Leonard A Levin. Comi g, ﬁlippi m, barkhof f, et al. effect of early interferon treatment on conversion to deﬁnite multiple sclerosis: a randomised study. Journal of Neuro-Ophthalmology, 22(1):65, 2002.
