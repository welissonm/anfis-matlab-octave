init;
%load mgdata.dat
raw_data = load(['.',filesep(),'dados',filesep(),'ensaio_tanques_19_01_20.mat']);
time = raw_data.time;
u = raw_data.u;
aux = regress(u',2);
limi = 100;
trnData = aux(2,1:limi)';
aux = regress(raw_data.l(:,2)',2);
y = aux(1,1:limi)';
l2 = aux(2,1:limi)';
l1 = (regress(raw_data.l(:,1)',2)(2,1:limi))';
%trnData = [trnData, l2,l1,l2];
trnData = [trnData, l2];


%states = raw_data.l;
%chkData = Data(501:end,:);
%movegui(f,'northwest')
eta = .0100;
fis = newfis('anfis teste tanques acoplados','sugeno');
fis = addvar(fis,'input', 'u(k)', [0,12]);
fis = addmf(fis, 'input',1,'p','gbellmf', [4.2,10,0]);
fis = addmf(fis, 'input',1,'pm','gbellmf', [0.85,6,5.4]);
fis = addmf(fis, 'input',1,'mg','gbellmf', [1.28,5,6.8]);
fis = addmf(fis, 'input',1,'g','gbellmf', [5.1,9,12]);

fis = addvar(fis,'input', 'l2(k)', [0,33]);
fis = addmf(fis, 'input',2,'p','gbellmf', [5,4,2.5]);
fis = addmf(fis, 'input',2,'pm','gbellmf', [7.25,5,12.5]);
fis = addmf(fis, 'input',2,'mg','gbellmf', [5,4,20]);
fis = addmf(fis, 'input',2,'g','gbellmf', [6.5,4.5,29]);
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
opt.defuzzy_function = str2func('evalCustom2');

[newFis,evalFis,erro] = training(fis,data,opt,l1);
finish;