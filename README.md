# MS-MRI-Proj

Title: Validation and Optimization of Blood-Brain Barrier Disruption Prediction in Multiple Sclerosis in contrast-free MRI

Multiple sclerosis (MS) is an inflammatory demyelinating disease which involves lesion formations in the central nervous system. MS can be diagnosed with magnetic resonance imaging (MRI) using the contrast agent gadolinium which highlights leakages in blood-brain barrier (BBB). However, gadolinium poses certain risks to patients beside increasing medical expense, such as being a potential carcinogen. This project aims to evaluate an existed contrast-agent-free prediction algorithm of BBB breakdown, as described by R.T.Shinohara and collaborators in “Predicting Breakdown of the Blood-Brain Barrier in Multiple Sclerosis without Contrast Agents” . A logistic regression model is applied on candidate voxels in T1-, T2- and T2-weighted FLAIR MRI images and predictions are made based on the resulted area under curve (AUC). In addition, this project intends to explore different parameters of the aforementioned method and other prediction algorithms in order to improve prediction rate.

This study is interdisciplinary as it involves working with biomedical image analysis, machine learning and data science. A basic understanding of MRI image modalities is required for normalization and registration of MRI images. Prediction of lesion formation demands training of machine learning classification algorithm(s) on processed training data. From my meetings with Dr. Shinohara and a collaborator of his, Dr. Salim Chahin, I’ve learnt how to apply WhiteStripe normalization and case-control sampling on segmented MRI images in addition to understanding the basics of lesion progression and identification.

II. Method
MRI images were obtained from 30 subjects (14 of which has enhancing lesions), including T1 pre-contrast MPRAGE, T2 FLAIR and T1 post-contrast MPRAGE. Segmentations are conducted on T1 pre- and post-contrast images to provide 'true' results. WhiteStripe normalization is applied on T1 pre-contrast and T2 FLAIR images to reduce intensity differences among all subjects. A T1- and T2- hybridized mask will be created for each subject. 30 subjects will then be divided into two groups equal in size and number of patients with ehnancing lesions; the first group will be used as the training group and the second as the testing group. For each subject's mask image, voxels with intensity in the top 5% will be excluded. Training is applied on the next 1% voxels. A previously described logistic regression enhancement model will be trained on the training group and validated on the others. Next, other machine learning models such as random forest and feedforward artificial neural nets will be trained and test in a similar manner to compare prediction results.

III. Results
1/ Logistic regression enhance model result

2/ Random forest prediction result

3/ Artificial neural net result
