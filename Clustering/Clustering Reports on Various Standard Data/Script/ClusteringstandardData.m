%Spectral and k means clustering on standard dataset(like two moon)
data=load('aggregation.dat');

%euclidean distance matrix
simGraph=squareform(pdist(data));  
sim=simGraph;

%Calculating guassian similarity matrix using sigma=0.5
simGraph=exp(-simGraph.^2 ./ (2*0.5^2));
rng('default');

%Number of Clusters
clustersNo=7;

%Type of Spectral Clustering (1,2 or 3)
clusteringType=3;

%Spectral Clustering 
nCIndex = SpectralClustering(simGraph, clustersNo, clusteringType);

%Calculating silhoutte index
nsilhoeutte=silhouette(data,nCIndex,'Euclidean');
sil=mean(nsilhoeutte);

%Kmeans CLustering for comparison
kncindex=kmeans(data,clustersNo);

%Calculating silhoutte index using K-means
knsilhoeutte=silhouette(data,kncindex,'Euclidean');
ksil=mean(knsilhoeutte);