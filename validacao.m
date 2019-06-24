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
nx = (b-a)/hx +1;
ny = (d-c)/hy +1;

ap = bp = -1/(hx^2);
cp = dp = -1/(hy^2);
ep = -2*(ap+cp);

#### Criando vetor de diagonais ####
for i=1:nx*ny
  diags(i, :) = [dp,bp,ep,ap,cp];
endfor
% zerando b em algumas linhas
for i=0:(nx-1)
  diags(i*ny +1, 2) = 0;
endfor
% zerando a em algumas linhas
for i=1:nx
  diags(i*ny, 4) = 0;
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
### Valores Exatos de V conhecido ##
%% Valores esperados %%
n = 1;
for i=1:nx
  x = a + (i-1)*hx;
  for j=1:ny
    y = c + (j-1)*hy;
    pontosX(n)=x;
    pontosY(n)=y;
    Vexato(n) = Vp(x,y);
    n = n+1;
  endfor
endfor

#### Resolvendo para seidel ######
[V_1,iter,err] = sorDiag(diags,fp,10^(-6),1000,1,ny);
fprintf("Numero de iterações para Seidel foi de:\n")
iter
disp(' ')
fprintf("Erro de convergência para Seidel foi de:\n");
err
disp(' ')
#### Resolver o sistema gerado pelo metodo sor ####
% Calculo de w:
t = cos(pi/nx) + cos(pi/ny);
w = (8 - (64-16*t^2)^(1/2))/t^2;

[V_2,iter,err] = sorDiag(diags, fp, 10^(-6), 1000, w, ny);
fprintf("Numero de iterações para SOR foi de:\n")
iter
disp(' ')
fprintf("Erro de convergência para SOR foi de:\n");
err
disp(' ')
#### Calculo do erro a partir do valor esperado ####

%% Erro para V pelo metodo de Gauss Seidel 
for i = 1:nx*ny
  Vr(i) = abs(Vexato(i)-V_1(i));
endfor
fprintf("Erro calculado Gauss Seidel \n");
err= max(Vr)

disp(' ');
%% Erro para V pelo metodo de Sor com w determinado
for i = 1:nx*ny
  Vr(i) = abs(Vexato(i)-V_2(i));
endfor
fprintf("Erro calculado Sor \n");
err= max(Vr)

disp(' ');
#### PLOTANDO OS GRAFICOS ####
%% Grafico de V calculado
V1 = V_2';
[X,Y] = meshgrid(pontosX,pontosY);
[Z] = griddata(pontosX,pontosY,V1,X,Y);
figure;
surf(X,Y,Z);
title("V - Calculado - 3D")
figure;
pcolor(X,Y,Z);
colorbar;
title("V - Calculado - heatmap ");

%% Grafico de Vexato 
[Z1] = griddata(pontosX,pontosY,Vexato,X,Y);
figure;
surf(X,Y,Z1);
title("V exato - 3D");
figure;
pcolor(X,Y,Z);
colorbar;
title("V exato - heatmap ");
%% Campo elétrico
[fx,fy] = gradient(Z);
E = -fx-fy;
figure;
pcolor(X,Y,E);
colorbar;
title("heatmap do campo Eletrico");
figure;
hold on
contour(X,Y,Z);
title("Campo Eletrico e Linhas equipotenciais")
quiver(pontosX, pontosY, -fx, -fy,20);
hold off

disp("Tecle algo para continuar...");
pause;
close all;
