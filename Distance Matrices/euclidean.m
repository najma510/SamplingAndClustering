%function to calculate Euclidean 
function mat = euclidean(A)
    [r,~]=size(A);
    mat=zeros(r,r);
    for i=1:r
        for j=1:r
            x=A(i,:); % x is ith row(vector)
            y=A(j,:); % y is jth row(vector)
            mat(i,j)=norm(x-y);
        end
    end
end

