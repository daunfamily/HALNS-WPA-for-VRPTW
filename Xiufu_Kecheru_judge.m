function [ tom_point,Plan_Insert_Position ] = Xiufu_Kecheru_judge(tom_point,LinShi,D,Q,q,T,TW,workT)
Capacity_infeasible=[];
Point=tom_point;
i=1;
while i<=size(LinShi,1)
     member=LinShi{i,1};
    j=1;
    ShiCha=zeros(2,numel(member));
    while j<=length(member)
        cg=numel(member)-j+1;
        if j==1
            ShiCha(1,j)=0;
            ShiCha(2,cg)=TW(member(cg)+1,2);
            j=j+1;
            continue;
        end
        ShiCha(1,j)=max(TW(member(j)+1,1)+workT(member(j)+1),ShiCha(1,j-1)+T(member(j-1)+1,member(j)+1)+workT(member(j)+1));
        if ShiCha(2,cg+1)==0
            ShiCha(2,cg)=TW(member(cg)+1,2);
        else
            ShiCha(2,cg)=min(TW(member(cg)+1,2),ShiCha(2,cg+1)-T(member(cg)+1,member(cg+1)+1)-workT(member(cg)+1));
        end        
        j=j+1;
    end
    if i==1
        LinShi{i,end+1}=ShiCha;
    else
        LinShi{i,end}=ShiCha;
    end
    i=i+1;
end
V_Q=cell2mat(LinShi(:,3));
i=1;
while i<=numel(V_Q)
    if q(Point+1)+V_Q(i)>Q
        Capacity_infeasible=[Capacity_infeasible,i];
    end
    i=i+1;
end
KeChaRu_Information=[];
i=1;
while i<=size(LinShi,1)
    if ismember(i,Capacity_infeasible)==1
       i=i+1;
       continue;
    end
    JiYin=LinShi{i,1};
    ShiCha=LinShi{i,end};
    for j=1:numel(JiYin)-1
        EF_Point=max(TW(Point+1,1)+workT(Point+1),ShiCha(1,j)+T(JiYin(j)+1,Point+1)+workT(Point+1));
        if EF_Point-workT(Point+1)<=TW(Point+1,2)
            TD=ShiCha(2,j+1)-ShiCha(1,j);
            wait_Point=max(0,TW(Point+1,1)-ShiCha(1,j)-T(JiYin(j)+1,Point+1));
            TD_shijian=T(JiYin(j)+1,Point+1)+workT(Point+1)+T(Point+1,JiYin(j+1)+1)+wait_Point;
            if TD>=TD_shijian
                ppp=[i;j];
                KeChaRu_Information=[KeChaRu_Information,ppp];
            else
                continue;
            end
        else
            continue;
        end
    end
    i=i+1;
end
Increase_distance=zeros(1,size(KeChaRu_Information,2));
for i=1:size(KeChaRu_Information,2)
    JiYin=LinShi{KeChaRu_Information(1,i)};
    Increase_distance(i)=D(JiYin(KeChaRu_Information(2,i))+1,Point+1)+D(Point+1,JiYin(KeChaRu_Information(2,i)+1)+1)-D(JiYin(KeChaRu_Information(2,i))+1,JiYin(KeChaRu_Information(2,i)+1)+1);
end
[Improve,where]=min(Increase_distance);
if ~isempty(KeChaRu_Information)
   Plan_Insert_Position=[KeChaRu_Information(1,where),KeChaRu_Information(2,where),Improve]; 
else
    Plan_Insert_Position=[];
end
end