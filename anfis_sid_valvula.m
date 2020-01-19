clear all
clc
close all

loadDependencies();
path = path_src('.\dados\stiction.csv');
%1 - time, 2 - SP, 3 - PV e 4 - OP
data.All = dlmread(path,';',1,0);
y  = data.All(:,3);
u = data.All(:,4);
t =  data.All(:,1);
%y = (1/4)*y; %normallizando a PV para ficar 0-100%
%plot(t,y);
d = y(2:end,1);
u = u(2:end,1);
x = [d, y(2:end,1)-y(1:end-1,1)];% o vetor de estado eh formado pela posicao e a velocidade da valvula
k = 26;
N = 800;
n = 4;
opt.noiseinput = 'K';
opt.algorithm = 'Q';
eta = .00100;
fis = newfis('anfis com SID teste para valvula','sugeno');
%% determinando as entradas do anfis
fis = addvar(fis,'input', 'u(k)', [10,15]);% entrada
fis = addvar(fis,'input', 'y(k)', [100,120]);% saida
fis = addvar(fis,'input', 'x1(k)', [100,120]);% elemento 1 do vetor de estados
fis = addvar(fis,'input', 'x2(k)', [-5,5]);% elemento 2 do vetor de estados
%% definindo as funções de pertinencias das entradas
fis = addmf(fis, 'input',1,'u(k) a','gbellmf', [2.7 3.8 10]);
fis = addmf(fis, 'input',1,'u(k) b','gbellmf', [2.7 3.8 15]);
fis = addmf(fis, 'input',2,'y(k) a','gbellmf', [10.5 3.8 100]);
fis = addmf(fis, 'input',2,'y(k) b','gbellmf', [10.5 3.8 120]);
fis = addmf(fis, 'input',3,'x1(k) a','gbellmf', [10.5 6.5 100]);
fis = addmf(fis, 'input',3,'x1(k) b','gbellmf', [10.5 6.5 120]);
fis = addmf(fis, 'input',4,'x2(k) a','gbellmf', [5 3.4 -5]);
fis = addmf(fis, 'input',4,'x2(k) b','gbellmf', [5 3.4 5]);
%%montando os consequentes
fis = addmf(fis, 'output',1,'consequente_1','purelin',[zeros(1,4),0]);
fis = addmf(fis, 'output',1,'consequente_2','purelin',[zeros(1,4),0]);
fis = addmf(fis, 'output',1,'consequente_3','purelin',[zeros(1,4),0]);
fis = addmf(fis, 'output',1,'consequente_4','purelin',[zeros(1,4),0]);
fis = addmf(fis, 'output',1,'consequente_5','purelin',[zeros(1,4),0]);
fis = addmf(fis, 'output',1,'consequente_6','purelin',[zeros(1,4),0]);
fis = addmf(fis, 'output',1,'consequente_7','purelin',[zeros(1,4),0]);
fis = addmf(fis, 'output',1,'consequente_8','purelin',[zeros(1,4),0]);
fis = addmf(fis, 'output',1,'consequente_9','purelin',[zeros(1,4),0]);
fis = addmf(fis, 'output',1,'consequente_10','purelin',[zeros(1,4),0]);
fis = addmf(fis, 'output',1,'consequente_11','purelin',[zeros(1,4),0]);
fis = addmf(fis, 'output',1,'consequente_12','purelin',[zeros(1,4),0]);
fis = addmf(fis, 'output',1,'consequente_13','purelin',[zeros(1,4),0]);
fis = addmf(fis, 'output',1,'consequente_14','purelin',[zeros(1,4),0]);
fis = addmf(fis, 'output',1,'consequente_15','purelin',[zeros(1,4),0]);
fis = addmf(fis, 'output',1,'consequente_16','purelin',[zeros(3,2)]);

