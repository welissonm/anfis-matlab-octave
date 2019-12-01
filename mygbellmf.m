function y = mygbellmf(x, params)
  y = 1/(1 + (abs((x-params(3))/params(1)))^(2*params(2)));
endfunction
