function [ Insert,TWolf_One] = Insert_Greedy( Point,TWolf_One,Insert,KeChaRuDian,D,q,T,TW,workT,v_max,Q)
b=TWolf_One{1};
Location_0=find(b==0);
k=cell(numel(Location_0)-1,1);
for i=1:numel(Location_0)-1
    k{i}=b(Location_0(i):Location_0(i+1));
end
Increase_distance=zeros(1,size(KeChaRuDian,2));
for i=1:size(KeChaRuDian,2)
    JiYin=k{KeChaRuDian(1,i)};
    Increase_distance(i)=D(JiYin(KeChaRuDian(2,i))+1,Point+1)+D(Point+1,JiYin(KeChaRuDian(2,i)+1)+1)-D(JiYin(KeChaRuDian(2,i))+1,JiYin(KeChaRuDian(2,i)+1)+1);
end
[Improve,where]=min(Increase_distance);
Plan_Insert_Position=[KeChaRuDian(1,where),KeChaRuDian(2,where),Improve];
[ TWolf_One] = Finally_Repair( Point,Plan_Insert_Position,TWolf_One,T,TW,q,workT,v_max,D,Q);
end