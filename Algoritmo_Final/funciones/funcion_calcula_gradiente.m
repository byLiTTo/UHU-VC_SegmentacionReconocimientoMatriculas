function [Gx, Gy, ModG] = funcion_calcula_gradiente(I, Hx,Hy)

    Gx = imfilter(double(I),Hx,'symmetric');
    Gy = imfilter(double(I),Hy,'symmetric');
    
    ModG = sqrt(Gx.^2 + Gy.^2);

end