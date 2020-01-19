%%  teste com consequêntes sendo espaco de estado
clear
clc
close all

loadDependencies();
path = path_src('.\dados\stiction.csv');
%1 - time, 2 - SP, 3 - PV e 4 - OP
data.All = dlmread(path,';',1,0);
y  = data.All(:,3);
u = data.All(:,4);
t =  data.All(:,1);
y = (1/4)*y; %normallizando a PV para ficar 0-100%
%plot(t,y);
d = y;
k = 26;
N = 800;
n = 2;
opt.noiseinput = 'K';
opt.algorithm = 'Q';
U = hankel(u(1:k),u(k:k+N));
Y = hankel(y(1:k),y(k:k+N));
[Atil,Btil,Ctil,Dtil] = moesp(U,Y,1,1,4,k);
sys = ss(Atil,Btil,Ctil,Dtil,1);
idata = iddata(y,u,1.0);
[sys2 X0, info] = n4sid(idata,4,opt);
[y2, t2, states2] = lsim(sys2,[u,y],t,X0);
erro = y-y2;
mse = (1/length(y))*sum(erro.^2);
%step(sys);
deltaY = [0; y(2:end,:) - y(1:end-1,:)];
deltaU = [u(1,:); u(2:end,:) - u(1:end-1,:)];
U = hankel(deltaU(1:k),deltaU(k:k+N));
Y = hankel(deltaY(1:k),deltaY(k:k+N));
[Atil,Btil,Ctil,Dtil] = moesp(U,Y,1,1,4,k);
sys = ss(Atil,Btil,Ctil,Dtil,1);
step(sys);
[y2,t2,states2] = lsim(sys,u,t);
plot(t2,d,t2,y2);

