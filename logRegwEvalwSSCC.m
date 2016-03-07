%%
% This script performs evaluates logistic regression with scan-stratified case-control sampling on prediction made
% from T1 and T2 FLAIR images
clc
clear all

%%
% I. Load all subject images and segmentations. 
tic
addpath(genpath('F:\data\norm_MRI_MS\registerd_stripped'))
addpath(genpath('F:\enh_pred_data'))

subjwo = [1:4,6,7, 9:11, 13,14, 16:20,22, 39,  73];
segList = [5; 12; 23; 32; 40; 47; 55; 64; 66; 68; 72];
subjw   = segList;
% Load all images and segmentation. For each image, choose only the voxels
% in the top 1% of FLAIR intensity. Then store in cells
addpath(genpath('F:\data\norm_MRI_MS\registerd_stripped'))
addpath(genpath('F:\enh_pred_data'))
% subjw = [1:7, 9:23, 32, 39, 40, 47, 50, 55, 64, 66, 68, 72];
subjwo = [1:4,6,7, 9:11, 13,14, 16:20,22, 39,  73];
segList = [5; 12; 23; 32; 40; 47; 55; 64; 66; 68; 72];
subjw   = segList;
% Load all images and segmentation. For each image, choose only the voxels
% in the top x% of FLAIR intensity. Then store in cells

count = 0;
% For subjects w/o enhancing lesions
topRange = [0.05 ; 0.1 ; 0.2; 0.25]
for tR = 1 : length(topRange)
    for subjInd = 1 : length(subjwo)
        % Get normalized T1 and FLAIR images file name
        normT1 = sprintf('%03d_reg_Pre_brain.nii',subjwo(subjInd));
        normFlair = sprintf('%03d_norm_strip_Flair.nii',subjwo(subjInd));
        
        % Read NIfTI images
        [T1img, ~] = myReadNifti(normT1);
        [T2img, ~] = myReadNifti(normFlair);
        % choose the top 1% voxel from flair
        [voxelSortT2,I2] = sort(T2img(:));
        %     chosenInd2 = round(0.98 * length(voxelSortT2)) : length(voxelSortT2);
        chosenInd2 = round((1-topRange(tR)) * length(voxelSortT2)) : length(voxelSortT2);
        % Choose T1 and T2 voxels
        T1 = T1img(I2(chosenInd2));
        T2 = T2img(I2(chosenInd2));
        
        subjMRIwo{subjInd} = [T1(:) T2(:) zeros(length(T1(:)),1)];
        %     featureSet1(count*length(chosenInd2) +1 : (count+1)*length(chosenInd2), 1: 3) = [T1(:) T2(:) zeros(length(T1(:)),1)];
        %     count = count+1;
        
        clearvars -except subjwo segList subjw subjMRIwo topRange tR YY meanAUC
    end

    count = 0;
    % For subjects w/ enhancing lesions
    for subjInd = 1 : length(subjw)
        % Get normalized T1 and FLAIR images file name
        normT1 = sprintf('%03d_reg_Pre_brain.nii',subjw(subjInd));
        normFlair = sprintf('%03d_norm_strip_Flair.nii',subjw(subjInd));
        
        % Read NIfTI images
        [T1img, ~] = myReadNifti(normT1);
        [T2img, ~] = myReadNifti(normFlair);
        
        % choose the top voxels
        [voxelSortT2,I2] = sort(T2img(:));
        %     chosenInd2 = round(0.95 * length(voxelSortT2)) : length(voxelSortT2);
        chosenInd2 = round((1-topRange(tR)) * length(voxelSortT2)) : length(voxelSortT2);
        % Choose T1 and T2 voxels
        T1 = T1img(I2(chosenInd2));
        T2 = T2img(I2(chosenInd2));
        
        
        % Load segmentations
        segName = sprintf('seg%03d.nii', segList(subjInd));
        [segImg, ~] = myReadNifti(segName);
        % Find corresponding voxels from segmentation
        segVox = segImg(I2(chosenInd2));
        
        subjMRIw{subjInd} = [T1(:) T2(:) segVox(:)];
        %     featureSet2(count*length(chosenInd2) +1 : (count+1)*length(chosenInd2), 1: 3) = [T1(:) T2(:) zeros(length(T1(:)),1)];
        %     count = count+1;
        
        clearvars -except subjwo segList subjw subjMRIw subjMRIwo chosenInd2 topRange tR YY meanAUC
    end
count = 0;

    for subjInd = 1 : length(subjwo)
        % Get normalized T1 and FLAIR images file name
        normT1 = sprintf('%03d_reg_Pre_brain.nii',subjwo(subjInd));
        normFlair = sprintf('%03d_norm_strip_Flair.nii',subjwo(subjInd));
        
        % Read NIfTI images
        [T1img, ~] = myReadNifti(normT1);
        [T2img, ~] = myReadNifti(normFlair);
        % choose the top 1% voxel from flair
        [voxelSortT2,I2] = sort(T2img(:));
        %     chosenInd2 = round(0.98 * length(voxelSortT2)) : length(voxelSortT2);
        chosenInd2 = round((1-topRange(tR)) * length(voxelSortT2)) : length(voxelSortT2);
        % Choose T1 and T2 voxels
        T1 = T1img(I2(chosenInd2));
        T2 = T2img(I2(chosenInd2));
        
        subjMRIwo{subjInd} = [T1(:) T2(:) zeros(length(T1(:)),1)];
        %     featureSet1(count*length(chosenInd2) +1 : (count+1)*length(chosenInd2), 1: 3) = [T1(:) T2(:) zeros(length(T1(:)),1)];
        %     count = count+1;
        
        clearvars -except subjwo segList subjw subjMRIwo topRange tR YY meanAUC
    end
    % save('SubjWOLesions.mat','subjMRIwo')
    count = 0;
    % For subjects w/ enhancing lesions
    for subjInd = 1 : length(subjw)
        % Get normalized T1 and FLAIR images file name
        normT1 = sprintf('%03d_reg_Pre_brain.nii',subjw(subjInd));
        normFlair = sprintf('%03d_norm_strip_Flair.nii',subjwo(subjInd));
        
        % Read NIfTI images
        [T1img, ~] = myReadNifti(normT1);
        [T2img, ~] = myReadNifti(normFlair);
        
        % choose the top voxels
        [voxelSortT2,I2] = sort(T2img(:));
        %     chosenInd2 = round(0.95 * length(voxelSortT2)) : length(voxelSortT2);
        chosenInd2 = round((1-topRange(tR)) * length(voxelSortT2)) : length(voxelSortT2);
        % Choose T1 and T2 voxels
        T1 = T1img(I2(chosenInd2));
        T2 = T2img(I2(chosenInd2));
        
        
        % Load segmentations
        segName = sprintf('seg%03d.nii', segList(subjInd));
        [segImg, ~] = myReadNifti(segName);
        % Find corresponding voxels from segmentation
        segVox = segImg(I2(chosenInd2));
        
        subjMRIw{subjInd} = [T1(:) T2(:) segVox(:)];
        %     featureSet2(count*length(chosenInd2) +1 : (count+1)*length(chosenInd2), 1: 3) = [T1(:) T2(:) zeros(length(T1(:)),1)];
        %     count = count+1;
        
        clearvars -except subjwo segList subjw subjMRIw subjMRIwo chosenInd2 topRange tR YY meanAUC
    end
    % save('SubjWLesions.mat','subjMRIw')
    
    %%
    % II. Create training set and testing set and perform logistic regression
    % Perform logistic regression 10 times. There are a total of 29 subjects,
    % 11 w enhancing lesions and 18 w/o enhancing lesions. For each regression,
    % the training set will be 10 subj, with 5 subjects w enhancing lesions and
    % 5 w/o, chosen randomly. The validation test will also be 10; again 5 with
    % and 5 w/o.
    sp = linspace(0,1,1e5);
    yVal = zeros(1,1e5);
    for i = 1 : 10
        % Randomly permute 10 of the subjects w/ and w/o enhancing lesions
        randSubjWInd = randperm(length(subjMRIw),10);
        randSubjWOInd = randperm(length(subjMRIwo),10);
        
        % Use the first 5 for train and the next 5 for teting
        trainSubjWInd = randSubjWInd(1:5);
        testSubjWInd  = randSubjWInd(6:10);
        
        trainSubjWOInd = randSubjWOInd(1:5);
        testSubjWOInd  = randSubjWOInd(6:10);
     
        % Feature set will have 3 columns. First and second columns are from
        % the subject's T1 and T2 intensity value; the 3rd column is the
        % multiplication of the two.
        
        %% Training
        
        %% NOTE: APPLY SSCC ON TRAINING TO CREATE NEW TRAINING MODEL 
        % Procedure: 1/ Find the number of enhancing lesions per subj
        %            2/ Find the avg # of enhancing lesions for 5 subj
        %            3/ For each subj w enhancing lesions take a random
        %            sample size of non-enhancing lesions that's 5x the
        %            number of enhancing lesions
        %            4/ For each subj w/o enhancing lesions take a random
        %            sample size thats 5x the avg number found in step 2
        
        trainFeat = zeros(length(chosenInd2) * 10, 4);
        trainLabel = zeros(length(chosenInd2) * 10,1);
        count = 0;
        totEnhVox = 0;
        for j = 1 : 5
            % Get the subj data
            subjWData = cell2mat(subjMRIw(trainSubjWInd(j)));
            % Find the number of enhancing lesions, get their indexes and add it to
            % totEnhLesVox
            enhVoxId = find(subjWData(:,3));
            numEnhVox = length(enhVoxId);
            totEnhVox = totEnhVox + numEnhVox;
            % Get the indexes of non-enhancing voxels
            totNumVoxInd = [1:length(subjWData(:,1))];
            totNumVoxInd(enhVoxId) = [];
            % Take a random sample size 5x the number of enhancing voxels
            % and store it in trainW
                       
            % Randomly permute 5x the number of enhancing voxels
            sampInd = randperm(length(totNumVoxInd), 5 * numEnhVox);
            samp = totNumVoxInd(sampInd);
            % Combine the sample of non-enhancing and enhancing voxel into
            % an index vector and randpomly rearrang it 
            samp = [samp'; enhVoxId];
            samp = samp(randperm(length(samp)));
            
            % Get the voxel intensity values and store it into trainW             
            col1 = subjWData(samp,1); col2 = subjWData(samp,2); col3 = col1 .* col2;
            trainW(count*length(col1) +1 : (count+1)*length(col2), 1: 4) = [col1 col2 col3 subjWData(samp,3)];
            count = count+1;
        end
        avgEnhVox = round(totEnhVox/5);
        
        count = 0;
        
        % For each subj without enhancing lesions, take a random sample of
        % size 5x the avgEnhVox
        for k = 1 : 5
            subjWOData = cell2mat(subjMRIwo(trainSubjWOInd(k)));
            sampInd = randperm(length(subjWOData(:,1)), 5 * avgEnhVox);
            col1 = subjWOData(sampInd,1); col2 = subjWOData(sampInd,2); col3 = col1 .* col2;
            trainWO(count*length(col1) +1 : (count+1)*length(col2), 1: 4) = [col1 col2 col3 subjWOData(sampInd,3)];
            count = count+1;
        end
        
        train = [trainW; trainWO];
        % Randomly rearrange row in train array
        n = length(train);
        order = randperm(n);
        train = train(order, :);
        
        
        
        
        
        % Training logit model
        model = glmfit(train(:,1:3),train(:,4),'binomial','link','logit');
        clear train ; clear trainFeat; clear trainLabel; clear trainW; clear trainWO;
        
        %% Testing
        testFeat = zeros(length(chosenInd2) * 10, 4);
        testLabel = zeros(length(chosenInd2) * 10,1);
        count = 0;
        for j = 1 : 5
            subjWData = cell2mat(subjMRIw(testSubjWInd(j)));
            col1 = subjWData(:,1); col2 = subjWData(:,2);col3 = col1 .* col2;
            testW(count*length(col1) +1 : (count+1)*length(col2), 1: 4) = [col1 col2 col3 subjWData(:,3)];
            count = count+1;
        end
        
        count = 0;
        for k = 1 : 5
            subjWOData = cell2mat(subjMRIwo(testSubjWOInd(k)));
            col1 = subjWOData(:,1); col2 = subjWOData(:,2);col3 = col1 .* col2;
            testWO(count*length(col1) +1 : (count+1)*length(col2), 1: 4) = [col1 col2 col3 subjWOData(:,3)];
            count = count+1;
        end
        
        test = [testW; testWO];
        % Randomly rearrange row in train array
        n = length(test);
        order = randperm(n);
        test = test(order,:);
        
        pihat = glmval(model, test(:,1:3),'logit');
        
        [x,y,T,AUC(i)] = perfcurve(test(:,4),pihat, 1);
        
        [uniqX, ind] = unique(x);
        Y = spline(uniqX, y(ind), sp);
        yVal = yVal + Y;
        
        clear test testFeat testLabel testW testWO x  y uniqx
    end
    YY{tR} = yVal./10;
    meanAUC(tR) = mean(AUC);
    toc

end 
figure
hold on
plot(sp, cell2mat(YY(1)), 'k')
plot(sp, cell2mat(YY(2)), 'r')
plot(sp, cell2mat(YY(3)), 'g')
plot(sp, cell2mat(YY(4)), 'b')
xlabel('False Positive Rate')
ylabel('True Positive Rate')
title('Mean ROC curve')
ylim([0 1])
legend('Top 5%', 'Top 10%', 'Top 20%', 'Top 25')
