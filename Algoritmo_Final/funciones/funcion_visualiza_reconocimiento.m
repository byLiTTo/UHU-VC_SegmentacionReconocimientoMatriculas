%% FUNCION VISUALIZA RECONOCIMIENTO
function funcion_visualiza_reconocimiento(Datos, Matricula, I)
    
    figure, hold on
        imshow(I), title(Matricula)
        for i=1:size(Datos,1)
            Centroide = cell2mat(Datos(i,1));
            
            x_BB = cell2mat(Datos(i,2));
            y_BB = cell2mat(Datos(i,3));

            line(x_BB,y_BB,'Color','red')
            hold on, plot(Centroide(1),Centroide(2),'.r'), hold off
        end
    hold off

end


