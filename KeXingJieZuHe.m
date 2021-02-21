function [ TanWolf_Son ] = KeXingJieZuHe( DanChe_KeXing_Speed_OLD )
KeYongZuHe=size(DanChe_KeXing_Speed_OLD,1);
DanChe_KeXing_Speed_OLD(:,end+1)=num2cell(1:KeYongZuHe);
PaiLie=1;
ZuHe=cell(1,length(find(DanChe_KeXing_Speed_OLD{:,5}=[1])));
for PaiLie_i=1:size(DanChe_KeXing_Speed_OLD,1) 
    if DanChe_KeXing_Speed_OLD{PaiLie_i,5}==1
        ZuHe{PaiLie}=[ZuHe{PaiLie},DanChe_KeXing_Speed_OLD{PaiLie_i,6}];
        if PaiLie_i+1>KeYongZuHe&&DanChe_KeXing_Speed_OLD{PaiLie_i+1,5}==1
            PaiLie=PaiLie+1;          
        end
    else
        ZuHe{PaiLie}=[ZuHe{PaiLie},DanChe_KeXing_Speed_OLD{PaiLie_i,6}];
        PaiLie=PaiLie+1; 
    end    
end
TanWolf_Son=ZuHe;
end

