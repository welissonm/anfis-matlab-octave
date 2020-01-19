function [L,Q] = lq(A)
  [Q,R] = qr(A');
  Q = Q'; L = R';
end
