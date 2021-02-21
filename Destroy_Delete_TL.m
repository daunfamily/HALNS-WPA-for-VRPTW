function [ c,b,Insert,TWolf_One ] = Destroy_Delete_TL( TanWolf_Rand,n,Insert,q,T,D )
Gen=TanWolf_Rand{1};
c=Gen;
Location_0=find(Gen==0);
k_TL=cell(numel(Location_0)-1,1);
for i=1:numel(Location_0)-1
    k_TL{i}=Gen(Location_0(i):Location_0(i+1));
end
ALL_TL=zeros(1,numel(Location_0)-1);
Rate_change=zeros(2,numel(n));
Pointer=1;
for i=1:numel(Location_0)-1
    WeiZhi=[1:numel(k_TL{i})-2];
    ALL_TL(i)=(WeiZhi*q(k_TL{i}(2:end-1)+1))/((numel(k_TL{i})-2)*TanWolf_Rand{2}(i));
    for j=2:numel(k_TL{i})-1  
        LinShi=k_TL{i};
        Rate_change(1,Pointer)=LinShi(j);
        LinShi(j)=[];
        if numel(LinShi)>2 
            WeiZhi=[1:numel(LinShi)-2];
            Rate_change(2,Pointer)=(((WeiZhi*q(LinShi(2:end-1)+1))/(WeiZhi(end)*sum(q(LinShi(2:end-1)+1))))-ALL_TL(i))/ALL_TL(i);
        end
        Pointer=Pointer+1;
    end
end
Rate_change=sortrows(Rate_change',-2);
Long=[round(0.15*length(n)):round(0.2*length(n))];
number_Loca=Long(randperm(numel(Long),1));
Insert=(Rate_change(1:number_Loca,1))';
for cc=1:length(Insert) 
    Gen(find(Gen==Insert(cc)))=[];
end
TWolf_One=TanWolf_Rand;
b=Gen;
TWolf_One{1}=b;
end

