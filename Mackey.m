clear
clc
close all

loadDependencies();
%load mgdata.dat
mgdata = csvread('mgdata.csv');
time = mgdata(:,1);
x = mgdata(:,2);
%f = figure(1);
%plot(time,x,'b','LineWidth',2.0)
%title('Serie temporal Ca�tica: Mackey-Glass');
%xlabel('Tempo(s)')
%ylabel('x(t)');

for t = 118:1117 
    Data(t-117,:) = [x(t-18) x(t-12) x(t-6) x(t) x(t+6)]; 
end
trnData = Data(1:500,:);
chkData = Data(501:end,:);
%movegui(f,'northwest')
P1(1,:) =  [1 2.5 0];
P1(2,:) =  [1 2.5 2];
P2(1,:) =  [1 2.5 0];
P2(2,:) =  [1 2.5 2];
P3(1,:) =  [1 2.5 0];
P3(2,:) =  [1 2.5 2];
P4(1,:) =  [1 2.5 0];
P4(2,:) =  [1 2.5 2];
I = [trnData(:,1) trnData(:,2) trnData(:,3) trnData(:,4)];
d = trnData(:,5);
eta = .00100;
fis = newfis('anfis teste mackey glass','sugeno');
fis = addvar(fis,'input', 'u(k)', [-3,3]);
fis = addmf(fis, 'input',1,'u(k) a','gbellmf',P1(1,:));
fis = addmf(fis, 'input',1,'u(k) b','gbellmf', P1(2,:));
fis = addvar(fis,'input', 'u(k-1)', [-3,3]);
fis = addmf(fis, 'input',2,'u(k-1) a','gbellmf', P2(1,:));
fis = addmf(fis, 'input',2,'u(k-1) b','gbellmf', P2(2,:));
fis = addvar(fis,'input', 'y(k-1)', [-1,1]);
fis = addmf(fis, 'input',3,'y(k-1) a','gbellmf', P3(1,:));
fis = addmf(fis, 'input',3,'y(k-1) b','gbellmf', P3(2,:));
fis = addvar(fis,'input', 'y(k-2)', [-1,1]);
fis = addmf(fis, 'input',4,'y(k-2) a','gbellmf', P4(1,:));
fis = addmf(fis, 'input',4,'y(k-2) b','gbellmf', P4(2,:));
fis = addvar(fis, 'output', 'y(k)',[-1.5,1.5]);
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
fis = addmf(fis, 'output',1,'consequente_16','purelin',[zeros(1,4),0]);
data = iddata(d,I,1);
[newFis,evalFis,erro] = training(fis,data);