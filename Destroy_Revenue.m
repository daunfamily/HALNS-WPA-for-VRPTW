function [ c,b,Insert,TWolf_One] = Destroy_Revenue( Insert,TanWolf_Rand,n,D )
c=TanWolf_Rand{1};
c_Delet=c;
i=1;
while i<=length(c_Delet)-1
    if c(i)==0
        c_Delet(2,i)=0;
        i=i+1;
    end
    c_Delet(2,i)=D(c_Delet(1,i-1)+1,c_Delet(1,i)+1)+D(c_Delet(1,i)+1,c_Delet(1,i-1)+1)-D(c_Delet(1,i-1)+1,c_Delet(1,i+1)+1);
    i=i+1;
end
Long=[round(0.15*length(n)):round(0.2*length(n))];
number_Loca=Long(randperm(numel(Long),1));
while numel(Insert)<number_Loca 
    Sort_c_Delet=fliplr(sortrows(c_Delet',2)');
    Insert=[Insert,Sort_c_Delet(1,1)];
    Point=find(c_Delet(1,:)==Insert(end));
    if c_Delet(1,Point-1)==0
        if c_Delet(1,Point+1)==0
            c_Delet(:,Point)=[];
        else
            c_Delet(2,Point+1)=D(c_Delet(1,Point-1)+1,c_Delet(1,Point+1)+1)+D(c_Delet(1,Point+1)+1,c_Delet(1,Point+2)+1)-D(c_Delet(1,Point-1)+1,c_Delet(1,Point+2)+1);
            c_Delet(:,Point)=[];
        end
    elseif c_Delet(1,Point+1)==0
        c_Delet(2,Point-1)=D(c_Delet(1,Point-2)+1,c_Delet(1,Point-1)+1)+D(c_Delet(1,Point-1)+1,c_Delet(1,Point+1)+1)-D(c_Delet(1,Point-2)+1,c_Delet(1,Point+1)+1);
        c_Delet(:,Point)=[];
    else
        c_Delet(2,Point+1)=D(c_Delet(1,Point-1)+1,c_Delet(1,Point+1)+1)+D(c_Delet(1,Point+1)+1,c_Delet(1,Point+2)+1)-D(c_Delet(1,Point-1)+1,c_Delet(1,Point+2)+1);
        c_Delet(2,Point-1)=D(c_Delet(1,Point-2)+1,c_Delet(1,Point-1)+1)+D(c_Delet(1,Point-1)+1,c_Delet(1,Point+1)+1)-D(c_Delet(1,Point-2)+1,c_Delet(1,Point+1)+1);
        c_Delet(:,Point)=[];
    end
end
b=c_Delet(1,:);
TWolf_One=TanWolf_Rand;
TWolf_One{1}=b;
end

