function mat = jaccard(A)
    [r,c]=size(A);
    mat=zeros(r,r);
    for i=1:r
        for j=1:r
            x=A(i,:);
            y=A(j,:);
            [tx,t1]=size(intersect(x,y));
            [ty,t2]=size(union(x,y));
            mat(i,j)=t1/t2;
        end
    end
end

