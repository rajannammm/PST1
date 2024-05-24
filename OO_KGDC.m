function [cluster_centers, cluster_labels] = OO_KGDC(affinity_matrix, num_clusters)
    % Apply OO-KGDC algorithm for graph partitioning
    % Inputs:
    %   - affinity_matrix: Affinity matrix representing pairwise similarities between nodes
    %   - num_clusters: Number of clusters
    % Outputs:
    %   - cluster_centers: Centers of the clusters
    %   - cluster_labels: Labels of the clusters

    % Get the number of nodes
    num_nodes = size(affinity_matrix, 1);
    
    % Ensure num_clusters does not exceed the number of nodes
    num_clusters = min(num_clusters, num_nodes);
    
    fprintf('Number of nodes: %d\n', num_nodes);
    fprintf('Number of clusters: %d\n', num_clusters);

    % Randomly initialize cluster centers
    random_indices = randperm(num_nodes);
    cluster_centers_indices = random_indices(1:num_clusters);
    cluster_centers = affinity_matrix(cluster_centers_indices, :);
    
    fprintf('Cluster centers indices: %s\n', num2str(cluster_centers_indices));

    % Assign each node to the nearest cluster center
    distances = pdist2(affinity_matrix, cluster_centers);
    [~, cluster_labels] = min(distances, [], 2);

    % Print intermediate results
    disp('Cluster labels:');
    disp(cluster_labels);
    
end
