function [ TanWolf_Son ] = Speed_optimization(TanWolf_Son,v_min,v_mid,v_max,TW,D,workT )
v_Set=[v_min,v_mid,v_max];
All_wolf_son=size(TanWolf_Son,1);
Gene=TanWolf_Son(:,1);
Dao_Wait_Time=TanWolf_Son(:,4);
Ever_Vehicle_Time=TanWolf_Son(:,5); 
Ever_arc_Speed=TanWolf_Son(:,8);
wolf=1;
while wolf<=All_wolf_son
    Location_0=find(Gene{wolf}==0);
    EveryVehicle_Gene=cell(numel(Location_0)-1,1);
    EveryVehicle_Dao_Wait_Time=cell(numel(Location_0)-1,1);
    EveryVehicle_V=cell(numel(Location_0)-1,1);
    EverVehicle_UseTime=Ever_Vehicle_Time{wolf};
    for i=1: numel(Location_0)-1
        EveryVehicle_Gene{i}=Gene{wolf}(Location_0(i):Location_0(i+1));
        EveryVehicle_Dao_Wait_Time{i}=Dao_Wait_Time{wolf}(:,Location_0(i):Location_0(i+1)-1);
        EveryVehicle_V{i}=Ever_arc_Speed{wolf}(Location_0(i):Location_0(i+1)-1);
    end
    DanChe_KeXing_Speed_OLD={};
    for i_i=1:size(EveryVehicle_Gene,1)  
        gen_Vehicle=EveryVehicle_Gene{i_i};
        Wait_Position=find(EveryVehicle_Dao_Wait_Time{i_i}(2,:)~=0);
        if ~isempty(Wait_Position)
            use_Time=zeros(2,Wait_Position(end)-1);
            for i_i_i=1:Wait_Position(end)-1
                use_Time(1,i_i_i)=EveryVehicle_Dao_Wait_Time{i_i}(2,i_i_i+1);
                if use_Time(1,i_i_i)>0
                   use_Time(2,i_i_i)=TW(gen_Vehicle(i_i_i+1)+1,2)-TW(gen_Vehicle(i_i_i+1)+1,1);
                else
                    use_Time(2,i_i_i)=TW(gen_Vehicle(i_i_i+1)+1,2)-EveryVehicle_Dao_Wait_Time{i_i}(1,i_i_i);
                end  
            end
            for Change=1:Wait_Position(end)-1
                distance=D(gen_Vehicle(Change)+1,gen_Vehicle(Change+1)+1);
                v_N=EveryVehicle_V{i_i}(Change);
                v=v_Set;v(v==v_N)=[];
                Delta_time=zeros(1,length(v));
                V_SAVE=zeros(1,length(v));
                for v_Change=1:length(v)
                    Delta_time(v_Change)=distance*(v_N-v(v_Change))/(v_N*v(v_Change));
                    use_Time_B=use_Time;
                    for column=Change:size(use_Time_B,2)
                        if Delta_time(v_Change)<=use_Time_B(1,column)
                               V_SAVE(v_Change)=v(v_Change);
                               use_Time_B(1,column)=use_Time_B(1,column)-Delta_time(v_Change);
                               break
                        elseif Delta_time(v_Change)>use_Time_B(1,column)&&Delta_time(v_Change)-use_Time_B(1,column)>use_Time_B(2,column)
                               break
                        elseif Delta_time(v_Change)>use_Time_B(1,column)&&Delta_time(v_Change)-use_Time_B(1,column)<=use_Time_B(2,column)
                            if Change==Wait_Position(end)-1
                               break  
                            else
                                if use_Time_B(1,column)==0
                                   use_Time_B(2,column)=use_Time_B(2,column)-Delta_time(v_Change);
                                else
                                    Delta_time(v_Change)=Delta_time(v_Change)-use_Time_B(1,column);
                                    use_Time_B(1,column)=0;
                                    use_Time_B(2,column)=Delta_time(v_Change);
                                end                          
                            end
                        end
                    end
                    use_Time_C{v_Change,1}=v(v_Change);
                    use_Time_C{v_Change,2}=use_Time_B;
                end
                v_select=min(V_SAVE(V_SAVE>0));
                if numel(v_select)>0
                   EveryVehicle_V{i_i}(Change)=v_select;
                   [M_M,~] = find(cellfun(@(x) ismember(v_select,x),use_Time_C));
                end
                use_Time=use_Time_C{M_M,2};
            end
            ArrivalWait_SinglePoint=EveryVehicle_Dao_Wait_Time(i_i);
            Arc_SinglePoint=cell2mat(EveryVehicle_V(i_i));
            [ DanChe_KeXing_Speed_SON ] = No_WaitTime_Point(TW,D,workT,v_Set,gen_Vehicle,Wait_Position,Arc_SinglePoint,ArrivalWait_SinglePoint);
            DanChe_KeXing_Speed_SON(:,end+1)=num2cell(1:size(DanChe_KeXing_Speed_SON,1));
            DanChe_KeXing_Speed_OLD(end+1:end+size(DanChe_KeXing_Speed_SON,1),:)=DanChe_KeXing_Speed_SON;
        else
             ArrivalWait_SinglePoint=EveryVehicle_Dao_Wait_Time(i_i);
            Arc_SinglePoint=cell2mat(EveryVehicle_V(i_i));
            [ DanChe_KeXing_Speed_SON ] = complete_No_WaitTime_Point( TW,D,workT,v_Set,gen_Vehicle,Arc_SinglePoint,ArrivalWait_SinglePoint );
            DanChe_KeXing_Speed_SON(:,end+1)=num2cell(1:size(DanChe_KeXing_Speed_SON,1));
            DanChe_KeXing_Speed_OLD(end+1:end+size(DanChe_KeXing_Speed_SON,1),:)=DanChe_KeXing_Speed_SON;
        end
    end 
[ TanWolf_Son ] = KeXingJieZuHe( DanChe_KeXing_Speed_OLD );
    wolf=wolf+1;
end
end





