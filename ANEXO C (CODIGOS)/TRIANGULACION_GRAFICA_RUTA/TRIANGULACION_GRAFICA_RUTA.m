clear
close all
clc
%% --------------------------------------------------------------------------
%
% DESCRIPTION: Estima la posición mediante la triangulación, utilizando el promedio de las medidas de ángulos.
%              Asimismo, se representan gráficamente las rutas correspondientes al Escenario 3 mediante
%              diversas herramientas de estimación de posición.(La orientacion del nodo movil se calcula
%              con las medidas de angulo del AoA1 y AoA4)

%      INPUTS:  ruta= ruta de cada uno de los archivos .txt que contiene
%               las medidas de AoA.
% 
%               (X1,Y1), (X2,Y2), (X3,Y3), (X4,Y4) - Cada pareja de 
%               variables contiene la posicion de los beacons en el
%               escenario.

%               posicionesT = Posiciones Teoricas de cada punto de referencia

%     OUTPUTS: posicionesR= Estima la posicion (x, y) de cada punto de
%              referencia.

%              distancias - Estima la distancia de error de cada beacon al punto
%              teorico.
%
%% --------------------------------------------------------------------------
%ruta = 'C:\Users\user\Desktop\Todo TG\Trabajo De Grado\medidas AoA todo\MEDIDAStxtsalon127\Medidas sin obstruccion aoa - salon 127\';
ruta = 'C:\Users\user\Desktop\Todo TG\Trabajo De Grado\medidas AoA todo\MEDIDAStxtsalon127\Medidas con obstruccion aoa - salon 127_arregladas\';
%ruta = 'C:\Users\user\Desktop\Todo TG\Trabajo De Grado\medidas AoA todo\MEDIDAStxtsalon127\Medidas con obstruccion aoa - salon 127\';

archivos = dir(fullfile(ruta, '*.txt'));
numArchivos = length(archivos);
promedios = zeros(numArchivos, 4);
posicionesR=[];
distancias=[];
orientaciones = cell(numArchivos, 1);

posicionesT = [4,3; 4,4; 4,5; 3,5; 2,5; 1,5; 1,4; 1,3; 1,2; 1,1;
    2,1; 3,1; 4,1; 5,1; 5,2; 5,3; 5,4; 5,5; 6,5; 7,5;
    8,5; 8,4; 8,3; 8,2; 8,1; 7,1; 6,1];
X1=0;
X4=0;
Y1=0;
Y4=6;
X2=9;
X3=9;
Y2=0;
Y3=6;


for i = 1:numArchivos
    archivo = archivos(i).name;
    datos = load(fullfile(ruta, archivo));

    AoA1 = (datos(:, 1));
    AoA2 = (datos(:, 2));
    AoA3 = (datos(:, 3));
    AoA4 = (datos(:, 4));

    AoA1promedio = mean(datos(:, 1));
    AoA2promedio = mean(datos(:, 2));
    AoA3promedio = mean(datos(:, 3));
    AoA4promedio = mean(datos(:, 4));

    promedios(i, :) = [AoA1promedio, AoA2promedio, AoA3promedio, AoA4promedio];

    AoA1promedio = promedios(i, 1);
    AoA2promedio = promedios(i, 2);
    AoA3promedio = promedios(i, 3);
    AoA4promedio = promedios(i, 4);

    if  AoA1promedio < 0 && AoA4promedio > 0
        orientaciones{i} = 'arriba';
    elseif AoA1promedio > 0 && AoA4promedio > 0
        orientaciones{i} = 'izquierda';
    elseif AoA1promedio > 0 && AoA4promedio < 0
        orientaciones{i} = 'abajo';
    else
        orientaciones{i} = 'derecha';
    end

    AoA1=AoA1promedio;
    AoA2=AoA2promedio;
    AoA3=AoA3promedio;
    AoA4=AoA4promedio;

    if i <= 13

        if orientaciones(i) == "arriba"
            tetaC1 = 180 + AoA1;
            tetaC4 = 180 - AoA4;
            teta1 = 180 - 90 - abs(tetaC1);
            teta4 = 180 - 90 - abs(tetaC4);
            xreal = X1 + ((Y4 - Y1) * tand(teta1) * tand(teta4)) / (tand(teta1) + tand(teta4));
            yreal = (Y1 * tand(teta1) + Y4 * tand(teta4)) / (tand(teta1) + tand(teta4));

        elseif orientaciones(i) == "izquierda"
            tetaC1 = -90 + AoA1;
            tetaC4 = 90 - AoA4;
            teta1 = 180 - 90 - abs(tetaC1);
            teta4 = 180 - 90 - abs(tetaC4);
            xreal = X1 + ((Y4 - Y1) * tand(teta1) * tand(teta4)) / (tand(teta1) + tand(teta4));
            yreal = (Y1 * tand(teta1) + Y4 * tand(teta4)) / (tand(teta1) + tand(teta4));

        elseif orientaciones(i) == "abajo"
            tetaC1 = AoA1;
            tetaC4 = -AoA4;
            teta1 = 180 - 90 - abs(tetaC1);
            teta4 = 180 - 90 - abs(tetaC4);
            xreal = X1 + ((Y4 - Y1) * tand(teta1) * tand(teta4)) / (tand(teta1) + tand(teta4));
            yreal = (Y1 * tand(teta1) + Y4 * tand(teta4)) / (tand(teta1) + tand(teta4));

        else %derecha
            tetaC1 = AoA1 + 90;
            tetaC4 = -AoA4 - 90;
            teta1 = 180 - 90 - abs(tetaC1);
            teta4 = 180 - 90 - abs(tetaC4);
            xreal = X1 + ((Y4 - Y1) * tand(teta1) * tand(teta4)) / (tand(teta1) + tand(teta4));
            yreal = (Y1 * tand(teta1) + Y4 * tand(teta4)) / (tand(teta1) + tand(teta4));

        end

    else  %%punto14-27

        if orientaciones(i) == "arriba"
            tetaC2 = AoA2;
            tetaC3 = AoA3;
            AoA2 = tetaC2;
            AoA3 = tetaC3;
            teta2 = 180 - 90 - abs(tetaC2);
            teta3 = 180 - 90 - abs(tetaC3);
            xreal = X3 - (Y3 - ((Y3 * tand(teta3) + Y2 * tand(teta2)) / (tand(teta2) + tand(teta3)))) * tand(teta3);
            yreal = (Y3 * tand(teta3) + Y2 * tand(teta2)) / (tand(teta3) + tand(teta2));


        elseif orientaciones(i) == "izquierda"

            tetaC2=180+AoA2;
            tetaC3=90+AoA3;
            teta2=180-90-abs(tetaC2);
            teta3=180-90-abs(tetaC3);
            xreal=X3-(Y3-((Y3*tand(teta3)+Y2*tand(teta2))/(tand(teta2)+tand(teta3))))*tand(teta3);
            yreal=(Y3*tand(teta3)+Y2*tand(teta2))/(tand(teta3)+tand(teta2));

        elseif orientaciones(i) == "abajo"
            tetaC2=180-AoA2;
            tetaC3=180+AoA3;
            teta2=180-90-abs(tetaC2);
            teta3=180-90-abs(tetaC3);
            xreal=X3-(Y3-((Y3*tand(teta3)+Y2*tand(teta2))/(tand(teta2)+tand(teta3))))*tand(teta3);
            yreal=(Y3*tand(teta3)+Y2*tand(teta2))/(tand(teta3)+tand(teta2));

        else %derecha
            tetaC2=-AoA2+90;
            tetaC3=AoA3-90;
            teta2=180-90-abs(tetaC2);
            teta3=180-90-abs(tetaC3);
            xreal=X3-(Y3-((Y3*tand(teta3)+Y2*tand(teta2))/(tand(teta2)+tand(teta3))))*tand(teta3);
            yreal=(Y3*tand(teta3)+Y2*tand(teta2))/(tand(teta3)+tand(teta2));

        end
    end
    posicionesR = [posicionesR; xreal yreal];
    distancia=sqrt(((posicionesR(i)-posicionesT(i))^2)+((posicionesR(i,2)-posicionesT(i,2))^2))*100;
    distancias=[distancias;distancia];

end

%% GRAFICA

plot(X1, Y1, 'o', 'LineWidth', 10,'Color', '#77AC30');
hold on
text(0,-0.2, 'NODO 1', 'HorizontalAlignment', 'center','VerticalAlignment', 'top', 'FontSize', 11);
plot(X2, Y2, 'o','LineWidth', 10,'Color', '#77AC30')
text(9,-0.2, 'NODO 2', 'HorizontalAlignment', 'center','VerticalAlignment', 'top', 'FontSize', 11);
hold on
plot(X3, Y3, 'o','LineWidth', 10,'Color', '#77AC30')
text(9,6.5, 'NODO 3', 'HorizontalAlignment', 'center','VerticalAlignment', 'top', 'FontSize', 11);
hold on
plot(X4, Y4, 'o','LineWidth', 10,'Color', '#77AC30')
text(0,6.5, 'NODO 4', 'HorizontalAlignment', 'center','VerticalAlignment', 'top', 'FontSize', 11);
hold on

text(4.4,3.1, 'INICIO', 'HorizontalAlignment', 'center','VerticalAlignment', 'top', 'FontSize', 10,'FontWeight', 'bold');
text(6,0.85, 'FIN', 'HorizontalAlignment', 'center','VerticalAlignment', 'top', 'FontSize', 10,'FontWeight', 'bold');

numerosPuntos= 1:27;
for i = 1:length(numerosPuntos)
    text(posicionesT(i,1), posicionesT(i,2), num2str(numerosPuntos(i)),...
        'HorizontalAlignment', 'left', 'VerticalAlignment', 'bottom','FontWeight', 'bold','FontSize', 15);
end

hold on
plot([X1, X2], [Y1, Y2], '-o','LineWidth', 2, 'Color', 'black');
plot([X2, X3], [Y2, Y3], '-o','LineWidth', 2, 'Color', 'black');
plot([X3, X4], [Y3, Y4], '-o','LineWidth', 2, 'Color', 'black');
plot([X4, X1], [Y4, Y1], '-o','LineWidth', 2, 'Color', 'black');

%GRAFICA DE RUTA TEORICA
rutaTeorica = posicionesT

plot(rutaTeorica(:, 1), rutaTeorica(:, 2),'-o','LineWidth', 1.5, 'Color', '#0072BD');
hold on
grid on

%GRAFICA DE LA RUTA CON PROMEDIOS
rutaReal = posicionesR;
plot(rutaReal(1:27, 1), rutaReal(1:27, 2),'-^','LineWidth', 1.5, 'Color','black' );
hold on
grid on

hxlabel=xlabel('Coordenada X [metros]');
hylabel=ylabel('Coordenada Y [metros]');

set(gca, 'FontSize', 15);

%% RUTA MINIMOS
% load('minimos.mat');
load('minimosobs.mat');
plot(estimaciones(:, 1), estimaciones(:, 2),'--square','LineWidth', 1.5, 'Color', '#FFD700');
hold on

%% RUTA EKF

% kalmansinobs= [4, 3; 3.02380029, 5.30153527; 2.71789809, 4.79714164; 2.13920721, 4.80962272; ...
%     0.96850312, 5.3033099; 0.01255403, 6.04333451; 4.04572059, 7.9283816; 4.06260648, 5.88253863; ...
%     1.31784803, 1.34793225; 1.3821624, 1.56582798; 3.38082615, 1.80266583; 4.14942588, 1.59151924; ...
%     6.22462594, 1.12927082; 5.06666654, 1.6237394; 5.70221564, 1.83311404; 5.32459441, 3.66228793; ...
%     5.38445665, 3.4120535; 6.78185505, 4.52390934; 6.62292814, 5.70237842; 6.68138433, 4.18295966; ...
%     7.97105968, 4.23744794; 8.18857729, 4.27144086; 7.84298624, 2.39745115; 8.21446277, 1.3076392; ...
%     8.19124589, 0.86780544; 8.50390611, 4.31019127; 8.22108261, 4.11035282];

kalmanconobs = [ [4, 3];[2.06754024, 3.81167669];[2.65333508, 4.94438757];[2.0828833, 5.02010899];[1.25166459, 5.28191881];
    [0.2968675, 5.78447304]; [0.60535842, 3.99784595];[0.89709916, 2.4363509];[1.59716977, 2.25212725];
    [1.67960566, 2.0948762];[2.71294658, 1.40932425]; [4.51007219, 0.60150227];[6.00672945, 1.65893044];
    [6.03460903, 1.66293098]; [5.77331324, 2.27371299];[5.45739904, 2.56204382]; [4.34052724, 2.49385822];
    [5.96314007, 3.89574029]; [6.50406067, 5.88427957]; [7.43859567, 5.16595792];[7.4615135, 5.61975289];
    [7.46230109, 3.80779668];[7.14152091, 3.27632912]; [8.13034621, 1.58144594];
    [7.26386081, 1.52396729];[7.56195792, 2.86252823]; [9.82967143, 6.56029016] ];

%plot(kalmansinobs(:, 1), kalmansinobs(:, 2),'--pentagram','LineWidth', 1.5, 'Color', '#77AC30');
plot(kalmanconobs(:, 1), kalmanconobs(:, 2),'--pentagram','LineWidth', 1.5, 'Color', '#77AC30')
hold on

% ruta KMEANS
% load('kmeansobs.mat');
load('RMEANSSINOBS.mat');
plot(posicionesRMEANS(:, 1), posicionesRMEANS(:, 2),'--diamond','LineWidth', 1.5, 'Color', 'r');
hold on

quiver(4,3, 0, 0.5, 'MaxHeadSize', 20, 'LineWidth', 1.6, 'Color', 'red');
quiver(4,5, -0.5, 0, 'MaxHeadSize', 20, 'LineWidth', 1.6, 'Color', '#77AC30');
quiver(1, 5, 0,-0.5, 'MaxHeadSize', 20, 'LineWidth', 1.6, 'Color', 'blue');
quiver(1, 1, 0.5,0, 'MaxHeadSize', 20, 'LineWidth', 1.6, 'Color', 'black');
quiver(5,1, 0, 0.5, 'MaxHeadSize', 20, 'LineWidth', 1.6, 'Color', 'red');

quiver(5, 5, 0.5,0, 'MaxHeadSize', 20, 'LineWidth', 1.6, 'Color', 'black');
quiver(8,5,0, -0.5, 'MaxHeadSize', 20, 'LineWidth', 1.6, 'Color', 'blue');
quiver(8,1, -0.5, 0, 'MaxHeadSize', 20, 'LineWidth', 1.6, 'Color', '#77AC30');
legend('NODOS','','','','','','','','Ruta Teórica','Ruta Promedio','Ruta Mínimos','Ruta EKF','Ruta K-means');

distanciasminimos=[];
for i=1:27
    distanciaminimos=sqrt(((estimaciones(i)-posicionesT(i))^2)+((estimaciones(i,2)-posicionesT(i,2))^2))*100;
    distanciasminimos=[distanciasminimos;distanciaminimos];
end

distanciaskalman=[];
for i=1:27
    distanciakalman=sqrt(((kalmanconobs(i)-posicionesT(i))^2)+((kalmanconobs(i,2)-posicionesT(i,2))^2))*100;
    distanciaskalman=[distanciaskalman;distanciakalman];
end

distanciaskmeans=[];
for i=1:27
    distanciakmean=sqrt(((posicionesRMEANS(i)-posicionesT(i))^2)+((posicionesRMEANS(i,2)-posicionesT(i,2))^2))*100;
    distanciaskmeans=[distanciaskmeans;distanciakmean];
end