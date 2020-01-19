function str = path_src(path)
  r = strsplit(path, {'\','/'});
  col = size(r,2);
  str = [];
  if(col > 1)
    for i=1:col-1
      str = [str, r{1,i},filesep()];
    end
    str = [str, r{1,col}];
  else
  str = r{1,1};
  end
end