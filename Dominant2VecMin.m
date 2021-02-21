function Index = Dominant2VecMin(v1,v2,CompIndex)
if (nargin < 3) || (isempty(CompIndex)), CompIndex = ones(size(v1)); 
end
n = length(v1);
V1 = v1 .* CompIndex;
V2 = v2 .* CompIndex;
num1 = sum(V1 <= V2);
num2 = sum(V1 < V2);
equalNum = num1 - num2;
num3 = sum(V1 > V2);
if (num3 > 0) && ((equalNum + num3) == n)
    Index = -1;
elseif (num2 > 0) && ((equalNum + num2) == n)
    Index = 1;
else
    Index = 0;
end