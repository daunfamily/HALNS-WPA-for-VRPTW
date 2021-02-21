function [ DestroyWeight_matrix,D_LP] = DestroyWeight_update( DestroyWeight_matrix)
alpha=0.8;
for i=1:8
    if DestroyWeight_matrix(2,i)>0
        DestroyWeight_matrix(3,i)=alpha*DestroyWeight_matrix(3,i)+(1-alpha)*(DestroyWeight_matrix(1,i)/DestroyWeight_matrix(2,i));
        DestroyWeight_matrix(1,i)=0;
        DestroyWeight_matrix(2,i)=0;
    else
        DestroyWeight_matrix(3,i)=alpha*DestroyWeight_matrix(3,i);
    end
end
DestroyWeight_matrix(1:2,:)=0;
DestroyWeight_matrix(3,:)=DestroyWeight_matrix(3,:)/sum(DestroyWeight_matrix(3,:));
D_LP=cumsum(DestroyWeight_matrix(3,:));

end

