# MS-MRI-Proj
# Validation and Optimization of Blood-Brain Barrier Disruption Prediction in Multiple Sclerosis using Contrast-free MRI.

# Overview

  Multiple sclerosis (MS) is the most common form of autoimmune disorder affecting the central nervous system. In MS patients, the human's immune system attacks and damages the myelin sheath of nerve cells in the brain and the spinal cord, disrupting the nerve impulses at the damaged sites which cause a wide range of disabling symptoms, physical, mental and psychiatric. Convential standard of MS diagnosis involves the employment of contrast-enhanced MRI using Gadolinium-containing agents which can be costly, requiring extra scanning time and potentially toxic. This projects aims to validate and optimize an existent method for MS prediction using contrast-free MRI [1]. MRI scans from 29 MS patients were used for prediction and validation. I contacted three Penn faculties: Dr. Salin Chahin, Dr. Taki Shinohara and Dr. Lyle Ungar about this project's approach and methodology. I identified and performed manual segmentations of enhancing lesions under Dr. Salim Chahin's guidance; Dr. Shinohara explained to me how he came up with his originial approach for lesion enhancement prediction and Dr. Ungar suggested the prediction models used for prediction and validation.

# List of scripts
Norm.R - Normalizing pre-registered images in R using White Stripe Normalization.

logRegwEval.m - Logistic Regression prediction of lesion enhancement without Scan-Stratified Case-Control Sampling, with ROC curves plotted for evaluation.

logRegwEvalwSSCC.m - Logistic Regression prediction of lesion enhancement with Scan-Stratified Case-Control Sampling, with ROC curves plotted for evaluation.

treeBaggerwEvalwSSCC.m - Ensemble of bagged decision tree prediction of lesion enhancement with Scan-Stratified Case-Control Sampling, with ROC curves plotted for evaluation.
