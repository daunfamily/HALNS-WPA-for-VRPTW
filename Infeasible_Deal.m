function [ TWolf_One ] = Infeasible_Deal(Infeasible_point,TWolf_One,Q,q,T,TW,workT,D,v_max)
Infeasible_point = unique(Infeasible_point);
JiYin=TWolf_One{1};
ZhuangZai=TWolf_One{2};
DanCheJuLi=TWolf_One{3};
ShiJian_DW=TWolf_One{4};
DanCheYongShi=TWolf_One{5};
if length(Infeasible_point) == 1
    JiYin=[JiYin,Infeasible_point,0];
    ZhuangZai=[ZhuangZai,q(Infeasible_point+1)];
    DanCheJuLi=[DanCheJuLi,D(1,Infeasible_point+1)*2];
    ShiJian_DW(1,end+1)=0;ShiJian_DW(2,end)=0;
    ShiJian_DW(1,end+1)=T(1,Infeasible_point+1);
    if ShiJian_DW(1,end)<TW(Infeasible_point+1,1)
        ShiJian_DW(2,end)=TW(Infeasible_point+1,1)-ShiJian_DW(1,end);
    end
    DanCheYongShi=[DanCheYongShi,sum(ShiJian_DW(:,end))+workT(Infeasible_point+1)+T(Infeasible_point+1,1)];
    TWolf_One{7}=TWolf_One{7}+1;
    ppp=zeros(1,length(Infeasible_point)+1);
    ppp(:)=v_max;
    TWolf_One{8}=[TWolf_One{8},ppp];
    TWolf_One{10}=[TWolf_One{10},(1.6+0.2*(q(Infeasible_point+1)/Q))*0.174*450*(22^2/27^3)*D(1,Infeasible_point+1)+0.174*450*(22^3/27^3)*0.4*workT(Infeasible_point+1)];
    TWolf_One{11}=sum(TWolf_One{10});
else
    rand_num=randperm(length(Infeasible_point));
    first_Insert_point=Infeasible_point(rand_num(1));
    LinShi=cell(1,3);
    LinShi{1}=[0,first_Insert_point,0];
    LinShi{2}=2*D(1,first_Insert_point+1);
    LinShi{3}=q(first_Insert_point+1);
    Infeasible_point(Infeasible_point==first_Insert_point)=[];
    while ~isempty(Infeasible_point)
        LinShi_Save=zeros(length(Infeasible_point),4);
        tom=1;
        while tom<=numel(Infeasible_point)
            tom_point=Infeasible_point(tom);
            [ tom_point,Plan_Insert_Position ] = Xiufu_Kecheru_judge(tom_point,LinShi,D,Q,q,T,TW,workT );
            LinShi_Save(tom,1)=tom_point;
            if isempty(Plan_Insert_Position)
                 LinShi_Save(tom,2:end)=0;
            else
                 LinShi_Save(tom,2:end)=Plan_Insert_Position;
            end
            tom=tom+1;
        end
        LinShi_Save=sortrows(LinShi_Save,4);
        if  LinShi_Save(1,2)==0 
            LinShi{size(LinShi,1)+1,1}=[0,LinShi_Save(1,1),0];
            LinShi{end,2}=2*D(1,LinShi_Save(1,1)+1);
            LinShi{end,3}=q(LinShi_Save(1,1)+1);
            Infeasible_point(Infeasible_point==LinShi_Save(1,1))=[];
            LinShi_Save(1,:)=[];
        else
            LinShi{LinShi_Save(1,2),1}=[LinShi{LinShi_Save(1,2),1}(1:LinShi_Save(1,3)),LinShi_Save(1,1),LinShi{LinShi_Save(1,2),1}(LinShi_Save(1,3)+1:end)];
            LinShi{LinShi_Save(1,2),2}=LinShi{LinShi_Save(1,2),2}+LinShi_Save(1,end);
            LinShi{LinShi_Save(1,2),3}=LinShi{LinShi_Save(1,2),3}+q(LinShi_Save(1,1)+1);
            Infeasible_point(Infeasible_point==LinShi_Save(1,1))=[];
        end
    end
    Hang=size(LinShi,1);
    for jj=1:Hang 
        JiYin=[JiYin,LinShi{jj,1}(2:end)];
        ZhuangZai=[ZhuangZai,LinShi{jj,3}];
        DanCheJuLi=[DanCheJuLi,LinShi{jj,2}];
        LinShi_JiYin=LinShi{jj,1};
        LinShi_ShiJian_DW=zeros(2,length(LinShi_JiYin)-1);
        for ji=2:length(LinShi_JiYin)-1
            LinShi_ShiJian_DW(1,ji)=sum(LinShi_ShiJian_DW(:,ji-1))+workT(LinShi_JiYin(ji-1)+1)+T(LinShi_JiYin(ji-1)+1,LinShi_JiYin(ji)+1);
            if LinShi_ShiJian_DW(1,ji)<TW(LinShi_JiYin(ji+1)+1,1)
                LinShi_ShiJian_DW(2,ji)=TW(LinShi_JiYin(ji+1),1)-LinShi_ShiJian_DW(1,ji);
            end
        end
        ShiJian_DW=[ShiJian_DW,LinShi_ShiJian_DW];
        DanCheYongShi=[DanCheYongShi,sum(LinShi_ShiJian_DW(:,end))+workT(LinShi_JiYin(end-1)+1)+T(LinShi_JiYin(end-1)+1,1)];%单车总用时
        ppp=zeros(1,length(LinShi_JiYin)-1);
        ppp(:)=v_max;
        TWolf_One{8}=[TWolf_One{8},ppp];
    end
    TWolf_One{7}=TWolf_One{7}+Hang;
   for Veh_Oil_1=1:Hang
        Increase_Veh_Oil=0;
        Veh_Weight=0;
        for Veh_Oil_2=1:numel(LinShi{Veh_Oil_1,1})-1
            Veh_Weight=Veh_Weight+q(LinShi{Veh_Oil_1,1}(Veh_Oil_2)+1);
            Increase_Veh_Oil=Increase_Veh_Oil+(0.8+0.2*(Veh_Weight/Q))*0.174*450*((22^2)/(27^3))*D(LinShi{Veh_Oil_1,1}(Veh_Oil_2)+1,LinShi{Veh_Oil_1,1}(Veh_Oil_2+1)+1)+0.174*450*((22^3)/(27^3))*0.4*workT(LinShi{Veh_Oil_1,1}(Veh_Oil_2)+1);
        end
        TWolf_One{10}=[TWolf_One{10},Increase_Veh_Oil];
   end
    TWolf_One{11}=sum(TWolf_One{10});
end    
ZongXingCheng=sum(DanCheJuLi);
TWolf_One{1}=JiYin;
TWolf_One{2}=ZhuangZai;
TWolf_One{3}=DanCheJuLi;
TWolf_One{4}=ShiJian_DW;
TWolf_One{5}=DanCheYongShi;
TWolf_One{6}=ZongXingCheng;
end

