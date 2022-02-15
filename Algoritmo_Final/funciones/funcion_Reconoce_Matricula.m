%% FUNCION RECONOCE MATRICULA:
% OBJETIVO: Segmenta y reconoce cada uno de los numeros y letras que componen las
% imagenes de placas de las matriculas
% VARIABLES:
% - Nombre: Cadena de texto con el nombre del archivo de la imagen a tratar
% - NumObjetos: Numero total de letras y numeros presentes en la imagen,
%   pueden ser 6 o 7 dependiendo de la matricula.
% - Resultado: Datos para poder 
function funcion_Reconoce_Matricula(Nombre, NumObjetos)

    %% Cargamos la imagen original RGB
    I = imread(Nombre);
    
    %% Segmentamos matricula de la imagen original
    ImagenReducida = funcion_segmenta_placa_matricula(I);

    %% Segmentamos los caracteres y los visualizamos
    [Segmentacion, Ietiq] = funcion_segmenta_caracteres(ImagenReducida, NumObjetos);
    
    %% Reconocemos los caracteres segmentados
    [Datos, Matricula, I] = funcion_reconoce_caracteres(ImagenReducida,NumObjetos,Segmentacion,logical(Ietiq));
    
    %% Visualizamos el reconocimiento
    funcion_visualiza_reconocimiento(Datos, Matricula, ImagenReducida)
    
    %% Guardamos los resultados
    save(['./datos_generados/' Nombre '.mat'], 'I', 'Matricula', 'Datos');

end


