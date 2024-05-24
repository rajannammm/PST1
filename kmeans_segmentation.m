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

% Define a threshold value to identify leaves (adjust as needed)
threshold_value = 0.8; % Example threshold value

% Threshold the green channel to identify leaves
leaf_mask = green_channel > threshold_value;

% Create a mask to keep only the green regions
green_mask = cat(3, zeros(rows, cols), leaf_mask, zeros(rows, cols));

% Apply the green mask to the segmented image
green_segmented_image = segmented_image .* green_mask;

% Display the segmented image with only the green regions (leaves)
figure;
imshow(green_segmented_image);
title('Segmented Image: Leaves Only');
