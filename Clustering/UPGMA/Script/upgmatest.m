% UPGMA Clustering 
Data=load('weightedData.dat');

% Calculating distance matrix for dunn index
dist=pdist(squareform(Data));

% Number of Clusters
ClustNo=20;

%Performing UPGMA Clustering 

%Z is a tree containing hierarchical clusters of the row of the input data
%matrix which is created using the specified method which describes how to
%measure distance between the clusters(Average)
Z=linkage(Data,'average');

ncindex=cluster(Z,'MaxClust',ClustNo);

% Calculating silhoutte index
nsilhoeutte=silhouette(Data,ncindex,'Euclidean');
sil=mean(nsilhoeutte);

%Calculating dunn index
%Note:Distance matrix is used to calculate dunn index and not the similarity matrix
dunn=dunns(ClustNo,dist,ncindex);

