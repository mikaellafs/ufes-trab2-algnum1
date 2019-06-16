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
  meio = fix(tam/2 + 1);
  x0 = zeros(n,1);
  x = x0;
  iter = 0;
  err = tol +1;
  
  while err > tol && (iter < nmaxiter)
    for i=1:n
      soma = 0.0;
      for j=1:meio-1
        aux = meio-j;
        
        if (i-aux-3<1) a = 0;
        else a = x0(i-aux-3);
        endif
        if (i+aux+3>n) c = 0;
        else c = x(i+aux+3);
        endif
      
        soma = soma + diags(i,j)*a + diags(i,meio+j)*c;
      endfor
      x(i) = w*(b(i) - soma)/diags(i,meio) + (1-w)*x0(i);
    endfor
    err = norm((x-x0)/x);
    iter = iter + 1;
    x0 = x;
  endwhile
endfunction

