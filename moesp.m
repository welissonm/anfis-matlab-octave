% Function moeps.m
% algoritmo retirado do livro Subspace Methods for System Identification,
% pag:350 referente a Tabela D.2. MOESP method algorithm
% Lemma 6.6
% m = dim(u), p = dim(y), n = dim(x); k = number of block rows
% U = km x N input data matrix
% Y = kp x N output data matrix
function [A,B,C,D] = moesp(U,Y,m,p,n,k)
km = size(U,1); kp = size(Y,1);
L = triu(qr([U;Y]'))'; % LQ decomposition
[Q,R] = qr([U;Y]',0);
Q = Q'; L2 = R';
Q1t = Q(1:km,:);
Q2t = Q(1:kp,:);
L11 = L(1:km,1:km);
L21 = L(km+1:km+kp,1:km);
L22 = L(km+1:km+kp,km+1:km+kp);
[UU,SS,VV] = svd(L22); % Eq. (6.39)
U1 = UU(:,1:n); % n is known
Ok = U1*sqrtm(SS(1:n,1:n));
% Matrices A and C
C = Ok(1:p,1:n); % Eq. (6.41)
A = pinv(Ok(1:p*(k-1),1:n))*Ok(p+1:p*k,1:n); % Eq. (6.42)
% Matrices B and D
U2 = UU(:,n+1:size(UU',1));
Z = U2'*L21/L11;
XX = []; RR = [];
for j = 1:k
XX = [XX; Z(:,m*(j-1)+1:m*j)];
Okj = Ok(1:p*(k-j),:);
Rj = [zeros(p*(j-1),p) zeros(p*(j-1),n);
eye(p) zeros(p,n); zeros(p*(k-j),p) Okj];
RR = [RR; U2'*Rj];
end
DB = pinv(RR)*XX; % Eq. (6.44)
D = DB(1:p,:);
B = DB(p+1:size(DB,1),:);
end