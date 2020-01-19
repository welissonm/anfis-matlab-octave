function [evalFis, Wbar, rules, W] = customEvalFis(fis,data,varargin)
  %%avaliando as entradas
  numIn = size(fis.input,2);
  numMembership = zeros(numIn,1);
  numRules = 0;
  W = [];
  Wbar = [];
  u = data.u{:};
  numSam = size(data.u{:}(:,1),1); %numero de amostras no tempo
  %% avaliando as entradas
  if(~isempty(varargin))
    [evalMfs, numMembership] = fuzz(fis,data,varargin{:});
  else 
    [evalMfs, numMembership] = fuzz(fis,data);
  end
  [evalFis, Wbar, rules, W] = customDefuzz(fis, evalMfs, data, numMembership,varargin{:});
  
end
