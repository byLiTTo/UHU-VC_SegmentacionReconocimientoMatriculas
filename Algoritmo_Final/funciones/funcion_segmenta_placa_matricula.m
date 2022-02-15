function ImagenColorReducida = funcion_segmenta_placa_matricula(ImagenColor)

    %% 1.1: Reducir resolucion a 120 columnas

    [filas, columnas, ~] = size(ImagenColor);
    factor_reduccion = columnas/120;

    filas_reducida = filas/factor_reduccion;
    columnas_reducida = columnas/factor_reduccion;

    Ireducida = imresize(ImagenColor,[filas_reducida columnas_reducida]);
%     figure, imshow(Ireducida)

    %% 1.2: Imagen de intensidad

    I = rgb2gray(Ireducida);
%     figure, imshow(I)

    %% 1.3: Transformacion logaritmica

    Ilog = 100+ 20*log(double(I)+1);
%     figure, imshow(uint8(Ilog))
    
    %% ====================================================================
    
    %% 2.1: Aplicar mascara bordes horizontales PREWITT

    Hx = [-1 0 1; -1 0 1; -1 0 1];

    Gx = imfilter(Ilog,Hx,'replicate');
    Iprewitt = abs(Gx);
%     figure, imshow(mat2gray(Iprewitt))

    %% 2.2: Filtro de orden

    Ifilt = funcion_FiltroOrden(Iprewitt,3,24,80);
%     figure, imshow(mat2gray(Ifilt))

    %% 2.3: Calcular por cada fila la media de las columnas

    Vector_F = zeros(filas_reducida,1);
    for i=1:filas_reducida
        Vector_F(i,1) = mean(Ifilt(i,:));
    end

%     figure, plot(Vector_F(length(Vector_F):-1:1),-1*(length(Vector_F):-1:1))

    %% 2.4: Vector de proyecciones suavizado con media movil central

    ventana = filas_reducida*0.1;
    aumento = floor(ventana/2);

    Vector_ampliado = padarray(Vector_F,aumento,'symmetric');

    Vector_FSuav = zeros(filas_reducida,1);
    for i=1:filas_reducida
        ROI = Vector_ampliado(i:i+2*aumento,:);
        Vector_FSuav(i) = mean(ROI);
    end

%     figure, plot(Vector_FSuav(length(Vector_FSuav):-1:1),-1*(length(Vector_FSuav):-1:1))

    %% 2. 5: Encontrar filas de los dos maximos

    f_max1 = find(max(Vector_FSuav) == Vector_FSuav);

    Vector_temp = zeros(filas_reducida,1);
    for i=1:filas_reducida
        Vector_temp(i) = (i - f_max1)^2 * Vector_FSuav(i);    
    end
    f_max2 = find(max(Vector_temp) == Vector_temp);

    if f_max1 < f_max2
        f_min = find(Vector_FSuav == min(Vector_FSuav(f_max1:f_max2)));
    else
        f_min = find(Vector_FSuav == min(Vector_FSuav(f_max2:f_max1)));
    end

%     figure, plot(Vector_FSuav(length(Vector_FSuav):-1:1),-1*(length(Vector_FSuav):-1:1)), hold on
%         plot(Vector_FSuav(f_max1),-1*f_max1,'*r')
%         plot(Vector_FSuav(f_max2),-1*f_max2,'+r')
%         plot(Vector_FSuav(f_min),-1*f_min,'*b')
%         legend('Vector','f_m_a_x_1','f_m_a_x_2','f_m_i_n')
%     hold off

    %% 2.6: Seleccionar el maximo asociado a la fila de la matricula
    seleccionado = [];
    descartado = [];

    limite_ini = length(Vector_FSuav)*0.1;
    limite_fin = length(Vector_FSuav)*0.9;

    if f_max1 < limite_ini ||f_max1 > limite_fin
        seleccionado = f_max2;
        descartado = f_max1;
    else
        if f_max2 < limite_ini || f_max2 > limite_fin
            seleccionado = f_max1;
            descartado = f_max2;
        else
            if Vector_FSuav(f_max2) <= 0.6*Vector_FSuav(f_max1)
                seleccionado = f_max1;
                descartado = f_max2;
            else
                columna_ini = round(0.25*columnas_reducida);
                columna_fin = round(0.75*columnas_reducida);

                porciento_min = round(0.25*length(perfil_f1));
                porciento_max = round(0.75*length(perfil_f1));

                perfil_f1 = I(f_max1,columna_ini:columna_fin);
                perfil_f1_ascend = sort(perfil_f1,'ascend');
                perfil_f1_descend = sort(perfil_f1,'descend');

                maximo_f1 = mean(perfil_f1_ascend(1:porciento_max));
                minimo_f1 = mean(perfil_f1_descend(1:porciento_min));

                cociente_f1 = maximo_f1/minimo_f1;

                perfil_f2 = I(f_max2,columna_ini:columna_fin);
                perfil_f2_ascend = sort(perfil_f2,'ascend');
                perfil_f2_descend = sort(perfil_f2,'descend');

                maximo_f2 = mean(perfil_f2_ascend(1:porciento_max));
                minimo_f2 = mean(perfil_f2_descend(1:porciento_min));

                cociente_f2 = maximo_f2/minimo_f2;

                if cociente_f1 > cociente_f2
                    seleccionado = f_max1;
                    descartado = f_max2;
                else
                    seleccionado = f_max2;
                    descartado = f_max1;
                end

            end
        end
    end

    %% 2.7: Eliminar la contribucion del maximo descartado

    if descartado < f_min
        Vector_FSuav(1:f_min) = Vector_FSuav(f_min);
    else
        Vector_FSuav(f_min:end) = Vector_FSuav(f_min);
    end
%     figure, plot(Vector_FSuav(length(Vector_FSuav):-1:1),-1*(length(Vector_FSuav):-1:1))

    %% 2.8: Encontrar las filas que delimitan el contorno horizontal

    maximo = max(Vector_FSuav);
    umbral = maximo*0.4;
    ROI = Vector_FSuav > umbral;
    Vector_mod = Vector_FSuav;
    Vector_mod(ROI) = 0;

    fila_min_placa = find(Vector_mod == max(Vector_mod(1:seleccionado)));
    fila_max_placa = find(Vector_mod ==  max(Vector_mod(seleccionado:filas_reducida)));

%     figure, plot(Vector_mod(filas_reducida:-1:1),-1*(filas_reducida:-1:1)), hold on
%         plot(Vector_mod(fila_min_placa),-1*fila_min_placa,'*r')
%         plot(Vector_mod(fila_max_placa),-1*fila_max_placa,'*b')
%         legend('Vector','Maximo Izquierda','Maximo Derecha')
%     hold off

    %% 2.9: Delimitar la imagen al rango abarcado por las filas encontradas

    Ired = I(fila_min_placa:fila_max_placa,:);
%     figure, imshow(Ired);

    %% ====================================================================

    %% 3.1: Aplicar mascara de bordes verticales de PREWITT

    Ilog2 = Ilog(fila_min_placa:fila_max_placa,:);

    Hx = [-1 0 1; -1 0 1; -1 0 1];

    Gx = imfilter(double(Ired),Hx,'replicate');
%     Gx = imfilter(Ilog2,Hx,'replicate');
    Iprewitt2 = abs(Gx);
%     figure, imshow(mat2gray(Iprewitt2))

    %% 3.2: Apertura morfologica con vecindad vertical

    nhood = ones(round(size(Iprewitt2,1)/2),1);

    Imorf = imopen(Iprewitt2,nhood);
%     figure, imshow(mat2gray(Imorf))

    %% 3.3: Calcular por cada columna la media de las filas

    Vector_C = zeros(columnas_reducida,1);
    for i=1:columnas_reducida
        Vector_C(i) = mean(Imorf(:,i));
    end
%     figure, plot(Vector_C)

    %% 3.4: Vector de proyecciones suavizado con media movil central

    ventana = 3;
    aumento = floor(ventana/2);

    Vector_ampliado = padarray(Vector_C,aumento,'symmetric');

    Vector_CSuav = zeros(columnas_reducida,1);
    for i=1:columnas_reducida
        ROI = Vector_ampliado(i:i+2*aumento,:);
        Vector_CSuav(i) = mean(ROI);
    end
%     figure, plot(Vector_CSuav)

    %% 3.5: Encontrar contribuciones significativas

    Vector_ascend = sort(Vector_CSuav,'ascend');
    porciento_min = round(columnas_reducida*(10/100));

    valor_medio = mean(Vector_ascend(porciento_min:end));

    Ib_significativas = Vector_CSuav > valor_medio;
    columnas_significativas = find(Ib_significativas);

%     figure, plot(Vector_CSuav), hold on
%         for i=1:length(columnas_significativas)
%             pos = columnas_significativas(i);
%             plot(pos,Vector_CSuav(pos),'*r')
%         end
%     hold off

    %% 3.6: Determina proyecciones horizontales de la componente azul

    Breducida = Ireducida(:,:,3);
%     figure, imshow(Breducida)

    Bred = Breducida(fila_min_placa:fila_max_placa,:);
%     figure, imshow(Bred)

    Vector_B = mean(double(Bred))';
%     figure, plot(Vector_B)

%     ventana = 3;
%     aumento = floor(ventana/2);
% 
%     Vector_Bamp = padarray(Vector_B,aumento,'symmetric');
% 
%     Vector_BSuav = zeros(columnas_reducida,1);
%     for i=1:columnas_reducida
%         ROI = Vector_Bamp(i:i+2*aumento,:);
%         Vector_BSuav(i) = mean(ROI);
%     end
% %     figure, plot(Vector_BSuav)

    Vector_Bascend = sort(Vector_B,'ascend');
    valor_referencia = prctile(Vector_Bascend,20);

    Ib_candidatas = Ib_significativas & (Vector_B > valor_referencia);
    columnas_candidatas = find(Ib_candidatas);

%     figure, plot(Vector_CSuav), hold on
%         for i=1:length(columnas_candidatas)
%             pos = columnas_candidatas(i);
%             plot(pos,Vector_CSuav(pos),'*r')
%         end
%     hold off

    %% 3.7: Posicion de columnas del limite de matricula

    columna_min_placa = columnas_candidatas(1);
    columna_max_placa = columnas_candidatas(end);

    Isolucion = Ired(:,columna_min_placa:columna_max_placa);
%     figure, imshow(Isolucion)

    %% ====================================================================
    
     %% 4.1: Encuentra la posicion de filas y columnas de tamañao original

    fila_min = round(fila_min_placa *factor_reduccion);
    fila_max = round(fila_max_placa *factor_reduccion);

    columna_min = round(columna_min_placa*factor_reduccion);
    columna_max = round(columna_max_placa*factor_reduccion);

    %% 4.2: Reducir en una cincuenteava parte el rango de columnas

    rango = columna_max-columna_min+1;
    reduccion = round(rango*(1/50));
    columna_min = columna_min+reduccion;
    columna_max = columna_max-reduccion;

    %% 4.3:

    ImagenColorReducida = ImagenColor(fila_min:fila_max,columna_min:columna_max,:);
%     figure, hold on
%         subplot(1,2,1), imshow(ImagenColor), title('Imagen original')
%         subplot(1,2,2), imshow(ImagenColorReducida), title('Matricula segmentada')
%         sgtitle('Resultado segmentacion de placa de matricula')
%     hold off

end