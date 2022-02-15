%% FUNCION SEGMENTA CARACTERES
% OBJETIVO: Segmentar en la imagen original los pixeles que integran cada
% caracter de la matricula y obtener la region compuesta por el rectangulo
% mas pequeño que delimita dichos pixeles.
% VARIABLES:
% - I: Imagen a tratar
% - NumObjetos: Numero total de letras y numeros presentes en la imagen,
%   pueden ser 6 o 7 dependiendo de la matricula.
% - Segmentacion: Todos los boundingbox de los caracteres detectados. Son
% matrices binarias donde 1's representa pixeles pertenecientes al caracter
function [Segmentacion, Ietiq] = funcion_segmenta_caracteres(I, NumObjetos)
        
    %% Separamos la componente B de la imagen
    R = I(:,:,1);
    G = I(:,:,2);
    B = I(:,:,3);

    I_gray = rgb2gray(I);

    
    %% Calculamos umbral con OTSU en la componente Azul
    umbral = funcion_otsu(R);
    
    %% Binarizamos a partir de dicho umbral
    Ib = R < umbral;
%     figure, imshow(Ib)
       
    %% Eliminamos regiones ruidosas
    Ibin = funcion_elimina_regiones_ruidosas(Ib);    
%     figure, imshow(Ibin)

%     Ibin = Ib; % Para omitir el paso de la eliminacion de regiones ruidosas
    
    %% Etiquetamos
    I_etiq = funcion_etiquetar(Ibin);
    numEtiquetas = length(unique(I_etiq));
%     figure, funcion_colorea_etiquetas(I_etiq,numEtiquetas)

    %% Filtramos los caracteres, segun el criterio del enunciado
    
    [filas, columnas] = size(R);
    
    fila_superior = floor(filas/3);
    linea_superior = fila_superior*ones(1,columnas);
    
    fila_inferior = fila_superior*2;
    linea_inferior = fila_inferior*ones(1,columnas);
    
%     figure, hold on, imshow(Ibin),    line(1:columnas,linea_superior,'color','r'), line(1:columnas,linea_inferior,'color','r'), hold off
    
    interseccion = intersect(I_etiq(fila_superior,:),I_etiq(fila_inferior,:));
    
    Ipresentes = zeros(filas,columnas);
    for i=1:length(interseccion)
        ROI = I_etiq == interseccion(i);
        Ipresentes(ROI) = interseccion(i);
    end
%     figure, imshow(Ipresentes)
    
    % Los Numero_Objetos objetos de interés están presentes en los 
    % Numero_Objetos+1 objetos mayores de la imagen que contienen al menos 
    % un píxel en la línea horizontal central.
%     Areas = regionprops(Ipresentes,'Area');  Areas = struct2array(Areas);
    Areas = funcion_calcula_areas(Ipresentes);
    [~, indices] = sort(Areas,'descend');
    
    I_filtrada = false(filas,columnas);
    NumPix = Areas(indices(NumObjetos+1));
    for i=1:length(Areas)
       if(Areas(i) >= NumPix)
           I_filtrada(Ipresentes == i) = true;
       end
    end
%     figure, imshow(I_filtrada)

    % De estos Numero Objetos+1 objetos mayores, se debe descartar el 
    % objeto situado a la izquierda de la imagen.
    Ietiq = funcion_etiquetar(I_filtrada);
    
%     if length(unique(Ietiq))-1 > NumObjetos
%         
%     end
    
    ROI = Ietiq == 1;
    Ietiq(ROI) = 0;

    etiquetas = unique(Ietiq); 
    etiquetas(1) = []; % Quitamos el 0
    numEtiquetas = length(etiquetas);
%     figure, funcion_colorea_etiquetas(Ietiq,numEtiquetas)

    %% Mostramos los resultados de los procesos
%     figure, hold on
%         subplot(3,3,1), imshow(I), title('Imagen Original')
%         subplot(3,3,2), imshow(R), title('Componente Roja')
%         subplot(3,3,3), imhist(R), hold on
%             line([umbral, umbral],[1; max(imhist(R))],'Color','red')
%             hold off, title(['Histograma de R con umbral: ' num2str(umbral)])
%         subplot(3,3,4), imshow(Ib), title('Binarizacion con OTSU')
%         subplot(3,3,5), imshow(Ibin), title('Eliminacion regiones ruidosas')
%         subplot(3,3,6), imshow(Ipresentes), title('Filtrado de Objetos en lineas de tercios')
%         subplot(3,3,7), imshow(I_filtrada), title('Filtrado de NumObjetos+1 mayores')
%         subplot(3,3,8), imshow(logical(Ietiq)), title('Quitar objeto izquierdo')
%         
%         aux = Ietiq; aroi = aux == 0; aux(aroi) = 255;
%         subplot(3,3,9), funcion_colorea_etiquetas(aux,numEtiquetas), title('Etiquetado previo a la segmentacion')
%     hold on

    %% Calculamos el bounding box de cada caracter detectado
    Segmentacion = [];
%     figure, hold on
    for i=1:numEtiquetas
        ROI = Ietiq == etiquetas(i);
%     figure, imshow(ROI)
        BB = regionprops(ROI,'BoundingBox'); BB = struct2array(BB); BB = round(BB);
        I_BB = ROI(BB(2):(BB(2)+BB(4)),BB(1):(BB(1)+BB(3)));
%         subplot(1,numEtiquetas,i), imshow(I_BB), title(['Caracter: ' num2str(i)])
%     figure, imshow(I_BB)
        Segmentacion{i} = I_BB;
    end
%     sgtitle('Resultado del proceso de Segmentacion')
%     hold off

end


