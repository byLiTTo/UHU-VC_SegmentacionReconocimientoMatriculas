function NormCrossCorr = funcion_NormCorr2(I, T)

    Id = double(I);
    Td = double(T);
    
    [M, N] = size(Id);
    [NumFilVent NumColVent] = size(Td);
    
    NormCrossCorr = zeros(M,N);
    
    numFil = floor(NumFilVent/2);
    numCol = floor(NumColVent/2);
    
    for i=1+numFil:M-numFil
        for j=1+numCol:N-numCol
            
            % Generar la matriz IROI de valores de su entorno de vecindad. 
            % Este entorno tendrá las mismas dimensiones que la plantilla y
            % estará centrado en el píxel en cuestión (se asumirá que el 
            % número de filas y columnas de T es impar). Por tanto, IROI y 
            % T son matrices de igual dimensión:
            Iroi = Id(i-numFil:i+numFil,j-numCol:j+numCol);
            
            % Calcular la correlación cruzada normalizada entre IROI y T:
            CNN = funcion_CorrelacionEntreMatrices (Iroi, Td);
            
            % Asignar el valor calculado al pixel correspondiente de la 
            % matriz NormCrossCorr de salida:
            NormCrossCorr(i,j) = CNN;
            
        end
    end
    
end