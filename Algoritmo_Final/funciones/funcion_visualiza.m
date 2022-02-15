function funcion_visualiza(I,ROI,color)
    [nFila nColumna Dimension] = size(I);
    if Dimension == 1
        I = cat(3,I,I,I);
    end
    R = I(:,:,1);
    G = I(:,:,2);
    B = I(:,:,3);
    
    R(ROI) = color(1);
    G(ROI) = color(2);
    B(ROI) = color(3);
    
    Ic = cat(3,R,G,B);
    %figure,subplot(1,2,1),imshow(I)
    %      ,subplot(1,2,2),imshow(Ic)
    imshow(Ic)
end