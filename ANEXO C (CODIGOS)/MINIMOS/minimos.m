clc
clear all
close all

%% --------------------------------------------------------------------------
%
% DESCRIPTION: Estima la posición mediante el metodo de minimos cuadrados, utilizando todas las posiciones
%              en cada punto de referencia, con ayuda de las distancia euclidiana entre el beacon y el 
%              punto teorico, se representa gráficamente la ruta correspondiente al Escenario 3 mediante
%              este metodo.

%      INPUTS: se carga las posiciones de cada implementacion:
%              posicionesizquierdasinobs
%              posicionesizquierdacobs
%              posicionesderechaobs
%              posicionesderechaobs
%               
%               X=matriz que contiene las coordenadas:
%              (X1,Y1), (X2,Y2), (X3,Y3), (X4,Y4) - Cada pareja de 
%              variables contiene la posicion de los beacons en el
%              escenario.
   
%              modelfun= modelo del metodo

%              min_X - minimo X coordenada del dataset
%              max_X - maximo X coordenada del dataset
%              min_Y - minimo Y coordenada del dataset
%              max_Y - maximo Y coordenada del dataset
%              
%              distancias= Estima la distancia de cada beacon al punto
%              teorico.
%               
   

%     OUTPUTS: estimaciones= Estima la posicion (x, y) de cada punto de
%              referencia.

%              
%
%% --------------------------------------------------------------------------

X1=0; Y1=0;
X4=0; Y4=6;

Y2=0; X2=9;
X3=9; Y3=6;
% %%izquierda sinobs
% posicionesizquierdasinobs=load('posicionesizquierdasinobs.mat');%esto lo saco de dispersion mejor y peor
% posicionesizquierdasinobs=posicionesizquierdasinobs.posicionesR(1:2600,:);

%%izquierda obs
posicionesizquierdaobs=load('posicionesizquierdaobs.mat');%esto lo saco de dispersion mejor y peor
posicionesizquierdaobs=posicionesizquierdaobs.posicionesR(1:2600,:);

% %%derecha
% posicionesderechasinobs=load('posicionesderechasinobs.mat');
% posicionesderechasinobs=posicionesderechasinobs.posicionesR(2601:end,:);

%%derecha obs
posicionesderechaobs=load('posicionesderechaobs.mat');
posicionesderechaobs=posicionesderechaobs.posicionesR(2601:end,:);

posiciones=vertcat(posicionesizquierdaobs, posicionesderechaobs);

distancias = zeros(size(posiciones, 1), 4);
for i = 1:size(posiciones, 1)
    distancias(i, 1) = sqrt((posiciones(i, 1) - X1)^2 + (posiciones(i, 2) - Y1)^2);
    distancias(i, 2) = sqrt((posiciones(i, 1) - X2)^2 + (posiciones(i, 2) - Y2)^2);
    distancias(i, 3) = sqrt((posiciones(i, 1) - X3)^2 + (posiciones(i, 2) - Y3)^2);
    distancias(i, 4) = sqrt((posiciones(i, 1) - X4)^2 + (posiciones(i, 2) - Y4)^2);
end


X = [0 0;
    9 0;
    9 6;
    0 6];


inicio=1;
%%
for i=1:27
 fin=inicio+199;
 posiciones2=posiciones(inicio:fin,:);

xw=(posiciones2(:,1));
yw=(posiciones2(:,2));
%%
max_X=max(posiciones2(:,1));
min_X=min(posiciones2(:,1));
max_Y=max(posiciones2(:,2));
min_Y=min(posiciones2(:,2));

%%
% Repetir las dos primeras columnas de X para tener 800 filas 4*200
X_repetido = repmat(X, 200, 1);
distancias2 = distancias(inicio:fin,:);
distancias2 = reshape(distancias2.', [], 1);

%% Combinar las columnas para crear la tabla

tbl = table(X_repetido, distancias2);

%se calcula la distancia.
d=distancias2;
d = d.^2;
weights = d.^(-1);
weights = transpose(weights);

% coordenadas medias aproximadas del conjunto de datos
beta0 = [(max_X - min_X)/2, (max_Y - min_Y)/2];

%Se define el modelo
modelfun = @(b,X)(abs(b(1)-X(:,1)).^2+abs(b(2)-X(:,2)).^2).^(1/2);

%fit the data to the model
 % mdl = fitnlm(tbl,modelfun,beta0,'Weights',weights);
   mdl = fitnlm(tbl,modelfun,beta0);

%Se estima la posición
b = mdl.Coefficients{1:2,{'Estimate'}};
inicio=fin+1;
estimaciones(i,:)=[b(1) b(2)];
hold on
grid on
end

plot(estimaciones(:, 1), estimaciones(:, 2),'-o','LineWidth', 1.5, 'Color', '#D95319');

