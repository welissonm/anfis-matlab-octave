clear
clc
pkg load fuzzy-logic-toolkit
pkg load control;
pkg load signal;

clear
clc
 A = [1 0; -1 -2];
 B = [0;1];
 C = [0 1];
 D = 0;
 sys = ss(A,B,C,D);
 numOut = 1;
 %t = 0:0.1:99.9;
 [t,u] = prs_t([-3,5], 5,0.1,[0,100]);
 %u = randNum(-3,5,options
 N = length(t);
 options.dim = [1,N];
[y,t2,states] = lsim(sys,u,t);
%y_tp = toeplitz(y); 
%u_tp = toeplitz(u); 
%data = [u_tp(:,1)';u_tp(:,2)';y_tp(:,2)';y_tp(:,3)'];% as linhas sao as amostras da entrada correspondente e as colunas sao as amostras da respectiva 

%% dados de entrada
%data = (1/400)*[1 2 3 4; 10 20 30 40; 100 200 300 400]; % as linhas sao as amostras da entrada correspondente e as colunas sao as amostras da respectiva
%d = y';

y_tp = regress(y,3,2);
d = y_tp(1,1:end);
y_tp = y_tp(2:end,:);
u_tp = regress([0;u(1:end-1,:)],2,2);
data = [u_tp;y_tp];
%% mmq
data2.y = d';
data2.u = u;
[theta, y_m,e,g,P]= mmqr(data2,2,2);

%N=numero de dados
N = length(d);
%entrada no tempo.
fis = newfis('anfis teste','sugeno');
%adicionando as entradas e as funções de pertinências
numIn = 4;
mfs = cell(numIn,2);
mfs{1,1} = [2.5, 3 ,-2];
mfs{1,2} = [2.5, 3 ,2];
mfs{2,1} = [2.5, 2 ,-2.5];
mfs{2,2} = [2.5, 2 ,2.5];
mfs{3,1} = [0.8, 3 ,-0.8];
mfs{3,2} = [0.8, 3 ,0.8];
mfs{4,1} = [0.65, 6 ,-0.55];
mfs{4,2} = [0.65, 6 ,0.55];
eta = 0.000001;

fis = addvar(fis,'input', 'u(k)', [-3,3]);
fis = addmf(fis, 'input',1,'u(k) a','gbellmf',mfs{1,1});
fis = addmf(fis, 'input',1,'u(k) b','gbellmf', mfs{1,2});
fis = addvar(fis,'input', 'u(k-1)', [-3,3]);
fis = addmf(fis, 'input',2,'u(k-1) a','gbellmf', mfs{2,1});
fis = addmf(fis, 'input',2,'u(k-1) b','gbellmf', mfs{2,2});
fis = addvar(fis,'input', 'y(k-1)', [-1,1]);
fis = addmf(fis, 'input',3,'y(k-1) a','gbellmf', mfs{3,1});
fis = addmf(fis, 'input',3,'y(k-1) b','gbellmf', mfs{3,2});
fis = addvar(fis,'input', 'y(k-2)', [-1,1]);
fis = addmf(fis, 'input',4,'y(k-2) a','gbellmf', mfs{4,1});
fis = addmf(fis, 'input',4,'y(k-2) b','gbellmf', mfs{4,2});
%%plotmf(fis,'input',1)
%%plotmf(fis,'input',2)
%%plotmf(fis,'input',3)
%%plotmf(fis,'input',4)
numMf = 0;
rules = rulesGenerator([2;2;2;2]);
numRules = size(rules,1);
W = NaN(size(rules,1),size(data,2));
Wbar = NaN(size(rules,1),size(data,2));
indexs = cell(1,size(mfs,1));
muX = cell(size(mfs));
[row, col] = size(mfs);
numParamsFuncPert  = [];% vetor contendo, de forma sequencial, o numero de parametros das funcoes de pertinencia
for i = 1:row
  if(sum(size(mfs(i,:),2)) == 0)
    continue;
  end
  col = size(mfs(i,:),2);
  numMf = numMf + col;
  numParamsFuncPert = [numParamsFuncPert; col];
end
%combin = sort(numParamsFuncPert,"descend");
if(numMf == 0)
  error('o número de funcoes de pertinencias na entrada nao pode ser zero\n');
%elseif(numMf == 1)
%  sz = combin(1,1);
%else
%  sz = prod(combin(2:end,1));
else
  sz =  numMf;
end
printf('número de funcoes de pertinencias de entrada: %d\n',numMf);
deltaAlpha = cell(numMf,3);
daDbDc = zeros(3,N);
sumDaDbDc = zeros(3,1);
sumDeltaAlpha = zeros(3,numMf);
count = 0;
%% avaliando as pertinencias em relação as funções membro T-norma = and
for epoc=1:50
  printf('epoc: %d\n', epoc);
  for i=1:size(mfs,1)
    for j=1:size(mfs,2)
      if(sum(size(mfs{i,j})) == 0)
        break
      end
      muX{i,j} = NaN(1,size(data,2));
      for k =1:size(data,2)
        %muX{i,j}(k) = evalmf(data(i,k),mfs{i,j},'gbellmf');
        muX{i,j}(k) = mygbellmf(data(i,k),mfs{i,j});
      end
    end
  end
  %% avaliando as pertinencias nas regras
  for i = 1:numRules
    W(i,:) = ones(1,size(data,2));
    for j = 1:size(mfs,1)
      if(sum(size(muX{size(mfs,1)+1-j,rules(i,j)})) == 0)
        break;
      end
      for k = 1:size(data,2)
        W(i,k) = W(i,k)*muX{size(mfs,1)+1-j,rules(i,j)}(k);
      end
  %    W(i,:) = W(i,:).*muX{size(mfs,1)+1-j,rules(i,j)};
    end
  end
  %% normalização
  somatorioW = sum(W);
  somatorioW2 = somatorioW.^2;
  for j = 1:size(W,2)
    Wbar(:,j) = W(:,j)./somatorioW(j);
  end
  z = rand(numRules, numIn+1);%%consequentes
  f = NaN(numRules,length(data));
  for k = 1:length(data)
    for r =1: numRules
      f(r,k) = z(r,1:end-1)*data(:,k)+z(r,end);
    end
  end

  WbarF = f.*Wbar;
  ytil = NaN(numOut,N);
  for i=1:N
    ytil(:,i) = sum(WbarF(:,i));
  end
%  erro1 = d - ytil;
%% estimando os consequentes com o LMS
%  Psi = [ones(N,1), data'];
%  Psi_t = Psi';
%  newz = NaN(size(z));
%  for i=1:numRules
%    Qj = diag(W(i,:));
%    aux = Psi_t*Qj;
%    aux2 = (aux*Psi)^(-1);
%    aux3 = aux*d'; % newz(2,:)*Psi_t(:,2)
%    %ye(:,i) = (Psi)*(Wi(i,:)'); % consequente (modelo estimado) de cada regra.
%    %erri(:,i) = yd - ye(:,i); %erro gerado do conseguente de cada regra
%    newz(i,:) = aux2*aux3;
%  end
%% estimando os consequentes com LMS recursivo
  sz_d = size(d);
  thetaZ = NaN(size(z));
  Wbar_t = Wbar';
  WbarF_t = WbarF';
  for i=1:numRules
      data2.y = y.*Wbar_t(:,i);
      data2.z = data'.*Wbar_t(:,i);
      data2.theta = rand(numIn,1);
      %data2.z = [regress([0;data2.u(1:end-1,:)],2,2)';y_tpi'];
%      data2.y = zeros(sz_d(2),sz_d(1));
%      for j = 1:numRules
%        if(j==i)
%          continue;
%        end
%        data2.y = data2.y + WbarF_t(:,i);
%      end
%      data2.y = (d' - data2.y)./Wbar_t(:,i);
      [theta, y_m,e,g,P]= mmqr(data2);
      thetaZ(i,:) = [theta(:,end);0];
  end

  %atualizando os consequentes
  %z = newz;
  z = thetaZ;
  for k = 1:length(data)
    for r =1: numRules
      f(r,k) = z(r,1:end-1)*data(:,k)+z(r,end);
    end
  end
  WbarF = f.*Wbar;
  ytil = NaN(numOut,N);
  for i=1:N
    ytil(:,i) = sum(WbarF(:,i));
  end
  erro = d - ytil;
  erro_q = erro.^2;
  disp('%%%%%% fitness %%%%%%');
  disp(0.5*sum(erro_q));
  disp('%%%%%% %%%%%%');
  mse = (1/length(erro))*sum(erro_q);
  disp('%%%%%% mse %%%%%%');
  disp(mse);
  disp('%%%%%% %%%%%%');
  if( mse < 1e-6)
    printf('condicao de parada atingida: MSE %d', mse);
    break;
  end
  %printf('fitness: %d\n', 0.5*sum(erro.^2));
  %backpropagation
  delta = cell(4,numRules);
  for r=1:numRules
    delta(4,r) = -erro;
    %delta(3,r) = kron(delta{4,r},z(r,:));
    delta(3,r) = delta{4,r}.*f(r,:);
  end
    
  for i=1:numRules
    wAux = zeros(1,N);
    deltaAux = zeros(1,N);
    for j =1:numRules
      if(i==j)
        continue
      end
      wAux(1,:) = wAux+ W(j,:);
      deltaAux(1,:) = deltaAux(1,:) + delta{3,j}.*W(j,:);
    end
    delta(2,i) = delta{3,i}.*wAux - deltaAux;
    delta(2,i) = delta{2,i}./somatorioW2;
  end
  rules_t  = rules';
  delta1 = cell(1,sz);
  for i = 1:sz
    delta1{1,i} = zeros(1,N);
  end
  prodMu = NaN(sz,N);
  count = 0;
  for h = 1:numIn
    for i = 1:size(rules_t,2)
      %prodMu(i,:) = ones(1,N).*delta{2,i+h -1};
      prodMu(i,:) = ones(1,N);
      for j = 1:size(rules_t,1)
        if(j== h)
          continue;
        end
        %printf('(%d)%d,',j,rules_t(j,i));
        prodMu(i,:) = prodMu(i,:).*muX{j,rules_t(j,i)};
      end
      %printf(' x %d\n',i);
      %(i,:) = delta{2,i}.*prodMu(i,:);
    end
    for i = 1:size(mfs(h,:),2)
      count = count + 1;
      for j =1:size(rules_t,2)
        if(i != rules_t(h,j))
          continue;
        end
        delta1{1,count} = delta1{1,count}(1,:) + prodMu(j,:);
        %printf('delta1(%d) + prodMu(%d)\n',count,j);
      end 
    end
  end
  %[row, col] = size(mfs);
  count = 0;
  for i = 1:row
    if(sum(size(mfs(i,:),2)) == 0)
      continue;
    end
    col = size(mfs(i,:),2);
    for j=1:col
      count = count +1;
      deltaAlpha{count,1} = zeros(3,N); 
      for k =1:N
        daDbDc(:,k) = gbellGradient(data(i,k),mfs{i,j},muX{i,j}(k));
        %sumDaDbDc = sumDaDbDc + daDbDc(:,k);
        deltaAlpha{count,1}(:,k) = -eta.*daDbDc(:,k).*delta1{1,count}(k);
       %sumDeltaAlpha(:,count) = sumDeltaAlpha(:,count)+deltaAlpha{count,1}(:,k);
      end
      %printf('mfs(%d,%d) antes: ',i,j);
      %disp(mfs{i,j});
      mfs{i,j} = mfs{i,j} + sum(deltaAlpha{count,1}');
      %printf('mfs(%d,%d) depois: ',i,j);
      %disp(mfs{i,j});
    end
  end
end