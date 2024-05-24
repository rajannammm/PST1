function segmented_leaf = segment_leaf(image)
    % Convert to Grayscale
    gray_image = rgb2gray(image);
    
    % Thresholding
    threshold = graythresh(gray_image);
    binary_image = imbinarize(gray_image, threshold);
    
    % Morphological Operations
    se = strel('disk', 5); % Adjust the size of the structuring element as needed
    binary_image = imopen(binary_image, se);
    binary_image = imclose(binary_image, se);
    binary_image = imfill(binary_image, 'holes');
    
    % Connected Component Analysis
    cc = bwconncomp(binary_image);
    numPixels = cellfun(@numel, cc.PixelIdxList);
    [~, idx] = max(numPixels);
    largest_component = false(size(binary_image));
    largest_component(cc.PixelIdxList{idx}) = true;
    
    % Darken the background
    segmented_leaf = image;
    segmented_leaf(repmat(~largest_component, [1 1 3])) = segmented_leaf(repmat(~largest_component, [1 1 3])) * 0.5; % Adjust the multiplication factor (0.5) to control the darkening effect
end
