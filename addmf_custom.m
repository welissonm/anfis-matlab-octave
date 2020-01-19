function new_fis = addmf_custom(fis, in_or_out, var_index, mf_name, mf_type, mf_params)
  if(strcmp(in_or_out,'output') && strcmp(mf_type,'space_states'))
    new_fis = fis;
    new_fis.output(var_index).mf(length(fis.output.mf)+1).name=mf_name;
    new_fis.output(var_index).mf(length(fis.output.mf)+1).type='space_states';
    if(isempty(mf_params.a) || isempty(mf_params.b) || isempty(mf_params.c))
     error('parametros invalidos');
    end
    new_fis.output(var_index).mf(length(fis.output.mf)+1).params = mf_params
  else
    new_fis = addmf(fis, in_or_out, var_index, mf_name, mf_type, mf_params);
  end
end
