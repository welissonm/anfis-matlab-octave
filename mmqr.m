%% Metodo dos minimos quadrados recursivo
function [theta, y_m,e,g,P]= mmqr(data,varargin)
    y = [];
    u = [];
    P = [];
    if(nargin == 1)
      ny = null(1);
      nx = null(1);
%      if(isfield(data, 'u'))
%        u = data.u;
%      elseif(isfield(data, 'input'))
%        u = data.input;
%%      else
%%        error('o argumento #1 eh invalido! ausencia dos dados de input');
 %     end
      if(isfield(data, 'y'))
        y = data.y;
      elseif(isfield(data, 'output'))
        y = data.output;
      else
        error('o argumento #1 eh invalido! ausencia dos dados de output');
      end
      if(isfield(data, 'z'))
        z = data.z;
      elseif(isfield(data, 'regresser'))
        z = data.regresser;
      elseif(isfield(data, 'u'))
        u = data.u;
      elseif(isfield(data, 'input'))
        u = data.input;
      else
        error('o argumento #1 eh invalido');
      end
      dim = size(z,2);
      if(isfield(data, 'P'))
          P = data.P;
          %if([ny,nx] != size(P) && [nx, ny] != size(P))
          if(dim ~= size(P,1) && dim ~= size(P,2))
            error('as dimencoes de P s�o incompat�veis com os argumentos #2 e #3');
          end
      end
      if(isfield(data, 'theta'))
        theta = data.theta;
        %if([ny,nx] != size(theta) && [nx, ny] != size(theta))
        if(dim ~= size(theta,1) && dim ~= size(theta,2))
          error('as dimencoes de theta s�o incompat�veis com os argumentos #2 e #3');
        end
      end
      n = length(y);
      y_m = zeros(n,1);
    elseif(nargin == 3)
      ny = varargin{1};
      nx = varargin{2};
      if(size(data,2) == 2 && length(data) == size(data,1))
        y = data(:,1);
        u = data(:,2);
      elseif(isfield(data, 'u'))
        u = data.u;
      elseif(isfield(data, 'input'))
        u = data.input;
      else
        error('o argumento #1 eh invalido');
      end
      if(isfield(data, 'y'))
        y = data.y;
      elseif(isfield(data, 'output'))
        y = data.output; 
      else
        error('o argumento #1 eh invalido');
      end
      if( ny <= 0)
        error('argumento #2 deve ser maior que zero');
      end
      if( nx < 0)
        error('argumento #3 deve ser maior ou igual a zero');
      end
      dim = ny+nx;
      n = length(y);
      %montando regressores
      %z = [regress(y,ny,2)', regress(u,nx,2)'];
     z = [regress(u,nx,2)',regress(y,ny,2)'];  
      %ureg = regress(u,nx); %montando os regressores do sinal de entrada
      %yreg = regress(y,ny); %montando os regressores do sinal de saida
      theta = [];
      P = [];
     else
      error('numero de argumentos invalidos!');
     end
    if(nargin >= 4)
        if(isfield(varargin, 'P'))
            P = zeros(size(varargin.P), n); 
            P(:,:,1) = varargin.P;
            %if([ny,nx] != size(P) && [nx, ny] != size(P))
            if(dim ~= size(P,1) && dim ~= size(P,2))
              error('as dimencoes de P s�o incompat�veis com os argumentos #2 e #3');
            end
        end
        if(isfield(varargin, 'theta'))
            theta = zeros(size(varargin.theta),n);
            theta(:,:,1) = varargin.theta;
            %if([ny,nx] != size(theta) && [nx, ny] != size(theta))
            if(dim ~= size(theta,1) && dim ~= size(theta,2))
              error('as dimencoes de theta s�o incompat�veis com os argumentos #2 e #3');
            end
        end
       if(length(y) >= length(u))
          n = length(u);
          sz_y = size(y);
          [,indice] = min(sz_y);
          if(indice == 1)
            y_m = zeros(n,sz_y(1));
          else
            y_m = zeros(n,sz_y(2));
          end
          e = y_m;
       else
          n = length(y);
          y_m = zeros(size(y));
       end
    else
        %Valor inicial dos parametros
        if(isempty(theta))
          theta = zeros(dim,n);
          theta(:,1) = rand(dim,1);
        else
          aux = theta;
          theta = zeros(dim,n-length(aux));
        end
        %Valor inicial da Matriz P
        if(isempty(P))
          P = zeros(dim, dim, n);
          P(:,:,1) = 10*diag(rand(dim,1));
        else
          aux = P;
          P = zeros(dim, dim, n - length(P));
        end
    end
    if(n > 1)
      for k=2:n
       %Vetor de regress�o   
       %psi(:,k)=[y(k) y(k-1) u(k) u(k-1)]';
       %psi(:,k)= [yreg(k,:), ureg(k,:)]';
       if( k> 1014)
        disp(P(:,:,k-1));
      end
       psi(:,k)= z(k,:)';
       %Ganho dos MQR
       g(:,k)=P(:,:,k-1)*psi(:,k)*[1+psi(:,k)'*P(:,:,k-1)*psi(:,k)]^(-1);
       %Inova��o
       e(k,:)=y(k,:)-psi(:,k)'*theta(:,k-1);
       %Atualiza��o dos Par�metros do modelo
       theta(:,k)=theta(:,k-1)+g(:,k)*e(k,:);
       %Atualiza��o da matriz P
       P(:,:,k)=P(:,:,k-1)+g(:,k)*psi(:,k)'*P(:,:,k-1);
       %Estimativa da sa�da atual
       y_m(k,:)=psi(:,k)'*theta(:,k);
       e(k,:) = y(k,:) - y_m(k,:);
      end
    else
      error('o argumento #1 deve ter no m�nimo duas linhas');
    end
end