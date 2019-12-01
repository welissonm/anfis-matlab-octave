%%
% args: fis object e iidata object
function [newFis,evalFis,erro] = training(fis, data)
  tSam = data.tsam{:};
  y = data.y{:};
  u = data.u{:};
  maxEpoc = 50; % quantidade máxima de épocas
  eta = .00100; % taxa de aprendizagem
  numSam = min(size(y,1), size(u,1)); % numero de amostras
  forwardMethod = 'lms'; %metodo para a etapa de forward
  backwardMethod = 'backpropagation'; %metodo para a etapa de backward
  if(size(fis.input,2) ~= size(u,2))
    error('o numero de entradas sao incompativeis');
  end
%  if(size(fis.output,2) ~= size(y,2))
%    error('o numero de saidas sao incompativeis');
%  end
  %%etapa forward
  newFis = fis;
  for i=1:maxEpoc
    [newConsequents, evalFis, rules,W] = stageForward(newFis,data);
    newFis.output(1).mf = newConsequents;
    erro = y-evalFis;
    erro2 = erro.^2;
    mse = (1/numSam)*sum(erro2);
    printf('epoch (%d): mse %d \n',i,mse);
    newFis = backpropagation(newFis,y,u,evalFis0,W,rules,eta);
  end

end
