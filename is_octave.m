function r = is_octave()
  persistent x;
  if (isempty (x))
    x = exist ('OCTAVE_VERSION', 'builtin');
  end
  if(~isempty(x) && x ~= 0)
    r = 1;
  else
    r = 0;
  end
end