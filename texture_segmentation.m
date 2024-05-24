function texture_segmented_mask = texture_segmentation(image)
    % Convert the image to grayscale
    gray_image = rgb2gray(image);

    % Calculate GLCM with specified properties
    glcm = graycomatrix(gray_image, 'Offset', [0 1], 'Symmetric', true);

    % Compute texture features using GLCM
    contrast = graycoprops(glcm, 'Contrast');
    entropy = graycoprops(glcm, 'Entropy');

    % Thresholding based on texture features
    % You can adjust these thresholds based on your image characteristics
    contrast_threshold = 0.1; % Adjust as needed
    entropy_threshold = 0.5; % Adjust as needed

    % Create a mask based on texture thresholds
    texture_mask = (contrast.Contrast > contrast_threshold) & (entropy.Entropy > entropy_threshold);

    % Perform morphological operations to enhance the mask
    texture_segmented_mask = imclose(texture_mask, strel('disk', 5)); % Close small gaps in the mask
    texture_segmented_mask = imfill(texture_segmented_mask, 'holes'); % Fill holes in the mask
end
