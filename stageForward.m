function [newConsequents, evalFis, rules,W] = stageForward(fis,data,varargin)
  %%avaliando as entradas
  [evalFis, Wbar, W] = customEvalFis(fis,data,varargin{:});
  clear evalFis,W;
   if(~isempty(fis.output))
    output = fis.output(1).mf;
   elseif(~isempty(varargin) && isfield(varargin,'mf'))
    output = varargin{1};
   else
    error('os consequentes nao podem ser nulos ou vazios');
  end
  %% motando os regressores
  [newConsequents,yest,erro] = forwardMethodIdent(output,data, Wbar,varargin{:});
%  fis.output(1).mf = newConsequents;
  [evalFis, Wbar, rules, W] = customEvalFis(fis,data,varargin{:});
end
