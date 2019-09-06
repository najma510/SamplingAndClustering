clear;
%Assigning inclusion probabilities to the vectors------------------------
data=load('corrData.dat');
[r,~]=size(data);
D=load('D.dat');  %Already calculated Deviation
W=[0.8;0.8;0.4;0.4;0.9;0.9;1.0;0.8]; %Weights
xk=D*W;
X=sum(xk);
N=500;
inc_prob=(N*xk)/X;

%Loading alredy calculated sample
sample=load('sample1.mat','-ascii');

%Creating new Data(Sampled Data)
for i=1:N
    newdata(i,:)=data(sample(i,1),:);
end

%Clustering the sampled Data--------------------------------------------
dist=squareform(pdist(newdata));
simGraph=exp(-dist.^2 ./ (2*0.5^2));
clustersNo=120;
clusteringType=3;
rng('default');

%Spectral Clustering 
nCIndex = SpectralClustering(simGraph, clustersNo, clusteringType);
nsilhoeutte=silhouette(newdata,nCIndex,'Euclidean');
sil=mean(nsilhoeutte);

%Calculating average inclusion probability of each cluster
average=zeros(clustersNo,1);
for i=1:clustersNo
    sum=0;count=0;
    for j=1:N
        if nCIndex(j,1)==i
            sum=sum+inc_prob(sample(j,1),1);
            count=count+1;
        end
    end
    average(i,1)=sum/count;
end

%Adding sample population in newNCIndex
newNCIndex=zeros(r,1);
for i=1:N
    newNCIndex(sample(i,1),1)=nCIndex(i,1);
end

%Backmapping the remaining population
for i=1:r
    if newNCIndex(i,1)==0
        mn=1000000; 
        index=-1;
        for j=1:clustersNo
            tmp=abs(inc_prob(i,1)-average(j,1));
            if tmp<mn
                mn=tmp;
                index=j;
            end
        end
        newNCIndex(i,1)=index;
    end
end

%Caculating silhouette value
nsilhoeutteABM=silhouette(data,newNCIndex,'Euclidean');
silABM=mean(nsilhoeutteABM);
