function [ Oil_save ] = Oil_Test( T,D,q,TWolf_One )
b=TWolf_One{1};
Location_0=find(b==0);
k=cell(numel(Location_0)-1,1);
for i=1:numel(Location_0)-1
    k{i}=b(Location_0(i):Location_0(i+1));
end
Oil_save=zeros(1,size(k,1));
for test1=1:size(k,1)
    test1_1=k{test1};
    zaizhongliang=sum(q(test1_1(2:end-1)+1));
    for  test2=1:numel(test1_1)-1
        zaizhongliang=zaizhongliang-q(test1_1(test2)+1);
        Oil_save(test1)=Oil_save(test1)+D(test1_1(test2)+1,test1_1(test2+1)+1)*(0.07783+0.00002189*zaizhongliang);
    end
end
end

