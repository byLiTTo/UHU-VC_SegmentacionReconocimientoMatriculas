function Centroides = funcion_calcula_centroides(Matriz_Etiquetada)
    
    NumObjetos = max(Matriz_Etiquetada(:));
    Centroides = zeros(NumObjetos,2);
    
    X = zeros(NumObjetos,2);
    Y = zeros(NumObjetos,2);
    
    [nFilas,nColumnas] = size(Matriz_Etiquetada);
    for i=1:nFilas
        for j=1:nColumnas
            pos = Matriz_Etiquetada(i,j);
         
            if pos > 0
                X(pos,1) = X(pos,1)+1;
                X(pos,2) = X(pos,2)+i;
                
                Y(pos,1) = Y(pos,1)+1;
                Y(pos,2) = Y(pos,2)+j;
            end
        end
    end
    
    for k=1:NumObjetos
       Centroides(k,2) = (X(k,2)/X(k,1));
       Centroides(k,1) = (Y(k,2)/Y(k,1));
    end
end