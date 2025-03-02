function Conbord=FixCond1(coor, mvois, Lx, Ly)

% Cette trame de fonction est donn�e � titre indicatif et pour vous aider

global MPuits

ntot = size(coor,1) ;  % nombre de noeuds, nombre d'inconnues
Conbord=zeros(ntot,2); % initialisation. premi�re colone: type de condition, 
%                        deuxi�me colonne: valeur de la condition

for i = 1:ntot
    vois = mvois(i, :);
    if vois(1) == 0    % .----condition � droite 
        Conbord(i,1)=  1; % condition de Dirichlet
        Conbord(i,2)= 0; % u=0 sur ce bord
    elseif vois(2) == 0 %--- condition en haut
        Conbord(i,1)= 2 ; % condition de Neumann
        Conbord(i,2)= 0 ; % valeur de du/dn sur ce bord
    elseif vois(3) == 0 %--- condition � gauche 
        Conbord(i,1)=1; % Condition de Dirichlet
        Conbord(i,2)=1 ; %valeur de u sur ce bord
    elseif vois(4) == 0 %--- condition en bas 
         Conbord(i,1)=2; % Condition de Neumann
         Conbord(i,2)=0; % du/dn = 0 sur ce bord
    end
        
end

% traitement des conditions de Dirichlet ponctuelles au centre, pour les...
% "noeuds  puits"


nbpuits=size(MPuits,1);
for ip=1:nbpuits
   nuno        = MPuits(ip,1);
   valpuits    =  MPuits(ip,2)
   Conbord(nuno,1)= 1 ; %les conditions de puits sont de Dirichlet
   Conbord(nuno,2)= valpuits ; %la valeur au puit est valpuits
end