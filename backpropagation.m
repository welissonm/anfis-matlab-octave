function newFis = backpropagation(fis, y,u,evalFis0, W0, rules,eta)
  numSam = min(size(y,1), size(u,1)); % numero de amostras
  erro = y-evalFis0;
  numConsequents = size(fis.output(1).mf,2);
  numRules = size(rules,1);
  numInput = size(fis.input,2);
  numMembership = 0;
  numMfs = 0;
  dataAux.u =  cell(1,1);
  dataAux.y =  cell(1,1);
  deltaAlpha = zeros(3,1);
  newFis = fis;
  dParams = cell(1,1);
  %obtendo o numero de funcoes de pertinencias nas entradas
%  for i=1:numInput
%    numMembership = numMembership + size(fis.input(i).mf,2);
%  end
   W = W0(:,1);
  evalFis = evalFis0;
  for k=1:numSam
    erro(k,:) = y(k,:) - evalFis(k,:);
    custoFunction = -2*erro(k,:);
    d5 = custoFunction;
    d4 = d5;
    d3 = zeros(numConsequents,1);
    for i=1:numConsequents
      params_t = fis.output(1).mf(1,i).params';
      d3(i,1) = d4*(u(k,:)*params_t(1:end-1,:) + params_t(end,:));
    end
    d2 = zeros(numConsequents,1);
    sumW = sum(W);
    sumW2 = sumW.^2;
    for i= 1:numRules
      for j=1:numRules
        if (i == j)
          d2(i,1) = d2(i,1) + d3(i,1)*(sumW - W(i,1))/(sumW2);
        else
          d2(i,1) = d2(i,1) - d3(j,1)*W(j,1)/(sumW2);
        end
      end
    end
    rules_t  = rules';
    dataAux.u(1,1) = u(k,:);
    dataAux.y(1,1) = y(k,:);
    [evalMfs,numMembership] = fuzz(fis,dataAux,1);
    numMfs = sum(numMembership);
    d1 = zeros(numMfs,1);
    prodMu = ones(numRules,1);
    count = 0;
    for i=1:numInput
      for j=1:numRules
        for l=1:numInput
          if(l== i)
            continue;
          end
          %printf('(%d)%d,',j,rules_t(j,i));
          prodMu(j,:) = prodMu(j,:)*evalMfs.input(l).mf(rules_t(l,j)).eval;
        end
      end
      numMf = size(fis.input(1).mf,2);
      for j = 1:numMembership(i)
        count = count + 1;
        count2 = (j-1)*numMfs;
        for l =1:numRules
          if(j != rules_t(i,l))
            continue;
          end
          count2 = count2 +1;
%          printf('d2(%d) e rules_t(%d,%d): %d\n',l,i,l,rules_t(i,l));
          d1(count,1) =  d1(count,1) + d2(l,:)*prodMu(count2,:);
%          printf('d1(%d) + prodMu(%d)\n',count,count2);
        end 
      end
    end
    count = 0;
    for i = 1:numInput
      for j=1:numMembership(i)
        count = count +1;
        params = newFis.input(i).mf(j).params;
        dParams{1}(1:length(params)) = gbellGradient(u(k,i),params, evalMfs.input(i).mf(j).eval);
        deltaAlpha = -eta*dParams{1}*d1(count,1);
        newFis.input(i).mf(j).params = params + deltaAlpha;
        %printf('mfs(%d,%d) depois: ',i,j);
        %disp(mfs{i,j});
      end
    end
%    fis.input = newFis;
    [evalFisAux, Wbar, _, W] = customEvalFis(newFis,dataAux);
    evalFis(k,:) = evalFisAux;
  end
end
