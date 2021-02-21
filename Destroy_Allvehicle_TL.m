function [ c,b,Insert,TWolf_One ] = Destroy_Allvehicle_TL( TanWolf_Rand,n,Insert,q,T,D )
Gen=TanWolf_Rand{1};
c=Gen;
Location_0=find(Gen==0);
k_TL=cell(numel(Location_0)-1,1);
for i=1:numel(Location_0)-1
    k_TL{i}=Gen(Location_0(i):Location_0(i+1));
end
ALL_TL=zeros(1,numel(Location_0)-1);
for i=1:numel(Location_0)-1
    WeiZhi=1:numel(k_TL{i})-2;
    ALL_TL(i)=(WeiZhi*q(k_TL{i}(2:end-1)+1))/((numel(k_TL{i})-2)*TanWolf_Rand{2}(i));
end
[~,Del_VE]=min(ALL_TL);
Insert=c(Location_0(Del_VE)+1:Location_0(Del_VE+1)-1);
b=c;
b(Location_0(Del_VE)+1:Location_0(Del_VE+1)-1)=[];
TWolf_One=TanWolf_Rand;
TWolf_One{1}=b;
end

