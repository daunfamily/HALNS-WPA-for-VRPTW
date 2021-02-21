function [ Insert,TWolf_One ] = Insert_TL(  Point,TWolf_One,Insert,KeChaRuDian,D,q,T,TW,workT,v_max,Q)
b=TWolf_One{1};
Location_0=find(b==0);
k=cell(numel(Location_0)-1,1);
for i=1:numel(Location_0)-1
    k{i}=b(Location_0(i):Location_0(i+1));
end
TL_Increase=zeros(1,size(KeChaRuDian,2));
for i=1:size(KeChaRuDian,2)
   JiYin_VE=k{KeChaRuDian(1,i)};
   JiYin_VE=[JiYin_VE(1:KeChaRuDian(2,i)),Point,JiYin_VE(KeChaRuDian(2,i)+1:end)];
   TL_Increase(i)=((1:numel(JiYin_VE)-2)*q(JiYin_VE(2:end-1)+1))/((numel(JiYin_VE)-2)*sum(q(JiYin_VE(2:end-1)+1)));
end
[~,where]=max(TL_Increase);
Plan_Insert_Position=[KeChaRuDian(1,where),KeChaRuDian(2,where)];
[ TWolf_One] = Finally_Repair_TL( Point,Plan_Insert_Position,TWolf_One,T,TW,q,workT,v_max,D,Q);
end

