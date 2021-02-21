function [ TWolf_One] = Finally_Repair( Point,Plan_Insert_Position,TWolf_One,T,TW,q,workT,v_max,D,Q)
b=TWolf_One{1};
speed_all=TWolf_One{8};
Location_0=find(TWolf_One{1}==0);
vehcle=cell(numel(Location_0)-1,1);
Speed=cell(numel(Location_0)-1,1);
for i=1:numel(Location_0)-1   
    vehcle{i}=b(Location_0(i):Location_0(i+1));
    Speed{i}=speed_all(Location_0(i):Location_0(i+1)-1);
end
b_1=Plan_Insert_Position(1);
b_2=Plan_Insert_Position(2);
b_3=Plan_Insert_Position(3);
vehcle{b_1}=[vehcle{b_1}(1:b_2),Point,vehcle{b_1}(b_2+1:end)];
Speed{b_1}(b_2)=v_max;
Speed{b_1}=[Speed{b_1}(1:b_2),v_max,Speed{b_1}(b_2+1:end)];
JiYin=vehcle{b_1};
mmm=[];
vvv=[];
for i=1:length(vehcle)
    mmm=[mmm,vehcle{i}(1:end-1)];
    vvv=[vvv,Speed{i}(1:end)];
end
TWolf_One{1}=[mmm,0];
TWolf_One{8}=vvv;
TWolf_One{2}(b_1)=TWolf_One{2}(b_1)+q(Point+1);
TWolf_One{3}(b_1)=TWolf_One{3}(b_1)+b_3;
AWtime_matrix=TWolf_One{4};
Temp_TimeChange=AWtime_matrix(:,Location_0(b_1):Location_0(b_1+1)-1);
New_TimeChange=zeros(2,numel(vehcle{b_1})-1);
New_TimeChange(:,1:b_2)=Temp_TimeChange(:,1:b_2);
for i=b_2+1:numel(vehcle{b_1})-1  
    New_TimeChange(1,i)=sum(New_TimeChange(:,i-1))+workT(JiYin(i-1)+1)+T(JiYin(i-1)+1,JiYin(i)+1);
    if New_TimeChange(1,i)>=TW(JiYin(i)+1,1)
        New_TimeChange(2,i)=0;
    else
        New_TimeChange(2,i)=TW(JiYin(i)+1,1)-New_TimeChange(1,i);
    end
end  
AWtime_matrix=[AWtime_matrix(:,1:Location_0(b_1)-1),New_TimeChange,AWtime_matrix(:,Location_0(b_1+1):end)];
TWolf_One{4}=AWtime_matrix;
TWolf_One{6}=TWolf_One{6}+b_3;
TWolf_One{7}=numel(Location_0)-1;
update_Location_0=find(TWolf_One{1}==0);
TWolf_One{5}(b_1)=sum(AWtime_matrix(:,update_Location_0(b_1+1)-1))+workT(TWolf_One{1}(update_Location_0(b_1+1)-1)+1)+T(TWolf_One{1}(update_Location_0(b_1+1)-1)+1,1);
Cumulative_change=0;
Insert_Long=D(vehcle{b_1}(b_2)+1,vehcle{b_1}(b_2+1)+1)+D(vehcle{b_1}(b_2+1)+1,vehcle{b_1}(b_2+2)+1)-D(vehcle{b_1}(b_2)+1,vehcle{b_1}(b_2+2)+1);
Q_Z_1=0.8*0.174*450*((22^2)/(27^3))*Insert_Long;
Q_Z_2=0.2*0.174*450*((22^2)/(27^3))*(sum(q(vehcle{b_1}(1:b_2)+1)))*Insert_Long/Q;
Insert_Long2=0;
for Oil_update1=b_2+1:numel(vehcle{b_1})-1
    Insert_Long2=Insert_Long2+D(vehcle{b_1}(Oil_update1)+1,vehcle{b_1}(Oil_update1+1)+1);
end
Q_Z_3=0.2*0.174*450*((22^2)/(27^3))*q(Point+1)*Insert_Long2/Q;
Q_F=0.174*450*((22^2)/(27^3))*22*workT(Point+1)*0.4;
Cumulative_change=Q_Z_1+Q_Z_2+Q_Z_3+Q_F;
TWolf_One{10}(b_1)=TWolf_One{10}(b_1)+Cumulative_change;
TWolf_One{11}=TWolf_One{11}+Cumulative_change;
end

