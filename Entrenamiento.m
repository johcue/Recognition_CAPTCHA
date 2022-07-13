clear 
close all
clc

Path = 'C:\Users\57318\Documents\Aprendizaje_Maquina\Machine_Learning_FISC\Clase\CAPTCHA\Entrenamiento';

FullFile = fullfile(Path, '*.png');
Files = dir(FullFile);
Directorio=zeros(length(Files), 8);
cont = 1;

for k = 1:length(Files)
  baseFileName = Files(k).name;
  fullFileName = fullfile(Path, baseFileName);
  color = imread(fullFileName);
  gray = rgb2gray(color);
  Ibin = imbinarize(gray,"adaptive");
  EE = strel('square',8);
  Ibind = imclose(Ibin, EE);
  
  figure (1)
  imshow(Ibind)
  title('Imagen Binarizada Cerrada')
  pause(0.1)
  
  [L, N] = bwlabel(Ibind,4);
  data = zeros(1,N);
  
    for E = 1:N
        S = L == E;
        C = regionprops(S,"BoundingBox","Image");

        figure(2)
        imshow(uint8(S).*color)
        rectangle('Position',C.BoundingBox,'EdgeColor','r','LineWidth',2)
        pause(0.5)

        figure(3)
        imshow(C.Image)
        D = C.Image;
        %         Feature = D(:)';
        M = invmoments(D);
        l = input('¿Caracter?')
        data(E,1:7) = M;
        data(E,8) = char(l);

        %imshow(I);  % Display image.
        drawnow; % Force display to update immediately.
        Directorio(cont,:) = [data(E,1:7) data(E,8)];
        cont=cont+1;
    end
end

save('HU_entrenamiento.mat', 'Directorio')

Resultados = split(char(Directorio(:, 8))', '=?');
ResultadosNum = zeros(length(Resultados)-1, 1);
for i = 1:length(Resultados)-1
    try
        ResultadosNum(i) = eval(Resultados{i});
    catch
        ResultadosNum(i) = nan;
    end
end

A = [Resultados(1:end-1) cellstr(num2str(ResultadosNum))];

save('EvalEntrenamiento.mat', 'A')

%xlswrite('HU_Entrenamiento.xlsx',Directorio);