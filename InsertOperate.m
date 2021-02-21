function [ c,Insert,TWolf_One,InsertWeight_matrix,CHARU ] = InsertOperate(c,InsertWeight_matrix,TWolf_One,select,Insert,R_LP,Q,q,T,TW,workT,D,v_max)
Infeasible_point=[];
if select<=R_LP(1)
    while numel(Insert)>0
         [Point,KeChaRuDian ] = Feasibility_judgment( Insert,TWolf_One,Q,q,T,TW,workT );
         if  size(KeChaRuDian,2)==0
             Infeasible_point=[Infeasible_point,Point];
         else
             [Insert,TWolf_One]=Insert_Greedy( Point,TWolf_One,Insert,KeChaRuDian,D,q,T,TW,workT,v_max,Q);
         end
         Insert(Insert==Point)=[];
    end
     if numel(Infeasible_point)>0 
        [ TWolf_One ] = Infeasible_Deal(Infeasible_point,TWolf_One,Q,q,T,TW,workT,D,v_max);
     end
    InsertWeight_matrix(1,1)=InsertWeight_matrix(1,1)+1;
    CHARU=1;
elseif select<=R_LP(2)
    while numel(Insert)>0
        Temp_finally_serve=cell(numel(Insert),3);
        for i=1:numel(Insert )
           Point=Insert(i);
           [KeChaRuDian] = Feasibility_judgment_lianxu( Point,Insert,TWolf_One,Q,q,T,TW,workT );
           if size(KeChaRuDian,2)==0
               Infeasible_point=[Infeasible_point,Point];
           else
               [Regret,All_information,Insert,TWolf_One]=Insert_Regret(Point,TWolf_One,Insert,KeChaRuDian,D,q);
               Temp_finally_serve{i,1}=Point;
               Temp_finally_serve{i,2}=All_information;
               Temp_finally_serve{i,3}=Regret;
           end
        end  
        if length(intersect(Infeasible_point,Insert)) == length(Insert) 
            break
        end
        Temp_finally_serve(~any(cellfun(@nnz,Temp_finally_serve),2),:)=[];
        Temp_finally_serve=sortrows(Temp_finally_serve,-3);
        Point=Temp_finally_serve{1,1};
        Plan_Insert_Position=Temp_finally_serve{1,2}(1,:);
        [ TWolf_One] = Finally_Repair( Point,Plan_Insert_Position,TWolf_One,T,TW,q,workT,v_max,D,Q);
        Insert(Insert==Point)=[];
    end
     if numel(Infeasible_point)>0 
        [ TWolf_One ] = Infeasible_Deal(Infeasible_point,TWolf_One,Q,q,T,TW,workT,D,v_max);
     end
    InsertWeight_matrix(1,2)=InsertWeight_matrix(1,2)+1;
    CHARU=2;
elseif select<=R_LP(3)
    while numel(Insert)>0
        [Point,KeChaRuDian ] = Feasibility_judgment( Insert,TWolf_One,Q,q,T,TW,workT );
         if  size(KeChaRuDian,2)==0 
             Infeasible_point=[Infeasible_point,Point];
         else
             [Insert,TWolf_One]=Insert_Oil_Greedy( Point,TWolf_One,Insert,KeChaRuDian,D,q,T,TW,workT,v_max,Q);
         end
         Insert(Insert==Point)=[];
    end
    if numel(Infeasible_point)>0 
       [ TWolf_One ] = Infeasible_Deal(Infeasible_point,TWolf_One,Q,q,T,TW,workT,D,v_max);
    end
    InsertWeight_matrix(1,3)=InsertWeight_matrix(1,3)+1;
    CHARU=3;
elseif select<=R_LP(4)
    while numel(Insert)>0
        Temp_finally_serve=cell(numel(Insert),3);
        for i=1:numel(Insert )
           Point=Insert(i);
           [KeChaRuDian] = Feasibility_judgment_lianxu( Point,Insert,TWolf_One,Q,q,T,TW,workT );
           if size(KeChaRuDian,2)==0
               Infeasible_point=[Infeasible_point,Point];
           else
               [Regret,All_information,Insert,TWolf_One]=Insert_Oil_Regret(Point,TWolf_One,Insert,KeChaRuDian,D,q,workT,Q);
               Temp_finally_serve{i,1}=Point;
               Temp_finally_serve{i,2}=All_information;
               Temp_finally_serve{i,3}=Regret;
           end
        end 
        if length(intersect(Infeasible_point,Insert)) == length(Insert) 
            break
        end
        Temp_finally_serve(~any(cellfun(@nnz,Temp_finally_serve),2),:)=[];
        Temp_finally_serve=sortrows(Temp_finally_serve,-3);
        Point=Temp_finally_serve{1,1};
        Plan_Insert_Position=Temp_finally_serve{1,2}(1,:);
        [ TWolf_One] = Finally_Repair_Oil( Point,Plan_Insert_Position,TWolf_One,T,TW,q,workT,v_max,D);
        Insert(Insert==Point)=[];
    end
     if numel(Infeasible_point)>0  
        [ TWolf_One ] = Infeasible_Deal(Infeasible_point,TWolf_One,Q,q,T,TW,workT,D,v_max);
     end
    InsertWeight_matrix(1,4)=InsertWeight_matrix(1,4)+1;
    CHARU=4;
elseif select<=R_LP(5)
     while numel(Insert)>0
          [Point,KeChaRuDian ] = Feasibility_judgment( Insert,TWolf_One,Q,q,T,TW,workT );
         if  size(KeChaRuDian,2)==0 
             Infeasible_point=[Infeasible_point,Point];
         else
             [Insert,TWolf_One]=Insert_TL( Point,TWolf_One,Insert,KeChaRuDian,D,q,T,TW,workT,v_max,Q);
         end
         Insert(Insert==Point)=[];
     end
    if numel(Infeasible_point)>0 
       [ TWolf_One ] = Infeasible_Deal(Infeasible_point,TWolf_One,Q,q,T,TW,workT,D,v_max);
    end
    InsertWeight_matrix(1,5)=InsertWeight_matrix(1,5)+1;
    CHARU=5;
end
end

