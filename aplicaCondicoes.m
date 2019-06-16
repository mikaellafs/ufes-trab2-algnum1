function [diags, coefInd] = aplicaCondicoes(pxi, pxf, pyi, pyf, A, hy, hx, coefInd, diags,ny, a, c)
  % A é o vetor com os valores de V nos pontos dados pela condicao
  
  % indice inicial do x
  indXi = (pxi-a)*ny/hx
  if(indXi == 0) indXi = 1;
  endif
  % indice final do x
  indXf = (pxf-a)*ny/hx
  if(indXf == 0) indXf = 1;
  endif
  % indice relativo inicial do y
  indYi = (pyi-c)/hy+1
  % indice relativo final do y
  indYf = (pyf-c)/hy+1
  disp(' ')
  
  i = indXi
  while i<=indXf
    for j = indYi:indYf
      k = i+j;
      coefInd(k) = A(k);
      diags(k, :) = [0,0,1,0,0];
    endfor
    i = i+ny+1;
  endwhile
endfunction