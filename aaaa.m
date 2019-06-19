diags = [2*ones(7,1),1*ones(7,1),4*ones(7,1),1*ones(7,1),2*ones(7,1)]


[x, iter] = sorDiag(diags,[7,8,6,6,6,8,7]',10^(-3),100,1, 2)