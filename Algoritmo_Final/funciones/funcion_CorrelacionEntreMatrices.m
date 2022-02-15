function ValorCorrelacion = funcion_CorrelacionEntreMatrices (Matriz1, Matriz2)
    
%     [M, N] = size(Matriz1);
%     media1 = mean(Matriz1(:));
%     media2 = mean(Matriz2(:));
% 
%     Medias1 = media1 .* ones(M,N);
%     Medias2 = media2 .* ones(M,N); 
%     
%     
%     Numerador = 0;
%     Denominador = 0;
%     
%     for i=1:M
%         for j=1:N
%             Numerador = Numerador + ( (Matriz1(i,j) - media1)*(Matriz2(i,j) - media2) );
%             Denominador = Denominador + sqrt( (Matriz1(i,j) - media1)^2 *(Matriz2(i,j) - media2)^2 );
%         end
%     end
%     
%     ValorCorrelacion = Numerador/Denominador;

    Matriz1 = double(Matriz1);
    Matriz2 = double(Matriz2);
    
    Desviacion1 = Matriz1 - mean(Matriz1(:));
    Desviacion2 = Matriz2 - mean(Matriz2(:));
    
    Varianza1 = Desviacion1.^2;
    Varianza2 = Desviacion2.^2;
    
    Numerador = sum(sum(Desviacion1 .* Desviacion2));
    Denominador = sqrt(sum(sum(Varianza1)) * sum(sum(Varianza2)));
    
    ValorCorrelacion = Numerador/Denominador;

end