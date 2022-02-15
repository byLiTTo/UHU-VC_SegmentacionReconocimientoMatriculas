function [Matriz_Etiquetada N] = funcion_etiquetar(Matriz_Binaria)
    [nFila, nColumna] = size(Matriz_Binaria);

    N = 0;
    Matriz_Etiquetada = zeros(nFila,nColumna);

    for j=1:nColumna
        for i=1:nFila
            if Matriz_Binaria(i,j) == 1
                N = N+1;
                [Matriz_Binaria,Matriz_Etiquetada] = vecinos(Matriz_Binaria,Matriz_Etiquetada,i,j,N);
            end
        end
    end
end

function [Matriz_Binaria,Matriz_Etiquetada] = vecinos(Matriz_Binaria,Matriz_Etiquetada,fila,columna,N)
    %Pixel Central
    if Matriz_Binaria(fila,columna) == 1
        Matriz_Binaria(fila,columna) = 0;
        Matriz_Etiquetada(fila,columna) = N;
        
        %Vecino de Arriba
        if fila > 1
            [Matriz_Binaria,Matriz_Etiquetada] = vecinos(Matriz_Binaria,Matriz_Etiquetada,fila-1,columna,N);
        end
        
        %Vecino de Abajo
        if fila < size(Matriz_Binaria,1)
            [Matriz_Binaria,Matriz_Etiquetada] = vecinos(Matriz_Binaria,Matriz_Etiquetada,fila+1,columna,N);
        end
        
        %Vecino de Izquierda
        if columna > 1
            [Matriz_Binaria,Matriz_Etiquetada] = vecinos(Matriz_Binaria,Matriz_Etiquetada,fila,columna-1,N);
        end
        
        %Vecino de Derecha
        if columna < size(Matriz_Binaria,2)
            [Matriz_Binaria,Matriz_Etiquetada] = vecinos(Matriz_Binaria,Matriz_Etiquetada,fila,columna+1,N);
        end

%         %Vecino Arriba Izquierda
%         if fila > 1 && columna > 1
%             [Matriz_Binaria,Matriz_Etiquetada] = vecinos(Matriz_Binaria,Matriz_Etiquetada,fila-1,columna-1,N);
%         end
% 
%         %Vecino Arriba Derecha
%         if fila > 1 && columna < size(Matriz_Binaria,2)
%             [Matriz_Binaria,Matriz_Etiquetada] = vecinos(Matriz_Binaria,Matriz_Etiquetada,fila-1,columna+1,N);
%         end
% 
%         %Vecino Abajo Izquierda
%         if fila < size(Matriz_Binaria,1) && columna > 1
%             [Matriz_Binaria,Matriz_Etiquetada] = vecinos(Matriz_Binaria,Matriz_Etiquetada,fila+1,columna-1,N);
%         end
% 
%         %Vecino Abajo Derecha
%         if fila < size(Matriz_Binaria,1) && columna < size(Matriz_Binaria,2)
%             [Matriz_Binaria,Matriz_Etiquetada] = vecinos(Matriz_Binaria,Matriz_Etiquetada,fila+1,columna+1,N);
%         end
    end
end