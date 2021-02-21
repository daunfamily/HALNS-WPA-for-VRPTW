function [c,Insert,TWolf_One] = Feasible_Repair( c,Insert,TWolf_One,workT,T,TW,D,q,v_max,Q)%此处应该输入破坏子函数中选中的狼对应的全部信息（一整行），非全部探狼元胞矩阵
Location_0=find(c==0);
EveryVehicle_V_all=TWolf_One{8};
EveryVehicle_num=zeros(1,numel(Location_0)-1);
EveryVehicle_V=zeros(1,numel(Location_0)-1);
for i=1: numel(Location_0)-1
    EveryVehicle_num(i)=Location_0(i+1)-Location_0(i)-1;
    EveryVehicle_V(i)=EveryVehicle_num(i)+1;
end
AWtime_matrix=TWolf_One{4};
m_1=Insert';
m_2=zeros(1,length(Insert));
for i=1:length(Insert)
    if length(find(c==Insert(i)))>=2
        fff=find(c==Insert(i));
    end
    m_2(i)=find(c==Insert(i));
end
m=sortrows([m_1 m_2'],2);
k=zeros(1,numel(Insert));
for i=1:size(m,1) 
    k(i)=numel(find(c(1:m(i,2))==0));
end
[uniq,~,~]=unique(k);
Delete_num=zeros(1,numel(uniq));
for i=1:numel(uniq)
    Delete_num(i)=numel(find(k==uniq(i)));
end
m_Flip=flipud(m);
m_Flip_Copy=m_Flip;
k=flip(k);
   Every_vehicle_mile=TWolf_One{3};
   Every_vehicle_Load=TWolf_One{2};
   c_c_c=c;
for i=1:size(m_Flip_Copy,1)  
    EveryVehicle_V_all(m_Flip_Copy(i,2))=[];EveryVehicle_V_all(m_Flip_Copy(i,2)-1)=v_max;
    Every_vehicle_mile(k(i))=Every_vehicle_mile(k(i))-D(c_c_c(m_Flip_Copy(i,2)-1)+1,c_c_c(m_Flip_Copy(i,2))+1)-D(c_c_c(m_Flip_Copy(i,2))+1,c_c_c(m_Flip_Copy(i,2)+1)+1)+D(c_c_c(m_Flip_Copy(i,2)-1)+1,c_c_c(m_Flip_Copy(i,2)+1)+1);
    c_c_c(m_Flip_Copy(i,2))=[];
    Every_vehicle_Load(k(i))=Every_vehicle_Load(k(i))-q(m_Flip_Copy(i,1)+1);
end
ZongTime_location_1=find(TWolf_One{1}==0);
C_C_C_C=c;
for i=numel(uniq):-1:1
    Remain=EveryVehicle_num(uniq(i))-Delete_num(i)-(m_Flip(Delete_num(i),2)-Location_0(uniq(i))-1);
    tempory=0;
    AWtime_matrix(:,m_Flip(Delete_num(i),2):m_Flip(Delete_num(i),2)+Delete_num(i)-1)=[];
    C_C_C_C(m_Flip(1:Delete_num(i),2))=[];
    while Remain>tempory
        AWtime_matrix(1,m_Flip(Delete_num(i),2)+tempory)=sum(AWtime_matrix(:,m_Flip(Delete_num(i),2)+tempory-1))+workT(C_C_C_C(m_Flip(Delete_num(i),2)+tempory-1)+1)+T(C_C_C_C(m_Flip(Delete_num(i),2)+tempory-1)+1,C_C_C_C(m_Flip(Delete_num(i),2)+tempory)+1);
        if AWtime_matrix(1,m_Flip(Delete_num(i),2)+tempory)>=TW(c(m_Flip(Delete_num(i),2)+1)+1,1)
            AWtime_matrix(2,m_Flip(Delete_num(i),2)+tempory)=0;
        else
            AWtime_matrix(2,m_Flip(Delete_num(i),2)+tempory)=TW(C_C_C_C(m_Flip(Delete_num(i),2)+tempory)+1,1)-AWtime_matrix(1,m_Flip(Delete_num(i),2)+tempory);
        end
        tempory=tempory+1;
    end
    m_Flip(1:Delete_num(i),:)=[];
    ZongTime_location_2=find(AWtime_matrix(1,:)==0);
    if uniq(i)==numel(ZongTime_location_2)
       TWolf_One{5}(uniq(i))=sum(AWtime_matrix(:,end))+T(TWolf_One{1}(ZongTime_location_1(uniq(i)+1)-1)+1,1)+workT(TWolf_One{1}(ZongTime_location_1(uniq(i)+1)-1)+1);
    else
       TWolf_One{5}(uniq(i))=sum(AWtime_matrix(:,ZongTime_location_2(uniq(i)+1)-1))+T(TWolf_One{1}(ZongTime_location_1(uniq(i)+1)-1)+1,1)+workT(TWolf_One{1}(ZongTime_location_1(uniq(i)+1)-1)+1);
    end
end
C_OIL=c;
for oil_num=1:numel(Insert) 
    Oil_Location_0=find(C_OIL==0);
    C_OIL_Veh=C_OIL(Oil_Location_0(k(oil_num)):Oil_Location_0(k(oil_num)+1));
    C_OIL_Posion=find(C_OIL_Veh==m_Flip_Copy(oil_num,1));
    Q_Z_1=0.8*0.174*450*((22^2)/(27^3))*(D(C_OIL_Veh(C_OIL_Posion-1)+1,C_OIL_Veh(C_OIL_Posion)+1)+D(C_OIL_Veh(C_OIL_Posion)+1,C_OIL_Veh(C_OIL_Posion+1)+1)-D(C_OIL_Veh(C_OIL_Posion-1)+1,C_OIL_Veh(C_OIL_Posion+1)+1));
    Q_Z_2=(0.2*0.174*450*((22^2)/(27^3))*(sum(q(C_OIL_Veh(1:C_OIL_Posion-1)+1)))*(D(C_OIL_Veh(C_OIL_Posion-1)+1,C_OIL_Veh(C_OIL_Posion)+1)+D(C_OIL_Veh(C_OIL_Posion)+1,C_OIL_Veh(C_OIL_Posion+1)+1)-D(C_OIL_Veh(C_OIL_Posion-1)+1,C_OIL_Veh(C_OIL_Posion+1)+1)))/Q;
    Delet_Late_Long=0;
    for oil_Arc=C_OIL_Posion:numel(C_OIL_Veh)-1
       Delet_Late_Long=D(C_OIL_Veh(oil_Arc)+1,C_OIL_Veh(oil_Arc+1)+1)+Delet_Late_Long;
    end
    Q_Z_3=0.2*0.174*450*((22^2)/(27^3))*q(C_OIL_Veh(C_OIL_Posion)+1)*Delet_Late_Long/Q;
    Q_F=0.174*450*((22^2)/(27^3))*22*workT(C_OIL_Veh(C_OIL_Posion)+1)*0.4;
    TWolf_One{10}(k(oil_num))=TWolf_One{10}(k(oil_num))-Q_Z_1-Q_Z_2-Q_Z_3-Q_F;
    C_OIL(m_Flip_Copy(oil_num,2))=[];
end
TWolf_One{4}=AWtime_matrix;
TWolf_One{2}=Every_vehicle_Load;
TWolf_One{3}=Every_vehicle_mile;
TWolf_One{6}=sum(Every_vehicle_mile);
TWolf_One{8}=EveryVehicle_V_all;
TWolf_One{11}=sum(TWolf_One{10});
end

