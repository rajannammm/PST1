function filtered_image = maad_filter(image)
    % Apply Median Absolute Absolute Deviation filter
    median_val = median(image(:));
    mad_val = mad(double(image(:)), 1);
    threshold = median_val + 3 * mad_val;
    filtered_image = image;
    filtered_image(image > threshold) = median_val;
end