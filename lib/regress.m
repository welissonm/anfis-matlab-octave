%%
% método para montar regressores temporais de amostras
% data eh matriz contendo as amostras
% nr eh a quantidade de requesores desejadas apartir do instante t-1.
% o argumento opcional varargin indica em que dimensao da matriz as amostras
% no tempo estão.
% Ex: para nr = 2 e varargin{1} = 1 (caso default) r:
%   data = [u(0),u(1), ... u(N)], r = [u(0), u(1), ...,u(N); 0 u(0), u(1) , ... u(N-1);...]
%%
function r = regress(data, nr, varargin)
  dim = 1;
  k = 0;
  if(nr <= 0)
    error('argumento #2: numero de regressores deve ser maior que zero');
  end
  if(nargin> 2)
    dim = varargin{1};
  end
  if(dim ==1)
    sz = size(data,2);
    if(sz < nr)
      error('O argumento#2 nao pode ser maior que a dimensao do argumento#1');
    end
    r = zeros(nr,sz);
    for i=1:nr
      r(i,i:end) = data(:,1:end-i+1); 
    end
  else
    sz = size(data,1);
    if(sz < nr)
      error('O argumento#2 nao pode ser maior que a dimensao do argumento#1');
    end
    r = zeros(nr,sz);
    for i=1:nr
      %r(i,1:end-i+1) = data(i:end,:);
       r(i,i:end) = data(1:end-i+1,:); 
    end
  end
end
