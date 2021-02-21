function [ InsertWeight_matrix,R_LP] = InsertWeight_update( InsertWeight_matrix)
alpha=0.8;
for i=1:5
    if InsertWeight_matrix(2,i)>0
        InsertWeight_matrix(3,i)=alpha*InsertWeight_matrix(3,i)+(1-alpha)*(InsertWeight_matrix(1,i)/InsertWeight_matrix(2,i));
        InsertWeight_matrix(1,i)=0;
        InsertWeight_matrix(2,i)=0;
    else
        InsertWeight_matrix(3,i)=alpha*InsertWeight_matrix(3,i);
    end
end
InsertWeight_matrix(1:2,:)=0;
InsertWeight_matrix(3,:)=InsertWeight_matrix(3,:)/sum(InsertWeight_matrix(3,:));
R_LP=cumsum(InsertWeight_matrix(3,:));
end

