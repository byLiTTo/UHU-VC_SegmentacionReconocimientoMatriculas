%% SISTEMA DE SEGMENTACION Y RECONOCIMIENTO DE CARACTERES DE PLACAS DE MATRICULAS

clear all
close all
clc

addpath('./funciones/')
addpath('./datos_generados/')
addpath('../Imagenes/')
addpath('../Material_Imagenes_Plantillas/00_Plantillas')
addpath('../Material_Imagenes_Plantillas/01_Training')
addpath('../Material_Imagenes_Plantillas/02_Test')



%% ========================================================================
%% Generamos los datos de la matriculas
%% ========================================================================

NumObjetos = [7 7 7 7 7 6 6 7 7 7 7 6 7 7 7 7 7 7];
NumImagenes = 18;

for i=1:NumImagenes
    Nombre = [num2str(i, '%02d') '.JPG'];
    funcion_Reconoce_Matricula(Nombre, NumObjetos(i));
end



%% ========================================================================
%% ANTES DE ACABAR
%% ========================================================================


rmpath('./funciones/')
rmpath('./datos_generados/')
rmpath('../Imagenes/')
rmpath('../Material_Imagenes_Plantillas/00_Plantillas')
rmpath('../Material_Imagenes_Plantillas/01_Training')
rmpath('../Material_Imagenes_Plantillas/02_Test')


