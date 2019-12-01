function [newOutput, yest, erro] = forwardMethodIdent(consequent, data, Wbar,varargin)
  method = 'lms';
  erro = [];
  y = data.y{:};
  u = data.u{:};
  yest = zeros(size(y));
  numSam = length(y);
  numRules = size(consequent,2);
  numInput = size(u,2);
  if(nargin > 3)
    method = varargin{1};
  end
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
    newOutput = consequent;
    for i=1:numRules
      newOutput(i).params = theta((i-1)*(numInput+1)+1:i*(numInput+1),1)';
    end
  elseif(method == 'sid')
  
  end
  
end
