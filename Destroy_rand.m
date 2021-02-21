function [ c,b,Insert,TWolf_One] = Destroy_rand( TanWolf_Rand,n,Insert)
b=TanWolf_Rand{1};
c=b;
Long=[round(0.15*length(n)):round(0.2*length(n))];
number_Loca=Long(randperm(numel(Long),1));
Insert=randperm(length(n),number_Loca);
for i=1:length(Insert)
    b(b==Insert(i))=[];
end
TWolf_One=TanWolf_Rand;
TWolf_One{1}=b;
end

