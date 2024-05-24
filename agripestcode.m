clc;
clear all;
close all;
warning off;
addpath('subcodes');
%% INITIALIZATION
x0=10;
y0=10;
width=1000;
height=500;

%% LOAD INPUT DATA
infolder = 'F:\Nisha\Nisha\2024\Rooks projcts\project6((pest2)\pest2code\agripestcode\test';    
imgFiles = dir([infolder,filesep,'im' ,num2str(i),'.jpg']) ; 
N = length(imgFiles) ;   
for i = 1:N
    thisFile = [infolder,filesep,imgFiles(i).name] ;    
    [filepath,name,ext] = fileparts(thisFile) ;  
    I = imread(thisFile) ;   
end

[I,path]=uigetfile('*.jpg','select a input image');
str=strcat(path,I);
s=imread(str);
figure;
sgtitle('Input Image');
subplot(121);
imshow(s);                                                                                                                                                                                                                                                                                                     
title('Input Image in RGB ');

%% PREPROCESSING - Median Absolute Deviation (MAD) Filter
% Convert the RGB image to double
s_double = im2double(s);

% Reshape the RGB image into a 2D array
s_reshaped = reshape(s_double, [], 3);

% Call MAD_filter function to preprocess the image
mad_threshold = 3; % Adjust this threshold as needed
s_filtered_reshaped = MAD_filter(s_reshaped, mad_threshold);

% Reshape the filtered image back to its original dimensions
s_filtered = reshape(s_filtered_reshaped, size(s_double));

% Display the preprocessed image after MAD filtering
figure; 
imshow(s_filtered);
title('Preprocessed Image with MAD Filter');
%% Perform histogram equalization on each channel separately
% Separate color channels
R = s_filtered(:,:,1);
G = s_filtered(:,:,2);
B = s_filtered(:,:,3);

% Perform contrast enhancement on each channel
R_clahe = adapthisteq(R);
G_clahe = adapthisteq(G);
B_clahe = adapthisteq(B);

% Combine the enhanced channels back into a color image
s_clahe = cat(3, R_clahe, G_clahe, B_clahe);

% Display the CLAHE-enhanced color image
figure;
imshow(s_clahe);
title('CLAHE-enhanced Color Image');
%%
% Convert the enhanced image to grayscale
s_gray = rgb2gray(s_clahe);

% Segment the leaf based on color thresholding
leaf_mask = s_gray > graythresh(s_gray);

% Perform morphological operations to enhance the leaf mask
leaf_mask = imclose(leaf_mask, strel('disk', 10)); % Close small gaps in the mask
leaf_mask = imfill(leaf_mask, 'holes'); % Fill holes in the mask

% Perform texture-based segmentation to separate disease areas
% Example: You can use texture analysis functions like entropyfilt, stdfilt, or GLCM features

% Apply the leaf mask to the original image to extract the leaf
leaf_image = bsxfun(@times, s_clahe, cast(leaf_mask, class(s_clahe)));

% Display the segmented leaf image
figure;
imshow(leaf_image);
title('Segmented Leaf Image');
%% Perform texture-based segmentation
disease_mask = texture_segmentation(s_clahe);

% Apply the disease mask to the segmented leaf image to extract diseased regions
disease_regions = bsxfun(@times, s_clahe, cast(disease_mask, class(s_clahe)));

% Display the segmented disease regions
figure;
imshow(disease_regions);
title('Segmented Disease Regions');

%% Further processing to remove noise and refine the segmentation
% Example: You can apply additional morphological operations, filtering, or machine learning techniques

% Perform disease detection and analysis on the segmented regions
% Example: You can use classification algorithms or image processing techniques to detect and analyze diseases on the leaf

% Continue with further analysis or processing as needed

%%
% Perform K-means clustering on the CLAHE-enhanced color image
k = 5; % Number of clusters (adjust as needed)
[rows, cols, ~] = size(s_clahe);
s_clahe_reshaped = reshape(s_clahe, rows * cols, 3);
[idx, centroids] = kmeans(s_clahe_reshaped, k);

% Reshape the clustered indices back into the original image size
idx_reshaped = reshape(idx, rows, cols);

% Create a segmented image using the cluster indices and centroids
segmented_image = zeros(rows, cols, 3);
for i = 1:k
    segmented_image(:,:,1) = segmented_image(:,:,1) + (idx_reshaped == i) * centroids(i, 1);
    segmented_image(:,:,2) = segmented_image(:,:,2) + (idx_reshaped == i) * centroids(i, 2);
    segmented_image(:,:,3) = segmented_image(:,:,3) + (idx_reshaped == i) * centroids(i, 3);
end

% Extract the green channel from the segmented image
green_channel = segmented_image(:, :, 2); % Green channel is at index 2

% Threshold the green channel to identify leaves
leaf_mask = green_channel > threshold_value; % Adjust threshold_value as needed

% Create a mask to keep only the green regions
green_mask = cat(3, zeros(rows, cols), leaf_mask, zeros(rows, cols));

% Apply the green mask to the segmented image
green_segmented_image = segmented_image .* green_mask;

% Display the segmented image with only the green regions (leaves)
figure;
imshow(green_segmented_image);
title('Segmented Image: Leaves Only');

%% Sequential memory allocation
binaryImage=y_est;
redAndBlueChannel = 255 * uint8(binaryImage);
greenChannel = 255 * ones(size(binaryImage), 'uint8');
rgbImage = cat(3, greenChannel, redAndBlueChannel, redAndBlueChannel);
figure;
imshow(rgbImage);
title('Detected Pest');

segim=seqmem(y_est);
edmundskarp(s,segim);
Features=deep(segim);
Target=ones(size(segim,1),1);

%% PERFORAMANCE EVALUATION & COMPARISON
[precision,specificity,Acc,f1score]= performaceanalysis(Features,Target);
disp('========= Performance Analysis of the Proposed Work  ========')
fprintf('\n')
disp(['Precision = ' num2str(precision)])
fprintf('\n')
disp(['Specificity = ' num2str(specificity)])
fprintf('\n')
disp(['Accuracy = ' num2str(Acc)])
fprintf('\n')
disp(['F1score = ' num2str(f1score)])

[Acc,sensitivity,specificity,f1score]= CNNclassification(Features,Target);
disp('%%% ===== CNN Classifier PERFORMANCE=====%%%')
disp([' Accuracy = ' num2str(Acc)])
disp([' Precision = ' num2str(sensitivity)])
disp([' Specificity = ' num2str(specificity)])
disp([' F1 score = ' num2str(f1score)])

[precision,specificity,Acc,f1score] = DeepLearning(Features,Target);
disp('========= Performance Analysis of DNN ========')
disp([' Accuracy = ' num2str(Acc)])
toc
disp([' Precision = ' num2str(precision)])
disp([' Specificity = ' num2str(specificity)])
disp([' F1 score = ' num2str(f1score)])

[precision,specificity,Acc,f1score]= ANN(Features,Target);
disp('========= Performance Analysis of ANN ========')
disp([' Accuracy = ' num2str(Acc)])
disp([' Precision = ' num2str(precision)])
disp([' Specificity = ' num2str(specificity)])
disp([' F1 score = ' num2str(f1score)])


