clc
clear all
close all

% se fija la semilla del generador de números aleatorios en 1.
rng(1)

% DESCRIPTION: Estima la posición mediante la triangulación de las medidas de ángulos,
%              utilizando el algoritmo K-means el cual determina el centroide mas 
%              cercano al promedio del AoA y asi determina la respectiva posición del 
%              punto de referencia. Asimismo, se representa gráficamente la ruta correspondientes al Escenario 3 mediante
%              el algoritmo K-means.(La orientacion del nodo movil se calcula
%              con las medidas de angulo del AoA1 y AoA4)

%      INPUTS:  ruta= ruta de cada uno de los archivos .txt que contiene
%               las medidas de AoA.
% 
%               (X1,Y1), (X2,Y2), (X3,Y3), (X4,Y4) - Cada pareja de 
%               variables contiene la posicion de los beacons en el
%               escenario.

%               posicionesT = Posiciones Teoricas de cada punto de referencia
                
%               num_clusters = Numero de clusters para la implementación
%               del algoritmo, 2 para sin obstrucción, 4 para obstrucción
%            

%     OUTPUTS: posicionesKMEANS= Estima la posicion (x, y) de cada punto de
%              referencia con el algoritmo.
                
%               distancias=distancia euclidiana para determinar el mejor
%               grupo del cluster.

%              distanciaskmeans = Estima la distancia de error de cada beacon al punto
%              teorico utilizando el algortimo.
%
%% --------------------------------------------------------------------------
   % ruta = 'C:\Users\user\Desktop\Todo TG\Trabajo De Grado\medidas AoA todo\MEDIDAStxtsalon127\Medidas sin obstruccion aoa - salon 127\';
    ruta = 'C:\Users\user\Desktop\Todo TG\Trabajo De Grado\medidas AoA todo\MEDIDAStxtsalon127\Medidas con obstruccion aoa - salon 127_arregladas\';
  % ruta = 'C:\Users\user\Desktop\Todo TG\Trabajo De Grado\medidas AoA todo\MEDIDAStxtsalon127\Medidas con obstruccion aoa - salon 127\';

  % num_clusters =2;
  num_clusters =4;

archivos = dir(fullfile(ruta, '*.txt'));
numArchivos = length(archivos);
promedios = zeros(numArchivos, 4);
posicionesKMEANS=[];
distancias=[];
distanciaskmeans=[];
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

    AoA11=AoA1;
    AoA22=AoA2;
    AoA33=AoA3;
    AoA44=AoA4;

    AoA1=AoA1promedio;
    AoA2=AoA2promedio;
    AoA3=AoA3promedio;
    AoA4=AoA4promedio;

    
    if i <= 13

        if orientaciones(i) == "arriba"
    %% Kmeans
    XAoA4 = AoA44;
    [idx, centroids] = kmeans(XAoA4, num_clusters);
    [~, indice_mejor_valor] = min(pdist2(XAoA4, centroids));
    nuevo_valor = [AoA4promedio]; 
    distancias = sqrt(sum((centroids - nuevo_valor).^2, 2));
    indice_centroide_cercano = knnsearch(centroids, nuevo_valor);
    grupo_asignado = idx(indice_centroide_cercano);
    valor_centroide_asignado = centroids(indice_centroide_cercano);
    % fprintf('El nuevo valor pertenece al grupo %d con valor de centroide %f.\n', grupo_asignado, valor_centroide_asignado);
    %% Kmeans
    XAoA1 = AoA11;
    [idx1, centroids1] = kmeans(XAoA1, num_clusters);
    [~, indice_mejor_valor1] = min(pdist2(XAoA1, centroids1));
    nuevo_valor1 = [AoA1promedio];
    distancias1 = sqrt(sum((centroids1 - nuevo_valor1).^2, 2));
    indice_centroide_cercano1 = knnsearch(centroids1, nuevo_valor1);
    grupo_asignado1 = idx(indice_centroide_cercano1);
    valor_centroide_asignado1 = centroids1(indice_centroide_cercano1);
    % fprintf('El nuevo valor pertenece al grupo %d con valor de centroide %f.\n', grupo_asignado1, valor_centroide_asignado1);
            AoA1=valor_centroide_asignado1
            AoA4=valor_centroide_asignado

            tetaC1 = 180 + AoA1;
            tetaC4 = 180 - AoA4;
            teta1 = 180 - 90 - abs(tetaC1);
            teta4 = 180 - 90 - abs(tetaC4);
            xreal = X1 + ((Y4 - Y1) * tand(teta1) * tand(teta4)) / (tand(teta1) + tand(teta4));
            yreal = (Y1 * tand(teta1) + Y4 * tand(teta4)) / (tand(teta1) + tand(teta4));
            clc

        elseif orientaciones(i) == "izquierda"
    %% Kmeans
    XAoA4 = AoA44;
    [idx, centroids] = kmeans(XAoA4, num_clusters);
    [~, indice_mejor_valor] = min(pdist2(XAoA4, centroids));
    nuevo_valor = [AoA4promedio]; 
    distancias = sqrt(sum((centroids - nuevo_valor).^2, 2));
    indice_centroide_cercano = knnsearch(centroids, nuevo_valor);
    grupo_asignado = idx(indice_centroide_cercano);
    valor_centroide_asignado = centroids(indice_centroide_cercano);

    %% Kmeans
    XAoA1 = AoA11;
    [idx1, centroids1] = kmeans(XAoA1, num_clusters);
    [~, indice_mejor_valor1] = min(pdist2(XAoA1, centroids1));
    nuevo_valor1 = [AoA1promedio];
    distancias1 = sqrt(sum((centroids1 - nuevo_valor1).^2, 2));
    indice_centroide_cercano1 = knnsearch(centroids1, nuevo_valor1);
    grupo_asignado1 = idx(indice_centroide_cercano1);
    valor_centroide_asignado1 = centroids1(indice_centroide_cercano1);
            AoA1=valor_centroide_asignado1
            AoA4=valor_centroide_asignado
            clc
            tetaC1 = -90 + AoA1;
            tetaC4 = 90 - AoA4;
            teta1 = 180 - 90 - abs(tetaC1);
            teta4 = 180 - 90 - abs(tetaC4);
            xreal = X1 + ((Y4 - Y1) * tand(teta1) * tand(teta4)) / (tand(teta1) + tand(teta4));
            yreal = (Y1 * tand(teta1) + Y4 * tand(teta4)) / (tand(teta1) + tand(teta4));
            

        elseif orientaciones(i) == "abajo"
     %% Kmeans
    XAoA4 = AoA44;
    [idx, centroids] = kmeans(XAoA4, num_clusters);
    [~, indice_mejor_valor] = min(pdist2(XAoA4, centroids));
    nuevo_valor = [AoA4promedio]; 
    distancias = sqrt(sum((centroids - nuevo_valor).^2, 2));
    indice_centroide_cercano = knnsearch(centroids, nuevo_valor);
    grupo_asignado = idx(indice_centroide_cercano);
    valor_centroide_asignado = centroids(indice_centroide_cercano);

    %% Kmeans
    XAoA1 = AoA11;
    [idx1, centroids1] = kmeans(XAoA1, num_clusters);
    [~, indice_mejor_valor1] = min(pdist2(XAoA1, centroids1));
    nuevo_valor1 = [AoA1promedio];
    distancias1 = sqrt(sum((centroids1 - nuevo_valor1).^2, 2));
    indice_centroide_cercano1 = knnsearch(centroids1, nuevo_valor1);
    grupo_asignado1 = idx(indice_centroide_cercano1);
    valor_centroide_asignado1 = centroids1(indice_centroide_cercano1);
            AoA1=valor_centroide_asignado1
            AoA4=valor_centroide_asignado
            clc
            tetaC1 = AoA1;
            tetaC4 = -AoA4;
            teta1 = 180 - 90 - abs(tetaC1);
            teta4 = 180 - 90 - abs(tetaC4);
            xreal = X1 + ((Y4 - Y1) * tand(teta1) * tand(teta4)) / (tand(teta1) + tand(teta4));
            yreal = (Y1 * tand(teta1) + Y4 * tand(teta4)) / (tand(teta1) + tand(teta4));
            
        else
            %derecha
             %% Kmeans
    XAoA4 = AoA44;
    [idx, centroids] = kmeans(XAoA4, num_clusters);
    [~, indice_mejor_valor] = min(pdist2(XAoA4, centroids));
    nuevo_valor = [AoA4promedio]; 
    distancias = sqrt(sum((centroids - nuevo_valor).^2, 2));
    indice_centroide_cercano = knnsearch(centroids, nuevo_valor);
    grupo_asignado = idx(indice_centroide_cercano);
    valor_centroide_asignado = centroids(indice_centroide_cercano);

    %% Kmeans
    XAoA1 = AoA11;
    [idx1, centroids1] = kmeans(XAoA1, num_clusters);
    [~, indice_mejor_valor1] = min(pdist2(XAoA1, centroids1));
    nuevo_valor1 = [AoA1promedio];
    distancias1 = sqrt(sum((centroids1 - nuevo_valor1).^2, 2));
    indice_centroide_cercano1 = knnsearch(centroids1, nuevo_valor1);
    grupo_asignado1 = idx(indice_centroide_cercano1);
    valor_centroide_asignado1 = centroids1(indice_centroide_cercano1);
            AoA1=valor_centroide_asignado1
            AoA4=valor_centroide_asignado
            clc
            tetaC1 = AoA1 + 90;
            tetaC4 = -AoA4 - 90;
            teta1 = 180 - 90 - abs(tetaC1);
            teta4 = 180 - 90 - abs(tetaC4);
            xreal = X1 + ((Y4 - Y1) * tand(teta1) * tand(teta4)) / (tand(teta1) + tand(teta4));
            yreal = (Y1 * tand(teta1) + Y4 * tand(teta4)) / (tand(teta1) + tand(teta4));
          
        end

    else
        %%punto14-27

        if orientaciones(i) == "arriba"
             %% Kmeans
             rng(1)
    XAoA3 = AoA33;
    [idx, centroids] = kmeans(XAoA3, num_clusters);
    [~, indice_mejor_valor] = min(pdist2(XAoA3, centroids));
    nuevo_valor = [AoA3promedio]; 
    distancias = sqrt(sum((centroids - nuevo_valor).^2, 2));
    indice_centroide_cercano = knnsearch(centroids, nuevo_valor);
    grupo_asignado = idx(indice_centroide_cercano);
    valor_centroide_asignado = centroids(indice_centroide_cercano);

    %% Kmeans
    rng(1)
    XAoA2 = AoA22;
    [idx2, centroids2] = kmeans(XAoA2, num_clusters);
    [~, indice_mejor_valor2] = min(pdist2(XAoA2, centroids2));
    nuevo_valor2 = [AoA2promedio];
    distancias2 = sqrt(sum((centroids2 - nuevo_valor1).^2, 2));
    indice_centroide_cercano2 = knnsearch(centroids2, nuevo_valor2);
    grupo_asignado2 = idx(indice_centroide_cercano2);
    valor_centroide_asignado2 = centroids2(indice_centroide_cercano2);

            AoA2=valor_centroide_asignado2
            AoA3=valor_centroide_asignado
            clc
            tetaC2 = AoA2;
            tetaC3 = AoA3;
            AoA2 = tetaC2;
            AoA3 = tetaC3;
            teta2 = 180 - 90 - abs(tetaC2);
            teta3 = 180 - 90 - abs(tetaC3);
            xreal = X3 - (Y3 - ((Y3 * tand(teta3) + Y2 * tand(teta2)) / (tand(teta2) + tand(teta3)))) * tand(teta3);
            yreal = (Y3 * tand(teta3) + Y2 * tand(teta2)) / (tand(teta3) + tand(teta2));
          

        elseif orientaciones(i) == "izquierda"
    XAoA3 = AoA33;
    [idx, centroids] = kmeans(XAoA3, num_clusters);
    [~, indice_mejor_valor] = min(pdist2(XAoA3, centroids));
    nuevo_valor = [AoA3promedio]; 
    distancias = sqrt(sum((centroids - nuevo_valor).^2, 2));
    indice_centroide_cercano = knnsearch(centroids, nuevo_valor);
    grupo_asignado = idx(indice_centroide_cercano);
    valor_centroide_asignado = centroids(indice_centroide_cercano);

    %% Kmeans
    rng(1)
    XAoA2 = AoA22;
    [idx2, centroids2] = kmeans(XAoA2, num_clusters);
    [~, indice_mejor_valor2] = min(pdist2(XAoA2, centroids2));
    nuevo_valor2 = [AoA2promedio];
    distancias2 = sqrt(sum((centroids2 - nuevo_valor1).^2, 2));
    indice_centroide_cercano2 = knnsearch(centroids2, nuevo_valor2);
    grupo_asignado2 = idx(indice_centroide_cercano2);
    valor_centroide_asignado2 = centroids2(indice_centroide_cercano2);

            AoA2=valor_centroide_asignado2
            AoA3=valor_centroide_asignado
            tetaC2=180+AoA2;
            tetaC3=90+AoA3;
            teta2=180-90-abs(tetaC2);
            teta3=180-90-abs(tetaC3);
            xreal=X3-(Y3-((Y3*tand(teta3)+Y2*tand(teta2))/(tand(teta2)+tand(teta3))))*tand(teta3);
            yreal=(Y3*tand(teta3)+Y2*tand(teta2))/(tand(teta3)+tand(teta2));
     
        elseif orientaciones(i) == "abajo"
                XAoA3 = AoA33;
    [idx, centroids] = kmeans(XAoA3, num_clusters);
    [~, indice_mejor_valor] = min(pdist2(XAoA3, centroids));
    nuevo_valor = [AoA3promedio]; 
    distancias = sqrt(sum((centroids - nuevo_valor).^2, 2));
    indice_centroide_cercano = knnsearch(centroids, nuevo_valor);
    grupo_asignado = idx(indice_centroide_cercano);
    valor_centroide_asignado = centroids(indice_centroide_cercano);

    %% Kmeans
    rng(1)
    XAoA2 = AoA22;
    [idx2, centroids2] = kmeans(XAoA2, num_clusters);
    [~, indice_mejor_valor2] = min(pdist2(XAoA2, centroids2));
    nuevo_valor2 = [AoA2promedio];
    distancias2 = sqrt(sum((centroids2 - nuevo_valor1).^2, 2));
    indice_centroide_cercano2 = knnsearch(centroids2, nuevo_valor2);
    grupo_asignado2 = idx(indice_centroide_cercano2);
    valor_centroide_asignado2 = centroids2(indice_centroide_cercano2);

            AoA2=valor_centroide_asignado2
            AoA3=valor_centroide_asignado
            tetaC2=180-AoA2;
            tetaC3=180+AoA3;
            teta2=180-90-abs(tetaC2);
            teta3=180-90-abs(tetaC3);
            xreal=X3-(Y3-((Y3*tand(teta3)+Y2*tand(teta2))/(tand(teta2)+tand(teta3))))*tand(teta3);
            yreal=(Y3*tand(teta3)+Y2*tand(teta2))/(tand(teta3)+tand(teta2));
            
        else
            %derecha
                XAoA3 = AoA33;
    [idx, centroids] = kmeans(XAoA3, num_clusters);
    [~, indice_mejor_valor] = min(pdist2(XAoA3, centroids));
    nuevo_valor = [AoA3promedio]; 
    distancias = sqrt(sum((centroids - nuevo_valor).^2, 2));
    indice_centroide_cercano = knnsearch(centroids, nuevo_valor);
    grupo_asignado = idx(indice_centroide_cercano);
    valor_centroide_asignado = centroids(indice_centroide_cercano);

    %% Kmeans
    rng(1)
    XAoA2 = AoA22;
    [idx2, centroids2] = kmeans(XAoA2, num_clusters);
    [~, indice_mejor_valor2] = min(pdist2(XAoA2, centroids2));
    nuevo_valor2 = [AoA2promedio];
    distancias2 = sqrt(sum((centroids2 - nuevo_valor1).^2, 2));
    indice_centroide_cercano2 = knnsearch(centroids2, nuevo_valor2);
    grupo_asignado2 = idx(indice_centroide_cercano2);
    valor_centroide_asignado2 = centroids2(indice_centroide_cercano2);

            AoA2=valor_centroide_asignado2
            AoA3=valor_centroide_asignado
            tetaC2=-AoA2+90;
            tetaC3=AoA3-90;
            teta2=180-90-abs(tetaC2);
            teta3=180-90-abs(tetaC3);
            xreal=X3-(Y3-((Y3*tand(teta3)+Y2*tand(teta2))/(tand(teta2)+tand(teta3))))*tand(teta3);
            yreal=(Y3*tand(teta3)+Y2*tand(teta2))/(tand(teta3)+tand(teta2));
         
        end
    end
    posicionesKMEANS = [posicionesKMEANS; xreal yreal];
    distanciameans=sqrt(((posicionesKMEANS(i)-posicionesT(i))^2)+((posicionesKMEANS(i,2)-posicionesT(i,2))^2))*100;
    distanciaskmeans=[distanciaskmeans;distanciameans];

end
plot(posicionesKMEANS(:,1),posicionesKMEANS(:,2))
hold on
plot(posicionesT(:,1),posicionesT(:,2))

