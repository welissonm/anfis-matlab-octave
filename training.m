%%
% args: fis object e iidata object
function [newFis,evalFis,erro] = training(fis, data,varargin)
  tSam = data.tsam{:};
  y = data.y{:};
  u = data.u{:};
  maxEpoc = 10; % quantidade máxima de épocas
  eta = .000100; % taxa de aprendizagem
  numSam = min(size(y,1), size(u,1)); % numero de amostras
  if(nargin > 2)
    if(isfield(varargin{1},'forward_method'))
      forwardMethod = varargin{1}.forward_method;
    else
    forwardMethod = 'lms'; %metodo para a etapa de forward
  end
    if(isfield(varargin{1},'backward_method'))
      backwardMethod = varargin{1}.backward_method;
    else
      backwardMethod = 'backpropagation'; %metodo para a etapa de backward  
    end
  else
    forwardMethod = 'lms'; %metodo para a etapa de forward
    backwardMethod = 'backpropagation'; %metodo para a etapa de backward  
  end
  
  if(size(fis.input,2) ~= size(u,2))
    error('o numero de entradas sao incompativeis');
  end
%  if(size(fis.output,2) ~= size(y,2))
%    error('o numero de saidas sao incompativeis');
%  end
  %%etapa forward
  newFis = fis;
  for i=1:maxEpoc
    [newConsequents, evalFis, rules,W] = stageForward(newFis,data,varargin{:});
    newFis.output(1).mf = newConsequents;
    erro = y-evalFis;
    erro2 = erro.^2;
    mse = (1/numSam)*sum(erro2);
    if(mse <= 1e-12)
      break;
    end
    printf('epoch (%d): mse %d \n',i,mse);
    newFis = backpropagation(newFis,y,u,evalFis,W,rules,eta,varargin{:});
  end

end
