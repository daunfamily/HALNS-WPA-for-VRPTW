function [pRank,SetDominamt,NumDom] = fastNonDominatedSort(A,CompIndex)
if (nargin < 2) || (isempty(CompIndex)), CompIndex = ones(1,size(A,2)); end
N = size(A,1);                                             % �����������Ŀ
SetDominamt = cell(1,N);                         % ���и����֧�伯�������е�S_p
NumInSetD = zeros(1,N);                          % ���и����֧�伯�еĸ�������
NumDominated = zeros(1,N);                       % ���и��屻����������֧�������:�����е�n_p
pRank = zeros(1,N);                                        % ���и�������ǰ��front����ţ������е�p_rank
Front1 = [];
for ii = 1:N
    Sp = [];                                       % ��ʱ�洢�ĵ�ii�������֧�伯(ʵ��Ϊ��֧��ĸ����ż���)
    for jj = 1:N                                 % ������N-1������Ƚϣ���֧�仹�Ǳ�֧��
        Index = Dominant2VecMin(A(ii,:),A(jj,:),CompIndex);
        if Index == 1                            % ����ii֧�����jj
            Sp = [Sp jj];                         % ������jj������֧�伯
            NumInSetD(ii) = NumInSetD(ii) + 1;
        elseif Index == -1                       % ����jj֧�����ii(ii��jj֧��)
            NumDominated(ii) = NumDominated(ii) + 1; % ii��֧����������1
        end
    end
    SetDominamt{ii} = Sp;
    
    if NumDominated(ii) == 0                     % iiû�б���������֧��
        pRank(ii) = 1;                              % ����ii���ڵ�һ��ǰ�أ�first front
        Front1 = [Front1,ii];                    % ������ii�����һ��ǰ��
    end
end
NumDom = NumDominated;                           % �����仯�����ΪNumDom�Ա����
curFrontID = 1;                                              % ��ǰ�����ǰ�ر�ţ������е�i=1
CurFront = Front1;                                         % ��ǰ�����ǰ�أ������е�F_i
NumInFront = length(CurFront);                   % ��ǰǰ���еĸ�������
while NumInFront > 0                             % ��ǰ��curFrontIDǰ�طǿ�
    Q = [];                                                 % �����洢��һ��ǰ����������ļ�������
    for ii = 1:NumInFront                        % �Ե�ǰǰ��F_i�е�ÿһ��p�����б�
        pInFront = CurFront(ii);                 % �����е� p ���� F_i
        Sp = cell2mat(SetDominamt(pInFront));    % p��֧�伯
        for jj = 1:NumInSetD(pInFront)
            qID = Sp(jj);                                        % �����е� q ���� S_p
            NumDominated(qID) = NumDominated(qID) - 1; % �����е� n_q = n_q - 1
            if NumDominated(qID) == 0            % q������һ��ǰ��
                pRank(qID) = curFrontID + 1;     % ������q��ǰ�صȼ�ֵ
                Q = [Q,qID];                                 % ������q������һǰ�ؼ�
            end
        end
    end
    curFrontID = curFrontID + 1;                 % ����һ��ǰ����Ÿ�ֵ
    CurFront = Q;                                         % ȷ����һ��ǰ����������(���)
    NumInFront = length(Q);                      % ��ǰǰ��������������
end
% end of function fastNonDominatedSort
%%
