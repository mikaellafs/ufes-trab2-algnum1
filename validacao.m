clc
clear all
##################### Validação da solução com um problema conhecido #####################
############# DADOS DO PROBLEMA ################
hx = 0.5;
hy = 0.5;
a = 0;
b = 10;
c = 0;
d = 5;
%% FUNÇÕES f(x,y) e g(x,y) dadas %%
function [v] = f(x,y)
  v =(1/5)*(x*(10-x)+y*(5-y));
endfunction

function [v] = g(x,y)
  v=0.625*x*(10-x);
endfunction

%% FUNÇÃO Vp(x,y) esperada %%
function [v] = Vp(x,y)
  v = x*(10-x)*y*(5-y)/10;
endfunction

#################################################
nx = (b-a)/hx;
ny = (d-c)/hy;

ap = bp = -1/(hx^2);
cp = dp = -1/(hy^2);
ep = -2*(ap+cp);

#### Criando vetor de diagonais ####
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
    fp(n) = f(x,y);
    n = n+1;
  endfor
endfor


#### Aplicando condicoes de contorno ####
% Ajustando para V=0 na fronteira
[diags, fp] = aplicaCondicoes(a, a, c, d, zeros(ny,1), hy, hx, fp, diags,ny, a, c);
[diags, fp] = aplicaCondicoes(b, b, c, d, zeros(ny,1), hy, hx, fp, diags,ny, a, c);
[diags, fp] = aplicaCondicoes(a, b, c, c, zeros(nx,1), hy, hx, fp, diags,ny, a, c);
[diags, fp] = aplicaCondicoes(a, b, d, d, zeros(nx,1), hy, hx, fp, diags,ny, a, c);

% Ajustando para V= g(x,y) em y= 2.5, 0<x<10
for i = 1:(nx-1)
   x = a+(i*hx);
   gp(i) = g(x,2.5);
endfor

[diags, fp] = aplicaCondicoes(a+hx, b-hx, 2.5, 2.5, gp, hy, hx, fp, diags,ny, a, c);

#### Resolver o sistema gerado pelo metodo sor ####
% Calculo de w:
t = cos(pi/nx) + cos(pi/ny);
w = (8 - (64-16*t^2)^(1/2))/t^2;

[V,iter] = sorDiag(diags, fp, 10^(-6), 100, w, ny);

#### Calculo do erro a partir do valor esperado ####
%% Valores esperados %%
n = 1;
for i=1:nx+1
  x = a + (i-1)*hx;
  for j=1:ny
    y = c + (j-1)*hy;
    Vexato(n) = Vp(x,y);
    n = n+1;
  endfor
endfor

%% Erro %%
for i = 1:(nx+1)*ny
  Vr(i) = abs(Vexato(i)-V(i));
endfor
err= max(Vr)