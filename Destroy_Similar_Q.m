function [ c,b,Insert,TWolf_One ] = Destroy_Similar_Q( TanWolf_Rand,n,Insert,q,T,TW,D )
A=0;B=1;C=0;E=0;
b=TanWolf_Rand{1};
c=b;
cc=randi(length(n));
Insert=n(cc);
b(b==n(cc))=[];n(cc)=[];
Long=[round(0.15*length(n)):round(0.2*length(n))];
number_Loca=Long(randperm(numel(Long),1));
while length(Insert)<number_Loca
cc=Insert(randi(length(Insert)));
sim=zeros(1,numel(n));
for i=1:length(n)
    if ismember(0,b(find(b==cc):find(b==i)))==1
        v=1;
    else
        v=0;
    end
    sim(i)=A*D(cc+1,n(i)+1)+B*abs(q(cc+1)-q(n(i)+1))+C*(abs(TW(cc+1,1)-TW(n(i)+1,1))+abs(TW(cc+1,2)-TW(n(i)+1,2)))+E*v;
end
[~,index]=min(sim);
Insert=[Insert,n(index)];
b(b==n(index))=[];n(index)=[];
end
TWolf_One=TanWolf_Rand;
TWolf_One{1}=b;
end

