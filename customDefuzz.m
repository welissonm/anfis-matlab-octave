function [evalFis, Wbar, rulesMap,W] = customDefuzz(fis,evalMfs, data, numMembership, varargin)
  numIn = size(fis.input,2);
  numOut = size(fis.output,2);
  numRules = 0;
  W = [];
  Wbar = [];
  u = data.u{:};
  numSam = size(u(:,1),1); %numero de amostras no temp
  evalFis = zeros(numSam, numOut);
   %% avaliando as regras
  rulesMap = rulesGenerator(numMembership); % gerando o mapa de regras
  numRules = size(rulesMap,1);
  W = NaN(numRules, numSam);
  Wbar = W;
  for i = 1:numRules
    W(i,:) = ones(1,numSam);
    for j = 1:numIn
      for k = 1:numSam
        W(i,k) = W(i,k)*evalMfs.input(numIn+1-j).mf(rulesMap(i,j)).eval(k);
      end
  %    W(i,:) = W(i,:).*muX{size(mfs,1)+1-j,rules(i,j)};
    end
  end
  %% normalização
  somatorioW = sum(W);
  for k = 1:numSam
    Wbar(:,k) = W(:,k)./somatorioW(k);
  end
  if(~isempty(fis.output))
    output = fis.output(1).mf;
  elseif(nargin == 5 && ~isempty(varargin))
    output = varargin{1};
  else
   error('os consequentes nao podem ser nulos ou vazios');
  end
  if(nargin >= 5 && ~isempty(fis.output) && ~isnumeric(varargin{1}))
    opt = varargin{1};
  end
  for k=1:numSam
    for i=1:numRules
      if(strcmp(output(i).type,'space_states'))
        sys = output(i).params;
        evalCustom = opt.defuzzy_function;%% funcao a ser implementada para avaliar o espaco de estado
        evalFis(k,:) = evalFis(k,:) + Wbar(i,k)*evalCustom(u(k,:),sys, varargin{:},k);
      else
        params_t = output(i).params';
        evalFis(k,:) = evalFis(k,:) + Wbar(i,k)*(u(k,:)*params_t(1:end-1,:) + params_t(end,:)); 
      end
    end
  end
end
