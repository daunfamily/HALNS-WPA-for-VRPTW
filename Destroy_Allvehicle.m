function [ c,b,Insert,TWolf_One] = Destroy_Allvehicle( TanWolf_Rand,Insert )
TWolf_One=TanWolf_Rand;
c=TWolf_One{1};
V_evaluat_standard=TWolf_One{2}.*TWolf_One{3};
[~,num]=max(V_evaluat_standard);
vehicle_0=find(c==0);
Insert=c(vehicle_0(num)+1:vehicle_0(num+1)-1);
b=c;
b(vehicle_0(num)+1:vehicle_0(num+1)-1)=[];
TWolf_One{1}=b;
end

