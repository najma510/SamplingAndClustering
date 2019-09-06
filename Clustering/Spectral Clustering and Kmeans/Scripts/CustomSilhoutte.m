% Fuction to manually calculate the silhouette index

% Arguments (mat->Similarity matrix, ncindex->Cluster Assignment
% Returns silhoutte value for each vector
function X = CustomSilhoutte(mat,ncindex)

    % Number of vector(2376)
    [r,~]=size(ncindex);
    
    % m is Number of Clusters
    m=max(ncindex);
    
    % Ai required for Calculating silhoutte index
    a=zeros(r,1);
    
    % Bi required for Calculating silhoutte index
    b=zeros(r,1);
    
    % Silhoutte index for each vector
    s=zeros(r,1);
    
    % for storing Numbers of vectors in each cluster
    count=zeros(m,1);
    
    for i=1:r
        %getting No. of vectors in each cluster
        count(ncindex(i,1),1)=count(ncindex(i,1),1)+1;
        
        %Stores sum of distances of ith vector(in some cluster) to all
        %other points of a particular but different cluster. 
        tempb=zeros(m,1);
        
        %Stores number of vectors in that particular but different cluster.
        tempbc=zeros(m,1);
        
        for j=1:r
            % ith and jth vector are in same cluster then jth vector will
            % contibute to Ai else it will contribute in Bi 
            if (ncindex(i,1)== ncindex(j,1)) && i~=j
                a(i,1)=a(i,1)+mat(i,j);
            elseif ncindex(i,1)~=ncindex(j,1)
                tempb(ncindex(j,1),1)=tempb(ncindex(j,1),1)+mat(i,j);
                tempbc(ncindex(j,1),1)=tempbc(ncindex(j,1),1)+1;
            end
        end
        
        % Calculating which cluster is at minimum mean distance from
        % currrent cluster
        min=1000000;
        for k=1:m
            if k~=ncindex(i,1);
                xx=tempb(k,1)/tempbc(k,1);
                if xx < min
                    min=xx;
                end
            end
        end
        
        %Assigning the min value to Bi  
        b(i,1)=min;
    end
    
    %Dividing by (Number of Clusters-1) in that cluster
    for i=1:r
        a(i,1)=a(i,1)/(count(ncindex(i,1),1)-1);
    end
    
    %Si=(Bi-Ai)/max(Ai,Bi)-> formula for Silhouette index
    for i=1:r
        s(i,1)=(b(i,1)-a(i,1))/max(a(i,1),b(i,1));
    end
    
    % for Returning S 
    X=s;
end

