function resultado = fibonacci(n)
   switch n
     case 1
      resultado = 0;
     case 2
      resultado = 1;
     otherwise
      resultado = fibonacci(n-1) + fibonacci(n-2);
  end
end
