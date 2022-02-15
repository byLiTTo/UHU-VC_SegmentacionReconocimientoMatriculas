%% FUNCION RECONOCE CARACTERES
function [Datos, Matricula, I] = funcion_reconoce_caracteres(I,NumObjetos,Segmentacion,Ietiq)

    %% Cargamos las plantillas
    load('Plantillas.mat');
    
    Caracteres = '0123456789ABCDFGHKLNRSTXYZ';
    NumCaracteres = length(Caracteres);
    NumAngulos = 7;
    
    %% Inicializamos las variables locales   
    ValorCorrelacion = 0;
    Caracter = ' ';
    
    Matricula = '';
    Datos = [];
    Resultado = [];

    Objeto = 'Objeto';
    Angulo = 'Angulo';
    
    %% Por cada caracter buscamos el que mayor correlacion tenga
    for i=1:NumObjetos
        Candidato = Segmentacion{i};
        ValorCorrelacion = 0;
        Caracter = ' ';
        objeto = 1;
        angulo = 1;
        
        for j=1:NumCaracteres
            for k=1:NumAngulos
                nombre_Plantilla = [Objeto num2str(j, '%02d') Angulo num2str(k, '%02d')];
                eval(['T = ' nombre_Plantilla ';'])
                
                %% Redimensionamos para que tengan el mismo tamaño
                X = imresize(Candidato,size(T));
                
                VC = funcion_CorrelacionEntreMatrices(X,T);
                
                %% Nos quedamos con el valor de correlacion mayor
                if(VC > ValorCorrelacion)
                    ValorCorrelacion = VC;
                    Caracter = Caracteres(j);
                    objeto = j;
                    angulo = k;
                end
            end
        end
        
        %% Si el numero de filas o columnas es par, convertimos en impar
        [NC, MC]=size(Candidato); % Filas y columnas de la plantilla
        if  rem(NC,2)==0
            Candidato(NC+1,:) = 0;
        end
        if  rem(MC,2)==0
            Candidato(:,MC+1) = 0;
        end    

        %% Buscamos el punto con mayor semejanda entre el candidato y la imagen
        % ese punto lo tomaremos como centroide
        NCC = funcion_NormCorr2(Ietiq, Candidato);

        [y_centro, x_centro] = find(NCC == max(NCC(:)));
        Centroide = [x_centro y_centro];
        
        %% Calculamos los puntos del BoundingBox
        numFil = floor(NC/2);
        numCol = floor(MC/2);

        x_BB = [x_centro-numCol, x_centro+numCol, x_centro+numCol, x_centro-numCol, x_centro-numCol];
        y_BB = [y_centro-numFil, y_centro-numFil, y_centro+numFil, y_centro+numFil, y_centro-numFil];
        
        Matricula = [Matricula Caracter];
        
        Datos{i,1} = Centroide;
        Datos{i,2} = x_BB;
        Datos{i,3} = y_BB;
        
    end

end


