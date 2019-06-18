function [x, iter] = sorDiag(diags,b,tol,nmaxiter,w, ny)
  [n,tam]=size(diags);
  x0 = zeros(n,1);
  x = x0;
  iter = 0;
  err = tol +1;

  while (err > tol) && (iter < nmaxiter)
    for i=1:n
        if(i-ny<1) a1=0;
        else a1=x(i-ny);
        endif
        if(i-1<1) a2=0;
        else a2=x(i-1);
        endif
        if (i+1>n) a3=0;
        else a3=x0(i+1);
      endif
      if (i+ny>n) a4=0;
      else a4=x0(i+ny);
      endif
      soma = a1*diags(i,1) + a2*diags(i,2) + a3*diags(i,4) + a4*diags(i,5);
      x(i) = w*(b(i) - soma)/diags(i,3) + (1-w)*x0(i);
    endfor
    iter = iter + 1;
    x0 = x;
  endwhile
endfunction

