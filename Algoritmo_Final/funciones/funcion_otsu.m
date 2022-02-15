function T_otsu = funcion_otsu(I)
   
    h = imhist(uint8(I));
    
    % Consideramos en toda la programación, niveles de gris de 1 a 256,
    % después al resultado le restamos una unidad
    
    
    gIni = 1; gFin = 256;
    [gmedio, numPix] = calcula_valor_medio_region_histograma(h,gIni,gFin);
    
    var = zeros(256,1); % Para almacenar la varianza entre clases
    
    for g=2:255 % los extremos de g=1 y g=256, no son posible umbrales
        T = g;
        var(g) = calcula_varianza_entre_clases(T,h,numPix,gmedio);
    end
    
    [~,indice] = max(var);
    
    T_otsu = indice-1;
    
end


function var = calcula_varianza_entre_clases(T,h,numPix,gMean)
    k = T;

    C1 = 1:k; % píxeles de I cuyo nivel de gris es mejor o igual a k
    C2 = k+1:256; % píxeles de I cuyo nivel de gris es mayor a k
    
    N1 = sum(h(C1));
    N2 = sum(h(C2));
    
    u1 = calcula_valor_medio_region_histograma(h,1,k);
    u2 = calcula_valor_medio_region_histograma(h,k+1,256);
    
    w1 = N1/numPix;
    w2 = N2/numPix;
    
    var = w1*(u1-gMean)^2 + w2*(u2-gMean)^2;
    
    if isempty(var)
        var = 0;
    end
    
end


function [gMean, numPix] = ...
    calcula_valor_medio_region_histograma(h,gIni,gFin)

    gIni = round(gIni);
    if gIni<1
        gIni = 1;
    end
    
    gFin = round(gFin);
    if gFin>256
        gFin = 256;
    end
    
    gMean = 0;
    for g=gIni:gFin
        gMean = gMean + g*h(g);
    end
    
    numPix = sum(h(gIni:gFin));
    
    if numPix>0
        gMean = gMean/numPix;
    else
        gMean = [];
    end
    
end