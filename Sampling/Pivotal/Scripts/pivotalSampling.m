clear;
%Assigning inclusion probabilities to the vectors------------------------
data=load('corrData.dat');
D=load('D.dat');  %Already saved deviation
W=[0.8;0.8;0.4;0.4;0.9;0.9;1.0;0.8];  %weight vector
xk=D*W;
X=sum(xk);
N=500;
inc_prob=(N*xk)/X;
P=inc_prob;

%2 lines added later for saving corresponding spleft and spright

sample=zeros(N,2);  %Sample with selection step probability
k=1;

%Implementing Pivotal Sampling-------------------------------------------
[n,~]=size(inc_prob);
left=1;right=2;
while right<=n
    if(inc_prob(left,1)+inc_prob(right,1)<1)
        %Rejection Step
        rpleft=inc_prob(right,1)/(inc_prob(left,1)+inc_prob(right,1));
        rpright=inc_prob(left,1)/(inc_prob(left,1)+inc_prob(right,1));
        x=rand;
        if x<=rpleft 
            %left pointer rejected
            inc_prob(right,1)=inc_prob(left,1)+inc_prob(right,1);
            inc_prob(left,1)=0;
            left=right;
            right=left+1;
        else
            inc_prob(left,1)=inc_prob(left,1)+inc_prob(right,1);
            inc_prob(right,1)=0;
            right=right+1;
        end
    else
        %Selection Step
        spleft=(1-inc_prob(right,1))/(2-inc_prob(right,1)-inc_prob(left,1));
        spright=(1-inc_prob(left,1))/(2-inc_prob(right,1)-inc_prob(left,1));
        y=rand;
        if y<=spleft
            %left pointer selected
            inc_prob(right,1)=inc_prob(left,1)+inc_prob(right,1)-1;
            inc_prob(left,1)=1;
            sample(k,1)=left;  %for spleft
            sample(k,2)=spleft;  %for spleft
            k=k+1;              %for spleft
            left=right;
            right=left+1;
        else
            %right pointer selected
            inc_prob(left,1)=inc_prob(left,1)+inc_prob(right,1)-1;
            inc_prob(right,1)=1;
            sample(k,1)=right;  %for spright
            sample(k,2)=spright;  %for spright
            k=k+1;                  %for spright
            right=right+1;
        end
    end
end

%save 'sample5.dat' sample -ascii;

%Creating sample population and new data--------------------------------
sample=zeros(N,1);
nn=1;
for i=1:n
    if inc_prob(i,1)>0.9
        sample(nn,1)=i;
        nn=nn+1;
    end
end

%Creating new Data
for i=1:N
    newdata(i,:)=cdata(sample(i,1),:);
end

X=mean(newdata);
M=X.';
%Clustering the sampled Data--------------------------------------------

dist=squareform(pdist(newdata));
simGraph=exp(-dist.^2 ./ (2*0.5^2));
clustersNo=50;
clusteringType=3;

%Spectral Clustering 
nCIndex = SpectralClustering(simGraph, clustersNo, clusteringType);
nsilhoeutte=silhouette(newdata,nCIndex,'Euclidean');
sil=mean(nsilhoeutte);

%K-mean Clustering for Comparison
knCIndex=kmeans(newdata,clustersNo);
knsilhoeutte=silhouette(newdata,knCIndex,'Euclidean');
ksil=mean(knsilhoeutte);
