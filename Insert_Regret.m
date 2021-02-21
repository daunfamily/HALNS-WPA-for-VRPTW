function [Regret,All_information,Insert,TWolf_One ] = Insert_Regret(Point,TWolf_One,Insert,KeChaRuDian,D,q )
b=TWolf_One{1};
Location_0=find(b==0);
k=cell(numel(Location_0)-1,1);
for i=1:numel(Location_0)-1
    k{i}=b(Location_0(i):Location_0(i+1));
end
Increase_distance=zeros(1,size(KeChaRuDian,2));
for i=1:size(KeChaRuDian,2)
    JiYin=k{KeChaRuDian(1,i)};
    Increase_distance(i)=D(JiYin(KeChaRuDian(2,i))+1,Point+1)+D(Point+1,JiYin(KeChaRuDian(2,i)+1)+1)-D(JiYin(KeChaRuDian(2,i))+1,JiYin(KeChaRuDian(2,i)+1)+1);
end
All_information=[KeChaRuDian',Increase_distance'];
All_information=sortrows(All_information,3);
Regret=0;
for i=1:size(All_information,1)
    Regret=Regret+All_information(i,3)-All_information(1,3);
    if i==3
        break;
    end
end
end

