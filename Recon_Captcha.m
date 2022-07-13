clc
clear 
close all

load EntrenamientoHU
MomentosHU=Directorio(:,1:7);
Clase=Directorio(:,8);
ModelKNN_captcha=fitcknn(MomentosHU,Clase,'NumNeighbors', 1, 'Distance', 'Euclidean','Standardize',1);

%Leer
[file, path]=uigetfile('*.png','Seleccionar Imagen..');%Para seleccionar la imagen del CAPTCHA
color=imread(strcat(path,file));
gray = rgb2gray(color);
Ibin = imbinarize(gray,"adaptive");
EE = strel('square',8);
Ibind = imclose(Ibin, EE);

figure (1)
imshow(color)
[L, N]=bwlabel(Ibind,8);%Devuelve una matriz que devuelve la etiqueta y el numero de cosos encontrados
C=regionprops(L,'BoundingBox', 'MajorAxisLength','MinorAxisLength');
hold on
pause(1)
for i=1:size(C,1)
  rectangle('Position',C(i).BoundingBox,'EdgeColor','g','LineWidth',3) %Rectangulos para los objetos del CAPTCHA
end
hold off


Numero_simb=[];
resultado=[];

for e=1:N 
    S=L==e;
    M=invmoments(S);
    Numero_simb=[Numero_simb char(predict(ModelKNN_captcha,M))];
    
    obj=uint8(S).*color;
    figure(2)
    imshow(obj)
    pause(0.5);
  
end
box = msgbox(sprintf('El captcha es %s\n', Numero_simb));


Resultados = split(Numero_simb, '=?');
ResultadosNum = zeros(length(Resultados)-1, 1);
for i = 1:length(Resultados)-1
    try
        ResultadosNum(i) = eval(Resultados{i});
    catch
        ResultadosNum(i) = nan;
    end
end
fprintf('El resultado es: ')
disp(ResultadosNum)

box1 = msgbox(sprintf('El captcha es %s\n', num2str(ResultadosNum)));




