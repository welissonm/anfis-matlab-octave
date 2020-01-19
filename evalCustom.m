%% metodo para fazer a defuzificacao para consequentes com espacode estados
function ev = evalCustom(u, param, varargin)
  n = size(param.a,1); %ordem do sistema em espaco de estados
  m = size(param.b,2); % numero de entradas do sistema
  p = size(param.c,1); % numero de saidas do sistema
  sinal = u(1:m)';
  saidas = u(m+1:m+p)';
  estados = u(m+p+1:m+p+n)';
 ev = param.c*estados + param.d*sinal; 
end
