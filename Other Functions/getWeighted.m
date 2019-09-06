%mat is unweighted data and w is weight vector with values between 0 and 1
function x = getWeighted(mat,w)
    [r,c]=size(mat);
    for i=1:r
        for j=1:c
			%multiplying each cell with corresponding weight
            mat(i,j)=mat(i,j)*w(j,1);
        end
    end
    x=mat;
end

