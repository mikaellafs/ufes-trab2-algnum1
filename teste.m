clc
clear all
############# DADOS DO PROBLEMA ################
nx = 5;
ny = 5;
a = 0;
b = 10;
c = 0;
d = 5;
%% FUNÇÕES f(x,y) e g(x,y) dadas %%
function [v] = f(x,y)
  v =1; % só pra testar
endfunction

function [v] = g(x,y)
  v=1; % só pra testar
endfunction
#################################################

hx = (b-a)/(nx-1);
hy = (d-c)/(ny-1);

ap = bp = -1/(hx^2);
cp = dp = -1/(hy^2);
ep = 2/(ap+cp);

#### Criando vetor de diagonais ####
diags = [dp,bp,ep,ap,cp]
for i=1:nx*ny
  diags(i, :) = [dp,bp,ep,ap,cp];
endfor
% zerando b em algumas linhas
for i=0:(ny-1)
  diags(i*nx +1, 2) = 0;
endfor
% zerando a em algumas linhas
for i=1:ny
  diags(i*nx, 4) = 0;
endfor

#### Criando vetor de coeficientes independentes ####
n = 1;
for i=1:nx
  x = a + (i-1)*hx;
  for j=1:ny
    y = c + (j-1)*hy;
    coefInd(n) = f(x,y);
    n = n+1;
  endfor
endfor

#### Aplicando condicoes de contorno ####
% Ajustando para V=0 na fronteira


% Ajustando para outras condicoes que o problema der: (aqui usa a g(x,y))


#### Resolver o sistema gerado pelo metodo sor ####
% Calculo de w:
w = 1;

[V,iter] = sorDiag(diags, coefInd, 10^(-6), 3, w);
V
