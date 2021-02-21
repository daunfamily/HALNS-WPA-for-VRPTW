function [pRank,SetDominamt,NumDom] = fastNonDominatedSort(A,CompIndex)
if (nargin < 2) || (isempty(CompIndex)), CompIndex = ones(1,size(A,2)); end
N = size(A,1);                                             % 个体或样本数目
SetDominamt = cell(1,N);                         % 所有个体的支配集：论文中的S_p
NumInSetD = zeros(1,N);                          % 所有个体的支配集中的个体数量
NumDominated = zeros(1,N);                       % 所有个体被其他个体所支配的数量:论文中的n_p
pRank = zeros(1,N);                                        % 所有个体所在前沿front的序号：论文中的p_rank
Front1 = [];
for ii = 1:N
    Sp = [];                                       % 临时存储的第ii个个体的支配集(实际为所支配的个体编号集合)
    for jj = 1:N                                 % 和其他N-1个个体比较，是支配还是被支配
        Index = Dominant2VecMin(A(ii,:),A(jj,:),CompIndex);
        if Index == 1                            % 个体ii支配个体jj
            Sp = [Sp jj];                         % 将个体jj加入其支配集
            NumInSetD(ii) = NumInSetD(ii) + 1;
        elseif Index == -1                       % 个体jj支配个体ii(ii被jj支配)
            NumDominated(ii) = NumDominated(ii) + 1; % ii被支配数量递增1
        end
    end
    SetDominamt{ii} = Sp;
    
    if NumDominated(ii) == 0                     % ii没有被其他个体支配
        pRank(ii) = 1;                              % 个体ii属于第一级前沿：first front
        Front1 = [Front1,ii];                    % 将个体ii加入第一级前沿
    end
end
NumDom = NumDominated;                           % 后面会变化，另存为NumDom以便输出
curFrontID = 1;                                              % 当前处理的前沿编号：论文中的i=1
CurFront = Front1;                                         % 当前处理的前沿：论文中的F_i
NumInFront = length(CurFront);                   % 当前前沿中的个体数量
while NumInFront > 0                             % 当前第curFrontID前沿非空
    Q = [];                                                 % 用来存储下一级前沿所含个体的集合容器
    for ii = 1:NumInFront                        % 对当前前沿F_i中的每一个p进行判别
        pInFront = CurFront(ii);                 % 论文中的 p 属于 F_i
        Sp = cell2mat(SetDominamt(pInFront));    % p的支配集
        for jj = 1:NumInSetD(pInFront)
            qID = Sp(jj);                                        % 论文中的 q 属于 S_p
            NumDominated(qID) = NumDominated(qID) - 1; % 论文中的 n_q = n_q - 1
            if NumDominated(qID) == 0            % q属于下一级前沿
                pRank(qID) = curFrontID + 1;     % 给个体q赋前沿等级值
                Q = [Q,qID];                                 % 将个体q加入下一前沿集
            end
        end
    end
    curFrontID = curFrontID + 1;                 % 给下一级前沿序号赋值
    CurFront = Q;                                         % 确定下一级前沿所含个体(编号)
    NumInFront = length(Q);                      % 当前前沿所含个体数量
end
% end of function fastNonDominatedSort
%%
