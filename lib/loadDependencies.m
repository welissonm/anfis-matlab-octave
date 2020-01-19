function loadDependencies()
  if(is_octave())
    pkg load fuzzy-logic-toolkit
    pkg load control;
    pkg load signal;
    pkg load ltfat; % caso execute no octave
  else
    
  end
end
