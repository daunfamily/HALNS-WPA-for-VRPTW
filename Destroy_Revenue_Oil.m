function [ c,b,Insert,TWolf_One ] = Destroy_Revenue_Oil( TanWolf_Rand,n,~,q,~,D,workT,Q)
Gen=TanWolf_Rand{1};
c=Gen;
Location_0=find(Gen==0);
k_TL=cell(numel(Location_0)-1,1);
for i=1:numel(Location_0)-1
    k_TL{i}=Gen(Location_0(i):Location_0(i+1));
end
Fuel_Rate=zeros(2,numel(n));
Pointer=1;
for i=1:numel(Location_0)-1 
    Gen_Vehicle=k_TL{i};
    Loading_capacity=0;
    Arc_Fuel=zeros(1,numel(Gen_Vehicle)-1);
    for j=1:numel(Gen_Vehicle)-1 
        Arc_Distance=D(Gen_Vehicle(j)+1,Gen_Vehicle(j+1)+1);
        Loading_capacity=Loading_capacity+q(Gen_Vehicle(j)+1);
        Q_Z=(0.8+0.2*(Loading_capacity/Q))*0.174*450*((22/27)^3)*(Arc_Distance/22);
        Q_F=0.174*450*((22/27)^3)*0.4*workT(Gen_Vehicle(j)+1);
        Arc_Fuel(j)=Q_Z+Q_F;
    end
    for i_i=1:size(Arc_Fuel,2)-1
        Fuel_Rate(1,Pointer)=Gen_Vehicle(i_i+1);
        Fuel_Rate(2,Pointer)=(Arc_Fuel(i_i+1)-Arc_Fuel(i_i))/Arc_Fuel(i_i);
        Pointer=Pointer+1;
    end
end
Fuel_Rate_sort=sortrows(Fuel_Rate',-2);
Long=[round(0.15*length(n)):round(0.2*length(n))];
number_Loca=Long(randperm(numel(Long),1));
Insert=Fuel_Rate_sort(1:number_Loca,1);
for cc=1:length(Insert)  
    Gen(Gen==Insert(cc))=[];
end
b=Gen;
TWolf_One=TanWolf_Rand;
TWolf_One{1}=b;
Insert=Insert';
end


