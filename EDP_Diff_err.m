
% Programme principal pour le graph d'erreur

close all
clear all  

global Lx Ly
global MPuits
% Données physiques et numériques

Lx = 2;   % taille coté en x
Ly = 1;   % taille coté en y
Lz = 10;
nx = 20;    %nombre de noeuds en x pour le pb de l'aquifère
ny = 10;    %nombre de noeuds en y pour le pb de l'aquifère
pasx = Lx / (nx-1); % pas : delta x
pasy = Ly / (ny-1); % pas : delta y 

FoncD=@FDiff1;     % on utilise des pointeurs sur les 3 fonctions 
FoncF=@FSource1;   % qui varient d'un cas à l'autre. Ainsi on ne devra modifier
FCond=@FixCond1;   % leur nom qu'à cet endroit dans le code

Sol1=@Sol_a1;

Tab_nx=5:1:100;
Tab_errmax=zeros(size(Tab_nx));

for k=1:length(Tab_nx)
    nx=Tab_nx(k);
    pasx = Lx / (nx-1);
    [coor, mvois] = Maillage(nx, ny, pasx, pasy); 
    ua=Sol1(coor);
    Conbord=FCond(coor, mvois, Lx, Ly); 
    [A, B] = Assemble(coor, mvois, pasx, pasy, Lx, Ly, Conbord, FoncD, FoncF);
    u = A\B ;
    Tab_errmax(k)=max(abs(u-ua));
end

figure(1)
hold on
plot(log(Lx./(Tab_nx - 1)),log(Tab_errmax))
title( "Logarithme de l'erreur de la méthode en fonction du logarithme du pas" , 'FontSize', 18)
grid
hold off





