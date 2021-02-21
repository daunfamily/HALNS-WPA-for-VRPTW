function [ c,b,Insert,TWolf_One,DestroyWeight_matrix,POHUA] = DestroyOperate( DestroyWeight_matrix,TanWolf_Rand,select,n,D_LP,q,T,TW,D,workT,Q)
Insert=[];
if select<=D_LP(1)
    POHUA=1;
    DestroyWeight_matrix(1,1)=DestroyWeight_matrix(1,1)+1;
    [c,b,Insert,TWolf_One]=Destroy_rand(TanWolf_Rand,n,Insert);
elseif select<=D_LP(2)
    POHUA=2;
    DestroyWeight_matrix(1,2)=DestroyWeight_matrix(1,2)+1;
    [c,b,Insert,TWolf_One ]=Destroy_Similar(TanWolf_Rand,n,Insert,q,T,TW,D);
elseif select<=D_LP(3)
    POHUA=3;
    DestroyWeight_matrix(1,3)=DestroyWeight_matrix(1,3)+1;
    [c,b,Insert,TWolf_One]=Destroy_Revenue(Insert,TanWolf_Rand,n,D );
elseif select<=D_LP(4)
    POHUA=4;
    DestroyWeight_matrix(1,4)=DestroyWeight_matrix(1,4)+1;
    [ c,b,Insert,TWolf_One]=Destroy_Allvehicle(TanWolf_Rand,Insert );
elseif select<=D_LP(5)
    POHUA=5;
    DestroyWeight_matrix(1,5)=DestroyWeight_matrix(1,5)+1;
    [c,b,Insert,TWolf_One ]=Destroy_Similar_Q(TanWolf_Rand,n,Insert,q,T,TW,D);
elseif select<=D_LP(6)
    POHUA=6;
    DestroyWeight_matrix(1,6)=DestroyWeight_matrix(1,6)+1;
    [ c,b,Insert,TWolf_One ] = Destroy_Revenue_Oil( TanWolf_Rand,n,Insert,q,T,D,workT,Q);
elseif select<=D_LP(7)
    POHUA=7;
    DestroyWeight_matrix(1,7)=DestroyWeight_matrix(1,7)+1;
    [c,b,Insert,TWolf_One ]=Destroy_Allvehicle_TL( TanWolf_Rand,n,Insert,q,T,D );
elseif select<=D_LP(8)
    POHUA=8;
    DestroyWeight_matrix(1,8)=DestroyWeight_matrix(1,8)+1;
    [ c,b,Insert,TWolf_One ] = Destroy_Delete_TL( TanWolf_Rand,n,Insert,q,T,D );
end
end

