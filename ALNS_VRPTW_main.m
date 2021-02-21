function [  c,b,Insert,TWolf_One,DestroyWeight_matrix,InsertWeight_matrix,POHUA,CHARU] = ALNS_VRPTW_main(DestroyWeight_matrix,InsertWeight_matrix,TanWolf_Rand,n,D_LP,R_LP,Q,q,T,TW,workT,D,v_max)
select=rand();
[ c,b,Insert,TWolf_One,DestroyWeight_matrix,POHUA]=DestroyOperate(DestroyWeight_matrix,TanWolf_Rand,select,n,D_LP,q,T,TW,D,workT,Q);
[c,Insert,TWolf_One] = Feasible_Repair( c,Insert,TWolf_One,workT,T,TW,D,q,v_max,Q);
ZhengCheXiuFu=find(TWolf_One{1}==0);
ZhengCheXiuFu_1=find(diff(ZhengCheXiuFu)==1);
if ~isempty(ZhengCheXiuFu_1)
    TWolf_One{8}(ZhengCheXiuFu(ZhengCheXiuFu_1))=[];
    TWolf_One{1}(ZhengCheXiuFu(ZhengCheXiuFu_1))=[];
    TWolf_One{2}(ZhengCheXiuFu_1)=[];
    TWolf_One{3}(ZhengCheXiuFu_1)=[];
    TWolf_One{4}(:,ZhengCheXiuFu(ZhengCheXiuFu_1))=[];
    TWolf_One{5}(ZhengCheXiuFu_1)=[];
    TWolf_One{7}=TWolf_One{7}-numel(ZhengCheXiuFu_1);
    TWolf_One{10}(ZhengCheXiuFu_1)=[];
    TWolf_One{11}=sum(TWolf_One{10});
end
select=rand();
[ c,Insert,TWolf_One,InsertWeight_matrix,CHARU] = InsertOperate(c,InsertWeight_matrix,TWolf_One,select,Insert,R_LP,Q,q,T,TW,workT,D,v_max);
end