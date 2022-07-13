clear
close all
clc

load('EntrenamientoHU.mat')
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


