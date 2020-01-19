init;
%load mgdata.dat
raw_data = load(['.',filesep(),'dados',filesep(),'ensaio_tanques_acoplados_sem_ruido.mat']);
time = raw_data.time;
u = raw_data.u;
aux = regress(u',2);
limi = 3000;
trnData = aux(2,1:limi)';
aux = regress(raw_data.l(:,2)',2);
y = aux(1,1:limi)';
l2 = aux(2,1:limi)';
l1 = (regress(raw_data.l(:,1)',2)(2,1:limi))';
trnData = [trnData, l2,l1,l2];


%states = raw_data.l;
%chkData = Data(501:end,:);
%movegui(f,'northwest')
P1(1,:) =  [9 5 6];
P1(2,:) =  [7 5 26];
P2(1,:) =  [9 5 6];
P2(2,:) =  [9 5 24];
P3(1,:) =  [8 6 -7.5];
P3(2,:) =  [8 6 7.5];
%P4(1,:) =  [8 6 -7.5];
%P4(2,:) =  [8 6 7.5];
eta = .0100;
fis = newfis('anfis teste tanques acoplados','sugeno');
fis = addvar(fis,'input', 'u(k-1)', [-10,10]);
fis = addmf(fis, 'input',1,'u(k-1) a','gbellmf', P3(1,:));
fis = addmf(fis, 'input',1,'u(k-1) b','gbellmf', P3(2,:));
fis = addvar(fis,'input','y(k-1)', [0,33]);
fis = addmf(fis, 'input',2,'y(k-1) a','gbellmf',P1(1,:));
fis = addmf(fis, 'input',2,'y(k-1) b','gbellmf', P1(2,:));
fis = addvar(fis,'input','l1(k-1)', [0,33]);
fis = addmf(fis, 'input',3,'l1(k-1) a','gbellmf', P2(1,:));
fis = addmf(fis, 'input',3,'l1(k-1) b','gbellmf', P2(2,:));
fis = addvar(fis,'input','l2(k-1)', [0,33]);
fis = addmf(fis, 'input',4,'l2(k-1) a','gbellmf', P1(1,:));
fis = addmf(fis, 'input',4,'l2(k-1) b','gbellmf', P1(2,:));
%plotmf(fis,'input',1,0,1)
%plotmf(fis,'input',2,0,1)
%plotmf(fis,'input',3,0,1)
%plotmf(fis,'input',4,0,1)
fis = addvar(fis, 'output', 'y(k)',[0,33]);
sys = ss([0, 1; -1 -1],[0;1], [0,1],0,0.1);
fis = addmf_custom(fis, 'output',1,'consequente_1','space_states',sys);
fis = addmf_custom(fis, 'output',1,'consequente_2','space_states',sys);
fis = addmf_custom(fis, 'output',1,'consequente_3','space_states',sys);
fis = addmf_custom(fis, 'output',1,'consequente_4','space_states',sys);
fis = addmf_custom(fis, 'output',1,'consequente_5','space_states',sys);
fis = addmf_custom(fis, 'output',1,'consequente_6','space_states',sys);
fis = addmf_custom(fis, 'output',1,'consequente_7','space_states',sys);
fis = addmf_custom(fis, 'output',1,'consequente_8','space_states',sys);
fis = addmf_custom(fis, 'output',1,'consequente_9','space_states',sys);
fis = addmf_custom(fis, 'output',1,'consequente_10','space_states',sys);
fis = addmf_custom(fis, 'output',1,'consequente_11','space_states',sys);
fis = addmf_custom(fis, 'output',1,'consequente_12','space_states',sys);
fis = addmf_custom(fis, 'output',1,'consequente_13','space_states',sys);
fis = addmf_custom(fis, 'output',1,'consequente_14','space_states',sys);
fis = addmf_custom(fis, 'output',1,'consequente_15','space_states',sys);
fis = addmf_custom(fis, 'output',1,'consequente_16','space_states',sys);
data = iddata(y,trnData,raw_data.T);
opt.forward_method = 'sid';
opt.defuzzy_function = str2func('evalCustom');
[newFis,evalFis,erro] = training(fis,data,opt);
finish;