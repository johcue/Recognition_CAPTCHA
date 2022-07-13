%% Reconocimiento Alfabeto de Señales de Manos
% Restamos los momentos de Hu a cada imagen y el que de menor, pues esa
% será la letra
clc
clear 
close all

load EntrenamientoPlacas
MomentosHU_PlacaLetras=PlacaLetNums(:,1:7);
Clase_PlacaLetras=PlacaLetNums(:,8);
ModelKNN_Letras=fitcknn(MomentosHU_PlacaLetras,Clase_PlacaLetras,'NumNeighbors', 1, 'Distance', 'euclidean','Standardize',1);


%Leemos 
%Icolor=imread('FNP_77D.jpg');
[file path]=uigetfile('*.jpg','Seleccionar Imagen..')%Para seleccionar la imagen
Icolor=imread(strcat(path,file));
figure (1)
imshow(Icolor)
%Para enderezar la imagen
% puntoInicial=ginput(4)%Se marcan 4 puntos inicales
% puntoFinal=ginput(4)%Se marcan 4 puntos finales
% M=cp2tform(puntoInicial, puntoFinal,'projective');
% Icolor=imtransform(Icolor,M);

[B, maskR]=Mascara_Placa(Icolor); 
%Ibind=bwareaopen(~B,2500); %1570
Ibind = bwareafilt(~B,[2500 95000]); 

figure(2)
subplot(2,1,1)
imshow(B)
title('Imagen Binarizada por HSV')
subplot(2,1,2)
imshow(Ibind)
title('Imagen Binarizada Cerrada')



figure(3)
imshow(Icolor)
[L N]=bwlabel(Ibind,8);%Devuelve una matriz que devuelve la etiqueta y el numero de cosos encontrados (pueden ser 4 u 8, como las placas tienen 6 caracteres dejo 8)
C=regionprops(L,'BoundingBox',  'MajorAxisLength', 'MinorAxisLength');
hold on
pause(1)
for i=1:size(C,1)
  rectangle('Position',C(i).BoundingBox,'EdgeColor','g','LineWidth',3) %Rectangulos para los objetos de las placas
end
hold off


Placa_Letras=[];

for e=1:N 
    S=L==e;
    
    M=invmoments(S);
    Placa_Letras=[Placa_Letras char(predict(ModelKNN_Letras,M))];
    
    obj=uint8(S).*Icolor;
    figure(4)
    imshow(obj)
    pause(0.5);
  
end
% file = fopen('Placa.txt', 'wt');
%     fprintf(file,'%s\n',Placa_Final);
%     fclose(file);                     
%     winopen('Placa.txt')
box = msgbox(sprintf('El numero de placa es %s\n',Placa_Letras));


















