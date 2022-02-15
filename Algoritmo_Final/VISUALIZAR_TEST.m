%% SISTEMA DE SEGMENTACION Y RECONOCIMIENTO DE CARACTERES DE PLACAS DE MATRICULAS

clear all
close all
clc

addpath('./funciones/')
addpath('./datos_generados/')
addpath('../Material_Imagenes_Plantillas/00_Plantillas')
addpath('../Material_Imagenes_Plantillas/01_Training')
addpath('../Material_Imagenes_Plantillas/02_Test')



%% ========================================================================
%% Generamos los datos de la matriculas
%% ========================================================================

NumImagenes = 18;

for i=1:NumImagenes
    Nombre = [num2str(i, '%02d') '.JPG.mat'];
    load(Nombre);
    funcion_visualiza_reconocimiento(Datos, Matricula, I)
end



%% ========================================================================
%% ANTES DE ACABAR
%% ========================================================================


rmpath('./funciones/')
rmpath('./datos_generados/')
rmpath('../Material_Imagenes_Plantillas/00_Plantillas')
rmpath('../Material_Imagenes_Plantillas/01_Training')
rmpath('../Material_Imagenes_Plantillas/02_Test')


