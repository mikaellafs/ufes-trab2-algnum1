function [x, iter] = sorDiag(diags,b,tol,nmaxiter,w)
%
% Entrada: 
%   diags,b = vetor das diagonais, vetor independente
%   tol = tolerancia
%   nmaxiter = numero maximo de iteracoes
%   w = parametro SOR (w=1 Gauss-Seidel)
% Saida:
%   x = vetor solucao
%   iter = numero de iteracoes
%
  
  [n,tam] = size(diags);
  meio = fix(tam/2 +1);
  x0 = zeros(n,1);
  x = x0;
  iter = 0;
  err = tol +1;

  while (err > tol) && (iter < nmaxiter)
    for i=1:n
      soma = 0.0;
      for j=1:meio-1
        aux1 = i-j;
        if(aux1<1) a = 0;
        else a = x(aux1);
        endif
      
        aux2 = i+j;
        if(aux2>n) c = 0;
        else c = x0(aux2);
        endif

        soma = soma + a*diags(i,meio-j) + c*diags(i,meio+j);
      endfor
      x(i) = w*(b(i) - soma)/diags(i,meio) + (1-w)*x0(i);
    endfor
    iter = iter + 1;
    x0 = x;
  endwhile
endfunction

