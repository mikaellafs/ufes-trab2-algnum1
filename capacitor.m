clc
clear all
##################### Capacitor de placas paralelas #####################
############# DADOS DO PROBLEMA ################
hx = 0.25;
hy = 0.25;
a = 0;
b = 10;
c = 0;
d = 5;
%% f(x,y) = 0
%% V=0 na fronteira
%% V= 5 em y= 3, 3<=x<=7
%% V= -5 em y= 2, 3<=x<=7
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
    pontosX(n) = x;
    pontosY(n) = y;
    fp(n) = 0;
    n = n+1;
  endfor
endfor

#### Aplicando condicoes de contorno ####
% Ajustando para V=0 na fronteira : como f(x,y) = 0, V já é igual a 0 na fronteira

% Ajustando para V= 5 em y= 3, 3<=x<=7
k = 4/hx +1;
[diags, fp] = aplicaCondicoes(3, 7, 3, 3, ones(k,1)*5, hy, hx, fp, diags,ny, a, c);

% Ajustando para V= -5 em y= 2, 3<=x<=7
[diags, fp] = aplicaCondicoes(3, 7, 2, 2, ones(k,1)*-5, hy, hx, fp, diags,ny, a, c);

#### Resolver o sistema gerado pelo metodo sor ####
% Calculo de w:
t = cos(pi/nx) + cos(pi/ny);
w = (8 - (64-16*t^2)^(1/2))/t^2;

[V,iter] = sorDiag(diags, fp, 10^(-6), 100, w, ny);

#### PLOTANDO OS GRAFICOS ####
%% Grafico do potencial
[X,Y] = meshgrid(pontosX,pontosY);
[Z] = griddata(pontosX,pontosY,V',X,Y);
figure;
surf(X,Y,Z);
title("Potencial elétrico");
figure;
pcolor(X,Y,Z);
colorbar;
title("Heatmap para o potencial");
%% Campo elétrico
[fx,fy] = gradient(Z);
figure
E = -fx-fy;
pcolor(X,Y,E);
colorbar;
title("Heatmap para campo elétrico");
figure
hold on
contour(X,Y,Z);
quiver(pontosX, pontosY, -fx, -fy, 10);
title("Linhas equipotenciais e campo elétrico");
hold off

disp("Tecle algo para continuar...");
pause;
close all;
