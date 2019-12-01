function [time,u,t_trans,u_trans] = prs_t(amp, delay,timeSample,tspan)
  ampMax = 0;
  ampMin = 0;
  tInit = 0;
  tEnd = 0;
  t_trans = []; % o tempo em que as transicoes do sinal ocorrem
  u_trans = []; % o valores de transicao
  rangeTime = [];
  if(size(size(amp),2) ==2)
    ampMin = amp(1);
    ampMax = amp(2);
  elseif(~isempty(amp))
    ampMax = amp(1);
	ampMin = ampMax -2*ampMax;
  else
    error('o argumento #1 nao pode ser nulo.');
  end
  if(ampMin >= ampMax)
	error('o elemento do indice 1 do argumento #1 deve ser menor que o indice 2');
  end
  if(timeSample <= 0)
    error('O argumento #3 deve ser maior que zero.');
  end
  if(isempty(delay) || length(delay) <= 0)
	error('o argumento #2 nao pode ser nulo.');
  elseif(length(delay)==1)
	if(2*timeSample >= delay)
		error('O argumento #2 deve ser no minimo 2 vezes maior que o argumento #3');
	end
	nt = floor(delay/timeSample);
	rangeTime = [nt,2*nt];
  else
	rangeTime = [floor(delay(1)/timeSample),floor(delay(2)/timeSample)];
	if(rangeTime(1) >= rangeTime(2))
		error('o elemento do indice 1 do argumento #2 deve ser menor que o indice 2');
	end
	if(2*timeSample > rangeTime(1))
		error('O argumento #2 deve ter seus lementos no minimo 2 vezes maior que o argumento #3');
	end
  end
  if(size(size(tspan),2) ==2)
    tInit = tspan(1);
    tEnd = tspan(2);
  elseif(~isempty(tspan))
    tEnd = tspan(1);
  else
    error('o argumento #4 nao pode ser nulo.');
  end
  if(tInit >= tEnd)
    error('o elemento do indice 1 do argumento #4 deve ser menor que o indice 2');
  end
  if((tEnd - tInit)<= delay)
	  error('A diferenca (indice 2 - indice 1) do argumento #4 deve ser maior que o argumento #2');
  end
  if(mod(delay,timeSample) > eps)
    error('o argumento #2 deve ser multiplo do argumento #3');
  end
  time = (tInit:timeSample:tEnd)';
  values = zeros(length(time),1);
  t = tInit;
  i = 1;
  t_trans= [t_trans, t]; 
  while(t<tEnd)
    tr = timeSample*randi(rangeTime);
    if(tEnd -t < tr)
      tr = tEnd -t;
    end
    t = t+tr;
    t_trans = [t_trans, t];
    vr = randNum(ampMin,ampMax);
    u_trans = [u_trans, vr];
    values(i:floor((t-tInit)/timeSample),1) = vr;
    i = floor((t-tInit)/timeSample)+1;
  end
  t_trans = t_trans(1:end-1);
  values(i:end) = vr;
  u = values;
end