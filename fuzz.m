%% função para calcular as pertinencias dos antecedentes em relação as funções de pertinências
function [evalMF,numMembership] = fuzz(fis,data,varargin)
  %% avaliando as entradas
  numIn = size(fis.input,2);
  evalMF = struct();
  numMembership = zeros(numIn,1);
  u = data.u{:};
  if(~isempty(varargin) && isnumeric(varargin{1}))
    numSam = varargin{1};
  else
    numSam = size(data.u{:}(:,1),1); %numero de amostras no tempo
  end
  %% avaliando as pertinencias das entradas
  for i=1:numIn
    numMf = size(fis.input(1,i).mf,2);
    numMembership(i) = numMf;
    for j=1: numMf
%      numSam = size(data.u{:}(:,i),1);
      evalMF= setfield(evalMF,'input', {i},'mf',{j},'eval',[]);
      y = zeros(numSam,1);
      for k=1:numSam
        y(k) = evalmf(u(k,i),fis.input(1,i).mf(j).params,fis.input(i).mf(j).type);
      end
      evalMF.input(i).mf(j).eval = y;
    end
  end
end
