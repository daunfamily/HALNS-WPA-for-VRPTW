function [KeChaRuDian ] = Feasibility_judgment_lianxu( Point,Insert,TWolf_One,Q,q,T,TW,workT )
Operate_One=TWolf_One;
b=Operate_One{1};
Location_0=find(b==0);
Capacity_infeasible=[];
k=cell(numel(Location_0)-1,1);
for i=1:numel(Location_0)-1
    k{i}=b(Location_0(i):Location_0(i+1));
end
i=1;
while i<=numel(Location_0)-1
     member=k{i};
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
    k{i,2}=ShiCha;
    i=i+1;
end
V_Q=TWolf_One{2};
i=1;
while i<=numel(V_Q)
    if q(Point+1)+V_Q(i)>Q
        Capacity_infeasible=[Capacity_infeasible,i];
    end
    i=i+1;
end
KeChaRuDian=[];
i=1;
while i<=numel(Location_0)-1
    if ismember(i,Capacity_infeasible)==1
       i=i+1;
       continue;
    end
    JiYin=k{i,1};
    ShiCha=k{i,2};
    for j=1:numel(JiYin)-1
        EF_Point=max(TW(Point+1,1)+workT(Point+1),ShiCha(1,j)+T(JiYin(j)+1,Point+1)+workT(Point+1));
        if EF_Point-workT(Point+1)<=TW(Point+1,2)
            TD=ShiCha(2,j+1)-ShiCha(1,j);
            wait_Point=max(0,TW(Point+1,1)-ShiCha(1,j)-T(JiYin(j)+1,Point+1));
            TD_shijian=T(JiYin(j)+1,Point+1)+workT(Point+1)+T(Point+1,JiYin(j+1)+1)+wait_Point;
            if TD>=TD_shijian
                ppp=[i;j];
                KeChaRuDian=[KeChaRuDian,ppp];
            else
                continue;
            end
        else
            continue;
        end
    end
    i=i+1;
end
end

