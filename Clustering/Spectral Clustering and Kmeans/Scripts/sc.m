% Spectral Clustering on our Data
data=load('corrData.dat');

% Calculating Euclidean Distance Matrix
distGraph=squareform(pdist(data));

%Calculating Guassian Similarity Matrix using sigma=0.5
simGraph=exp(-distGraph.^2 ./ (2*1.2^2));

%Number of Clusters 
clustersNo = 30;

%For reproducibility
rng('default');

% Type of Spectral Clustering(1,2 or 3)
clusteringType = 1;

% Getting nCIndex [nCIndex means ith(i varies from 1 to 2376) vector 
% is assigned jth(j varies from 1 to clustersNo) cluster]
nCIndex = SpectralClustering(simGraph, clustersNo, clusteringType);

%Calculating silhouette index of clustering (Spectral Clustering)
nsilhoeutte=silhouette(data,nCIndex,'Euclidean');
sil=mean(nsilhoeutte);

% Getting nCIndex using K-means Clustering
kncindex = kmeans(data,clustersNo);

%Calculating silhouette index of clustering (K-means) for Comparison
knsilhoutte=silhouette(data,kncindex,'Euclidean');
ksil=mean(knsilhoutte);

%for Calculating Dunn Index (if required)
dunn=dunns(clustersNo,distGraph,ncindex);
        
