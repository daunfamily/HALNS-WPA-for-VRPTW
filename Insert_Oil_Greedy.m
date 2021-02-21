function [ Insert,TWolf_One ] = Insert_Oil_Greedy( Point,TWolf_One,Insert,KeChaRuDian,D,q,T,TW,workT,v_max,Q)
b=TWolf_One{1};
Location_0=find(b==0);
k=cell(numel(Location_0)-1,1);
for i=1:numel(Location_0)-1
    k{i}=b(Location_0(i):Location_0(i+1));
end

Fuel_Increase=zeros(1,size(KeChaRuDian,2));
for i=1:size(KeChaRuDian,2)
   JiYin_VE=k{KeChaRuDian(1,i)};
   JiYin_VE=[JiYin_VE(1:KeChaRuDian(2,i)),Point,JiYin_VE(KeChaRuDian(2,i)+1:end)];
   Part_2_Distance=D(JiYin_VE(KeChaRuDian(2,i))+1,JiYin_VE(KeChaRuDian(2,i)+1)+1)+D(JiYin_VE(KeChaRuDian(2,i)+1)+1,JiYin_VE(KeChaRuDian(2,i)+2)+1)-D(JiYin_VE(KeChaRuDian(2,i))+1,JiYin_VE(KeChaRuDian(2,i)+2)+1);
   Part_2_Weight=sum(q(JiYin_VE(1:KeChaRuDian(2,i))+1));
   Part_3_Distance=0;
   for j_one=KeChaRuDian(2,i)+1:numel(JiYin_VE)-1
       Part_3_Distance=Part_3_Distance+D(JiYin_VE(j_one)+1,JiYin_VE(j_one+1)+1);
   end
   Fuel_Increase(i)=0.8*0.174*450*((22^2)/(27^3))*Part_2_Distance+(0.2*0.174*450*((22^2)/(27^3))*Part_2_Weight*Part_2_Distance/Q)+0.2*0.174*450*((22^2)/(27^3))*q(Point+1)*Part_3_Distance/Q+0.174*450*((22^3)/(27^3))*0.4*workT(Point+1);
end
[Improve,where]=min(Fuel_Increase);
Plan_Insert_Position=[KeChaRuDian(1,where),KeChaRuDian(2,where),Improve];
[ TWolf_One] = Finally_Repair_Oil( Point,Plan_Insert_Position,TWolf_One,T,TW,q,workT,v_max,D);
end

