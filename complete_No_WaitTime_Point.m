function [ DanChe_KeXing_Speed_SON ] = complete_No_WaitTime_Point( TW,D,workT,v_Set,gen_Vehicle,Arc_SinglePoint,ArrivalWait_SinglePoint )
sets={};
Surplus=length(gen_Vehicle)-1;
for late_v=1:Surplus
    sets{late_v} = v_Set;
end
c_c = cell(1, numel(sets));
[c_c{:}] = ndgrid(sets{:});
cartProd = cell2mat( cellfun(@(v)v(:), c_c, 'UniformOutput',false) );
All_cases=size(cartProd,1);
ArrivalWait_SinglePoint_matrix=zeros(2,length(gen_Vehicle)-1);
cartProd_Cell=cell(All_cases,4);%第一列存该车完整的各弧速度，第二列存到等矩阵，第三列存总用时，第四列存碳排放量
cartProd_Cell(:,4)={0};
for cases_1=1: All_cases
    cartProd_Cell{cases_1,1}=[cartProd(cases_1,:)];
    for cases_2=1:length(gen_Vehicle)-2
         ArrivalWait_SinglePoint_matrix(1,cases_2+1)=sum(ArrivalWait_SinglePoint_matrix(:,cases_2))+workT(gen_Vehicle(cases_2)+1)+D(gen_Vehicle(cases_2)+1,gen_Vehicle(cases_2+1)+1)/cartProd_Cell{cases_1,1}(cases_2);
         if ArrivalWait_SinglePoint_matrix(1,cases_2+1)<TW(gen_Vehicle(cases_2+1)+1,1)
             ArrivalWait_SinglePoint_matrix(2,cases_2+1)=TW(gen_Vehicle(cases_2+1)+1,1)-ArrivalWait_SinglePoint_matrix(1,cases_2+1);
         else
             ArrivalWait_SinglePoint_matrix(2,cases_2+1)=0;
         end
    end
    cartProd_Cell{cases_1,2}=ArrivalWait_SinglePoint_matrix;
    cartProd_Cell{cases_1,3}=sum(ArrivalWait_SinglePoint_matrix(:,end))+workT(gen_Vehicle(end-1)+1)+D(gen_Vehicle(end-1)+1,1)/cartProd_Cell{cases_1,1}(end);   
    for  cases_3=1:length(gen_Vehicle)-1
        cartProd_Cell{cases_1,4}=cartProd_Cell{cases_1,4}+D(gen_Vehicle(cases_3)+1,gen_Vehicle(cases_3+1)+1)*(cartProd_Cell{cases_1,1}(cases_3))^2;
    end
end
A_B= cell2mat(cartProd_Cell(:,3:4));
A_B(:,1)=A_B(:,1)*100000;
pRank=fastNonDominatedSort(A_B);
QY_solution=find(pRank==1);
BBBB=cartProd_Cell(QY_solution,:);
distancevalue=zeros(size(BBBB,1),1);
BBBB(:,end+1)=num2cell(1:size(BBBB,1));
for funct=3:4
    BBBB_MB=sortrows(BBBB,funct);
    [f_Max,Index_Max]=max(cell2mat(BBBB(:,funct)));
    [f_Min,Index_Min]=min(cell2mat(BBBB(:,funct)));
    distancevalue(BBBB_MB{Index_Max,end})=inf;
    distancevalue(BBBB_MB{Index_Min,end})=inf;
     for VE_individual=2:size(BBBB_MB,1)-1  
         Location_number=cell2mat(BBBB_MB(VE_individual,end));
         distancevalue(Location_number)=distancevalue(Location_number)+(BBBB_MB{VE_individual+1,funct}-BBBB_MB{VE_individual-1,funct})/(f_Max-f_Min);
     end
end
[~,ppp]=sort(distancevalue,'descend');
if length(ppp)>=4
   DanChe_KeXing_Speed_SON=BBBB(ppp(3:4),1:end-1);
else
    DanChe_KeXing_Speed_SON=BBBB(ppp(2),1:end-1);
end
end

