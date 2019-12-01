function [da,db,dc] = gbellGradient(x,params,varargin)
  a = params(1);
  b = params(2);
  c = params(3);
  db = 0;
  dc = 0;
  if(isempty(varargin))
   y = evalmf(x,params,'gbellmf');
  else
   y =  varargin{1};
  end
  da = 2*(b/a)*y*(1-y);
  if(x ~= c)
    db = -2*log(norm((x-c)/a))*y*(1-y);
    dc = ((2*b)/(x-c))*y*(1-y);
  end
end
