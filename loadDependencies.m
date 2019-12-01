function loadDependencies()
  if(is_octave())
    pkg load fuzzy-logic-toolkit
    pkg load control;
    pkg load signal;
  else
    
  end
end
