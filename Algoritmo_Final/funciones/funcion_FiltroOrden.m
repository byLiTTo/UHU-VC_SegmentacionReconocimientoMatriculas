function Ifiltrada = funcion_FiltroOrden(I, NumFilVent, NumColVent,Percentil)

    [M N] = size(I);
    Ifiltrada = zeros(M,N);
    
    numFil = floor(NumFilVent/2);
    numCol = floor(NumColVent/2);
    
    Iampliada = padarray(I,[numFil numCol]);
    
    for i=1:M
        for j=1:N
            V = Iampliada(i:i+2*numFil,j:j+2*numCol);
            Ifiltrada(i,j) = prctile(V(:),Percentil);
        end
    end
        
end