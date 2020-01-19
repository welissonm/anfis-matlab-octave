%% Gera numeros aleatorios com distribuicao uniforme no intervalo [a,b).
% varargin - options (opcional)
% options.dim - a dimensao do vetor que sera retornado. (optional)
% options.seed - a semente utilizada para gerar os numeros
%%
function c = randNum(a,b,varargin)
  bAux = b;
  dimen = 1;
  if(nargin > 2 && ~isempty(varargin))
    options = varargin{1};
    if(isfield(options,'seed'))
      rand('seed',options.seed);
    end
    if(isfield(options,'dim'))
       dimen = options.dim;
    end
  end
  if(b <= a )
    error('o argumento #2 deve ser maior que o argumento #1: (b > a)');
  end
  if(dimen == 1)
%    c = a + mod(randi(abs(b)+1)-1 + rand(),abs(b-a));
  c = a + rand()*(b-a);
  else
    c = zeros(dimen(1),dimen(2));
    for i=1:1:dimen(1)
      for j=1:1:dimen(2)
%        c(i,j) = a + mod(randi(abs(b)+1)-1 +rand(), abs(b-a));
         c = a + rand()*(b-a);
      end
    end
  end
end