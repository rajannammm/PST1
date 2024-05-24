function y_est_filtered = MAD_filter(y_est, mad_threshold)
    % Compute the Median Absolute Deviation (MAD)
    med_abs_dev = mad(y_est(:));

    % Threshold the image to identify noisy pixels
    noisy_pixels = abs(y_est - median(y_est(:))) > mad_threshold * med_abs_dev;

    % Replace noisy pixels with the median value of the surrounding pixels
    y_est_filtered = y_est;
    y_est_filtered(noisy_pixels) = median(y_est(:));
end
