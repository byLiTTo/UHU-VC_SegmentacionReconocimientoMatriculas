function Areas = funcion_calcula_areas(Matriz_Etiquetada)
    NumObjetos = max(Matriz_Etiquetada(:));
    Areas = zeros(NumObjetos,1);
    
    [nFilas,nColumnas] = size(Matriz_Etiquetada);
    for x=1:nFilas
        for y=1:nColumnas
            pos = Matriz_Etiquetada(x,y);
         
            if pos > 0
                Areas(pos) = Areas(pos)+1;
            end 
        end 
    end 
end