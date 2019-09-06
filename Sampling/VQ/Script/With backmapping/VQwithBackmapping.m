%Script for both sampling and then clustering on sampled data using vector
%quantization with backmapping 

data=load('corrData.dat');

%Calculating distance matrix
dist=squareform(pdist(data));

%Calculating similarity matrix using Guassian function with sigma=0.5
sim=exp(-dist.^2 ./ (2*0.5^2));

%Number of Samples 
N=500;

%Performing Sampling (By finding representatives from each cluster)

%Clustering data for finding sample 
ncindex=kmeans(data,N);
[r,c]=size(ncindex);

%getting number of vectors in each cluster
count=zeros(N,1);
for i=1:r
    count(ncindex(i,1),1)=count(ncindex(i,1),1)+1;
end

%Mat stores indices of representatives  
Mat=zeros(N,1);
for i=1:N

    %Collecting Vectors in cluster i
    tmp=zeros(count(i,1),1);k=1;
    for j=1:r
        if(ncindex(j,1)==i)
            tmp(k,1)=j;
            k=k+1;
        end
    end

    %Finding Reperesentative with minimum mean distance
    min=1000000000;
    for j=1:count(i,1)
        tdist=0;
        for k=1:count(i,1)
           tdist=tdist+dist(tmp(j,1),tmp(k,1)); 
        end
        tdist=tdist/count(i,1);
        if(tdist<min)
            Mat(i,1)=tmp(j,1);
            min=tdist;
        end
    end

end
% sampling part done.    
    

%Creating sampled Data using indices
for i=1:N
    newdata(i,:)=data(Mat(i,1),:);
end

%creating sampled similarity matrix using indices and original similarity
newdist=squareform(pdist(newdata));
SampledSim=exp(-newdist.^2 ./ (2*0.5^2));

%Number of clusters and Type of Spectral Clustering
clustersNo = 30;
clusteringType = 2;

%For reproducibility
rng('default');

%Performing spectral clustering on Sampled Data
nCIndex = SpectralClustering(SampledSim, clustersNo, clusteringType);

%Calculating silhouette and dunn index (Spectral Clustering)
nsilhoeutte=silhouette(newdata,nCIndex,'Euclidean');
sil=mean(nsilhoeutte);
dunn=dunns(clustersNo,newdist,nCIndex);

%Performing k means on sampled data for comparison
knCIndex=kmeans(newdata,clustersNo);

%Calculating silhouette and dunn index (Kmeans)
knsilhoeutte=silhouette(newdata,knCIndex,'Euclidean');
ksil=mean(knsilhoeutte);
kdunn=dunns(clustersNo,newdist,knCIndex);

%Backmapping part (On spectrally clustered sample)
newNcindex=zeros(r,1);  %stores final ncindex after backmapping
for i=1:r
    cn=ncindex(i,1);
    fcn=nCIndex(cn,1);
    newNcindex(i,1)=fcn;
end

%Calculating Silhouette index after backmapping
ABMnsilhoeutte=silhouette(data,newNcindex,'Euclidean');
ABMsil=mean(ABMnsilhoeutte);
ABMdunn=dunns(clustersNo,dist,newNcindex);
