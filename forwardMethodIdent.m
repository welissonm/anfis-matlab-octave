function [newOutput, yest, erro] = forwardMethodIdent(consequent, data, Wbar,varargin)
  method = 'lms';
  erro = [];
  y = data.y{:};
  u = data.u{:};
  yest = zeros(size(y));
  numSam = length(y);
  numRules = size(consequent,2);
  numInput = size(u,2);
  if(nargin > 3 && ~isnumeric(varargin{1}) && ~isfield(varargin{1},'mf'))
    method = varargin{1}.forward_method;
  end
  newOutput = consequent;
  if(method == 'lms')
    erro = NaN(size(data.y));
    t = 1000*eye(numRules*(numInput +1),numRules*(numInput +1));
    theta = zeros(numRules*(numInput +1),1);
    phi = zeros(numRules*(numInput +1),1);
    for i=1:numRules
      theta((i-1)*(numInput+1)+1:i*(numInput+1),1) = consequent(i).params';
    end
    for k = 1:numSam
      phiAux = [u(k,:), 1];
      for i=1:numRules
         phi((i-1)*(numInput+1)+1:i*(numInput+1),1) = Wbar(i,k)*phiAux';
      end
      yest(k,:) = theta'*phi;
      erro(k,:) = y(k,:) - yest(k,:);
      con = t*phi/(1+phi'*t*phi);
      theta = theta + con*erro(k,:);
      t = t - (con*phi'*t);
    end
%    newOutput = consequent;
    for i=1:numRules
      newOutput(i).params = theta((i-1)*(numInput+1)+1:i*(numInput+1),1)';
    end
  elseif(method == 'sid')
    uui = NaN(numRules,numSam);
    for k = 1:numSam
      uui(:,k) = kron(Wbar(:,k),u(k,1));% u(k,1) 1 pq eh o sinal de entrada da planta
    end
    k = 10;
    m = 1;
    p = 1;
    N = length(u) - k;
    n_estimado = 2;
    Y = hankel(y(1:k),y(k:k+N));
%    U = hankel(u(1:k,1),u(k:k+N,1));
%    moesp(U,Y,m,p,2,k);
    yest = zeros(numSam,1);
    for i=1:numRules
      U = hankel(uui(i,1:k),uui(i,k:k+N));
      H = [U;Y];
      [Atil, Btil, Ctil, Dtil] = moesp(U,Y,m,p,n_estimado,k);
      sysdtil = ss(Atil, Btil,Ctil,Dtil,consequent(i).params.T);
      newOutput(i).params = sysdtil;
%      [yaux,t,x0] = lsim(sysdtil,u(:,1));
%      yest = yest + Wbar(i,:)'.*yaux;
    end
%    erro = y - yest;

  end
  
end
