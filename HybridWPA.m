clc;clear 
Location=[];
Location(:,1)=xlsread('计算数据.xlsx','sheet13','b2:b23');
Location(:,2)=xlsread('计算数据.xlsx','sheet13','c2:c23');
TW=xlsread('计算数据.xlsx','sheet13','e2:f23');
q=xlsread('计算数据.xlsx','sheet13','d2:d23');
workT=xlsread('计算数据.xlsx','sheet13','g2:g23');
n=1:size(Location,1)-1;
Q=10;
PAIXU=12;
v_min=35;v_mid=40;
v_max=50;
Ship=300;Fuel_Cost=3;Labor=20;
D=zeros(length(n)+1);
for i=1:length(n)+1
    for j=i:length(n)+1
        D(i,j)=6371.004*acos(sind(90-Location(i,1))*sind(90-Location(j,1))*cosd(Location(i,2)-Location(j,2))+cosd(90-Location(i,1))*cosd(90-Location(j,1)));
    end
end
D=D+D';T=D/v_max;
yuanbao=cell(70,13);
TIME=zeros(1,70);
% for cunchu=1:70
popsize=100;
numWolf=1;
all_chromosome_cell=cell(100,12);
while numWolf<=popsize
    n_n=n;
    vehicle=1;
    chromosome_cell=cell(length(n),4);
    chromosome_cell{vehicle,1}=0;
    chromosome_cell{vehicle,2}=0;
    chromosome_cell{vehicle,3}=0;
    chromosome_cell{vehicle,4}=0;
    ArrivalWait_time=zeros(2,1);chromosome_cell{vehicle,5}=ArrivalWait_time;
    while ~isempty(n_n)
        R=randi(length(n_n));
        customer=n_n(R);
        i=1;
        while i<=vehicle
            if chromosome_cell{i,2}+q(customer+1)>Q 
                i=i+1;
                if i>vehicle 
                    vehicle=vehicle+1;
                    chromosome_cell{vehicle,1}=0;chromosome_cell{vehicle,2}=0;chromosome_cell{vehicle,3}=0;chromosome_cell{vehicle,4}=0;chromosome_cell{vehicle,5}=ArrivalWait_time;
                end
            elseif sum(chromosome_cell{i,5}(:,end))+workT(chromosome_cell{i,1}(end)+1)+T(chromosome_cell{i,1}(end)+1,customer+1)>TW(customer+1,2)
                i=i+1;  
                if i>vehicle 
                    vehicle=vehicle+1;
                    chromosome_cell{vehicle,1}=0;chromosome_cell{vehicle,2}=0;chromosome_cell{vehicle,3}=0;chromosome_cell{vehicle,4}=0;chromosome_cell{vehicle,5}=ArrivalWait_time;
                end
            else 
                if sum(chromosome_cell{i,5}(:,end))+workT(chromosome_cell{i,1}(end)+1)+T(chromosome_cell{i,1}(end)+1,customer+1)<TW(customer+1,1) 
                   chromosome_cell{i,5}(1,end+1)=sum(chromosome_cell{i,5}(:,end))+workT(chromosome_cell{i,1}(end)+1)+T(chromosome_cell{i,1}(end)+1,customer+1); 
                   chromosome_cell{i,5}(2,end)=TW(customer+1,1)-chromosome_cell{i,5}(1,end);
                else
                    chromosome_cell{i,5}(1,end+1)=sum(chromosome_cell{i,5}(:,end))+workT(chromosome_cell{i,1}(end)+1)+T(chromosome_cell{i,1}(end)+1,customer+1);
                    chromosome_cell{i,5}(2,end)=0;
                end
                chromosome_cell{i,1}(end+1)=customer;
                chromosome_cell{i,2}=chromosome_cell{i,2}+q(customer+1);
                chromosome_cell{i,4}=chromosome_cell{i,4}+D(chromosome_cell{i,1}(end-1)+1,chromosome_cell{i,1}(end)+1);
                n_n(R)=[];
                break;
            end
        end
    end
    Total_fuel=zeros(1,vehicle);
    for k=1:vehicle
        Single_fuel=0;
        chromosome_cell{k,4}=chromosome_cell{k,4}+D(chromosome_cell{k,1}(end)+1,1);
        chromosome_cell{k,3}=sum(chromosome_cell{k,5}(:,end))+workT(chromosome_cell{k,1}(end)+1)+T(chromosome_cell{k,1}(end)+1,1);
        Singleton_gene=chromosome_cell{k,1};
        Singleton_weight=0;
        for OIL=1:numel(Singleton_gene)-1
            Singleton_weight=Singleton_weight+q(Singleton_gene(OIL)+1);            
            Q_Z=(0.8+0.2*(Singleton_weight/Q))*0.174*450*((22/27)^3)*(D(Singleton_gene(OIL)+1,Singleton_gene(OIL+1)+1)/22);
            Q_F=0.174*450*((22/27)^3)*0.4*workT(Singleton_gene(OIL)+1);
            Single_fuel=Single_fuel+Q_Z+Q_F;
        end
        Single_fuel=Single_fuel+(0.8+0.2*((Singleton_weight+q(Singleton_gene(end)+1))/Q))*0.174*450*((22/27)^3)*(D(Singleton_gene(end)+1,1)/22)+0.174*450*((22/27)^3)*0.4*workT(Singleton_gene(end)+1);        
        Total_fuel(k)=Single_fuel;
    end
    all_chromosome_cell{numWolf,1}=[chromosome_cell{:,1}];
    all_chromosome_cell{numWolf,1}(end+1)=0;
    all_chromosome_cell{numWolf,2}=[chromosome_cell{:,2}];
    all_chromosome_cell{numWolf,3}=[chromosome_cell{:,4}];
    all_chromosome_cell{numWolf,4}=[chromosome_cell{:,5}];
    all_chromosome_cell{numWolf,5}=[chromosome_cell{:,3}];
    all_chromosome_cell{numWolf,6}=sum(cell2mat(chromosome_cell(:,4)));
    all_chromosome_cell{numWolf,7}=vehicle;             
    all_chromosome_cell{numWolf,10}=Total_fuel;         
    all_chromosome_cell{numWolf,11}=sum(Total_fuel);    
    all_chromosome_cell{numWolf,12}=all_chromosome_cell{numWolf,7}*Ship+sum(all_chromosome_cell{numWolf,5})*Labor+all_chromosome_cell{numWolf,11}*Fuel_Cost;
    numWolf=numWolf+1;
end
for i=1:popsize
    SuDu=zeros(1,length(all_chromosome_cell{i,1})-1);
    SuDu(:)=v_max;
    all_chromosome_cell{i,8}=SuDu;
end
all_chromosome_cell=sortrows(all_chromosome_cell,12);
BEST=all_chromosome_cell(1,:);
TanWolf=all_chromosome_cell(1:popsize/2,:);
D_GL=repmat(1/8,1,8);D_LP=cumsum(D_GL);
R_GL=repmat(0.2,1,5);R_LP=cumsum(R_GL);
DestroyWeight_matrix=[zeros(2,8);D_GL];
InsertWeight_matrix=[zeros(2,5);R_GL];
temperature=500; 
beta=0.98;
nnum=1;
tab=1;
while temperature>=0.01
TanWolf_Copy=TanWolf;
first_i=1;
TanWolf_Son={};
SIMP={};
SDEG={};
while first_i<=length(TanWolf)
    a=randperm(size(TanWolf_Copy,1),1);
    TanWolf_Rand=TanWolf_Copy(a,:);
    TanWolf_Copy(a,:)=[];
    second_i=1;
    h=3;
    while second_i<=h
         [c,b,Insert,TWolf_One,DestroyWeight_matrix,InsertWeight_matrix,POHUA,CHARU]=ALNS_VRPTW_main(DestroyWeight_matrix,InsertWeight_matrix,TanWolf_Rand,n,D_LP,R_LP,Q,q,T,TW,workT,D,v_max);
         TWolf_One{12}=TWolf_One{7}*Ship+sum(TWolf_One{5})*Labor+TWolf_One{11}*Fuel_Cost;
         %TanWolf_Son(h*(first_i-1)+second_i,:)=TWolf_One;
         second_i=second_i+1;
       if TWolf_One{12}<TanWolf_Rand{12}
          SIMP(size(SIMP,1)+1,:) = TWolf_One;
          if TWolf_One{12} < BEST{12}
              tab=0;
               Bubian=1;
               BEST = TWolf_One;
               DestroyWeight_matrix(2,POHUA)=DestroyWeight_matrix(2,POHUA)+6;%加分6
               InsertWeight_matrix(2,CHARU)=InsertWeight_matrix(2,CHARU)+6;
           else
               DestroyWeight_matrix(2,POHUA)=DestroyWeight_matrix(2,POHUA)+1;%加分3
               InsertWeight_matrix(2,CHARU)=InsertWeight_matrix(2,CHARU)+1;
           end
        else %模拟退火判断
            Num_rand=rand();
            if Num_rand < exp(-(TWolf_One{12}-TanWolf_Rand{12})/temperature)
                TanWolf_Son(size(TanWolf_Son,1)+1,:)=TWolf_One;
                DestroyWeight_matrix(2,POHUA)=DestroyWeight_matrix(2,POHUA)+2;%加分3
                InsertWeight_matrix(2,CHARU)=InsertWeight_matrix(2,CHARU)+2;
            end
        end
    end
    %TanWolf_Copy(first_i,:) = TWolf_One;%%%%%%
    if size(SIMP,1)~=0
        SIMP=sortrows(SIMP,12);
        TanWolf(first_i,:)=SIMP(1,:);
        SIMP={};
    end
    if size(TanWolf_Son,1)<=3 && size(TanWolf_Son,1)>0
       SDEG=[SDEG;TanWolf_Son];
    end
    first_i=first_i+1;
    TanWolf_Son={};
    nnum=nnum+1;
    if rem(nnum,500)==0
        [DestroyWeight_matrix,D_LP]=DestroyWeight_update(DestroyWeight_matrix);
        [InsertWeight_matrix,R_LP] = InsertWeight_update( InsertWeight_matrix);
    end
end
tab=tab+1;
if tab>500
    break
end
TanWolf_Son_H=[TanWolf;SDEG];
TanWolf_Son_H=sortrows(TanWolf_Son_H,12);
if size(TanWolf_Son_H,1)>120
   TanWolf=TanWolf_Son_H(1:100,:);
end
temperature=temperature*0.98;
end
