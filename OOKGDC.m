function labels = OOKGDC(X, num_clusters, kernel, gamma)
    % X: Input data matrix (n_samples x n_features)
    % num_clusters: Number of clusters
    % kernel: Kernel type ('rbf', 'linear', etc.)
    % gamma: Gamma parameter for the kernel
    
    n_samples = size(X, 1);
    n_features = size(X, 2);
    
    % Ensure num_clusters is within bounds
    num_clusters = min(num_clusters, n_samples);
    if num_clusters > n_samples
        error('Number of clusters exceeds the number of samples.');
    end

    % Initialize centroids randomly
    random_indices = randperm(n_samples, num_clusters);
    centroids = X(random_indices, :);

    % Iterate until convergence
    while true
        % Update labels based on kernel similarity
        kernel_matrix = compute_kernel_matrix(X, centroids, kernel, gamma);
        [~, labels] = min(kernel_matrix, [], 2);
        
        % Update centroids
        new_centroids = zeros(num_clusters, n_features);
        cluster_counts = zeros(num_clusters, 1);
        for i = 1:n_samples
            cluster_idx = labels(i);
            new_centroids(cluster_idx, :) = new_centroids(cluster_idx, :) + X(i, :);
            cluster_counts(cluster_idx) = cluster_counts(cluster_idx) + 1;
        end
        for i = 1:num_clusters
            if cluster_counts(i) > 0
                new_centroids(i, :) = new_centroids(i, :) ./ cluster_counts(i);
            end
        end
        
        % Check for convergence
        if isequal(centroids, new_centroids)
            break;
        end
        
        centroids = new_centroids;
    end
    
    labels = labels';
end

function kernel_matrix = compute_kernel_matrix(X, centroids, kernel, gamma)
    n_samples = size(X, 1);
    num_clusters = size(centroids, 1);
    kernel_matrix = zeros(n_samples, num_clusters);
    for i = 1:num_clusters
        kernel_matrix(:, i) = kernel_function(X, centroids(i, :), kernel, gamma);
    end
end

function K = kernel_function(X, Y, kernel, gamma)
    switch kernel
        case 'rbf'
            K = exp(-gamma * pdist2(X, Y, 'euclidean').^2);
        case 'linear'
            K = X * Y';
        otherwise
            error('Unsupported kernel type');
    end
end
