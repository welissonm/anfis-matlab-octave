% Program
% LQ decomposition
function [L,Q,L11,L21,L22,Q1t,Q2t]=lq(U,Y)
km=size(U,1); kp=size(Y,1);
N = size(U);
[Q,L]=qr([U;Y]',0);
Q=Q'; L=L';
L11=L(1:km,1:km);
L21=L(km+1:km+kp,1:km);
L22=L(km+1:km+kp,km+1:km+kp);
Q1t = Q(1:km,:);
Q2t = Q(km+1:km+kp,:);
end