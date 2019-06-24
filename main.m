function menu_1 = main ()
  continuar = 1;
  while(continuar==1)
    quest = 0;
    quest = menu("Escolha","Validacao","Capacitor");
    switch quest
      case quest == 1
        source "validacao.m"
      case quest == 2 
        source "capacitor.m"
    endswitch
    continuar = yes_or_no("Continuar?");
  endwhile
  fprintf("\nObrigado e volte sempre, saudações!\n") 
endfunction