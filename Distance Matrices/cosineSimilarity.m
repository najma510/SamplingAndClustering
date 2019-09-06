%function to calculate the cosine similarity matrix 
function mat = cosineSimilarity(A)
    [r,~]=size(A);
    mat=zeros(r,r);
    for i=1:r
        for j=1:r
            x=A(i,:);  %x is ith row(vector)
            y=A(j,:);  %y is jth row(vector)
            mat(i,j)=dot(x,y)/(norm(x)*norm(y)); %calculating cosine between vectors
        end
    end
end

