%% Gera a matriz de regras
% muX eh uma celula contendo o numero de linhas correspondente ao numero de entradas
% e a quantidade de colunas correspondente ao numero de funcoes de perticencia
% da respectiva entrada.
%%
function rules = rulesGenerator(descritor)
  nIn = size(descritor,1);
  args = cell(1,nIn);
  aux = cell(1,nIn);
  numComb = 1;
  for i = 1:nIn
    args{1,i} = 1:1:descritor(i);
    numComb = numComb*descritor(i);
  end
  rules = NaN(numComb,nIn);
  [aux{1,:}] = ndgrid(args{:});
  for i = 0:nIn-1
    rules(:,nIn-i) = aux{1,i+1}(:);
  end
end
