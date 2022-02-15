function funcion_colorea_etiquetas(Matriz_Etiquetada,NumObjetos)

    rng('shuffle');
    Colores = uint8((255*rand(NumObjetos,3)));

    R = Matriz_Etiquetada;
    G = Matriz_Etiquetada;
    B = Matriz_Etiquetada;

    for i=1:NumObjetos
        ROI = Matriz_Etiquetada == i;

        R(ROI) = Colores(i,1);
        G(ROI) = Colores(i,2);
        B(ROI) = Colores(i,3);
    end

    Ic = uint8(cat(3,R,G,B));
%     figure,imshow(Ic)
    imshow(Ic)

end