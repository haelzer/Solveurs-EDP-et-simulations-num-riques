function [A B] = Assemble(coor, mvois, pasx, pasy, Lx, Ly, Conbord, FoncD, FoncF )
% Programme d'assemblage du syst�me Au = B
% inconnue: u
% FoncD : pointeur sur la fonction de diffusion (FDiff1, FDiff2...)
% FoncF : pointeur sur la fonction terme source (FSource1, FSource2...)
% Assemblage de la matrice et du deuxi�me membre


% cette trame de fonction est donn�e � titre indicatif
% et pour vous aider


global MPuits

ntot = size(coor,1) ;  % nombre de noeuds, nombre d'inconnues
A =   zeros(ntot);
B =   zeros(ntot, 1);

for i = 1:ntot
    vois = mvois(i, :);
    if Conbord(i,1)>0     %----condition impos�e au noeud i
       if Conbord(i,1)==1      % type Dirichlet
          A(i,i)=1;

       elseif vois(1)==0     % type Neumann suivant fronti�re � droite : du/dx
          v1=mvois(vois(3),3);
          v2=vois(3);
          A(i,v1)=1/(2*pasx);
          A(i,v2)=-4/(2*pasx);
          A(i,i)=3/(2*pasx);
             
       elseif vois(2)==0    % neumann en haut : du/dy
          v1=mvois(vois(4),4);
          v2=vois(4);
          A(i,v1)=1/(2*pasy);
          A(i,v2)=-4/(2*pasy);
          A(i,i)=3/(2*pasy);

       elseif vois(3)==0  % neumann � gauche : -du/dx
          v1=mvois(vois(1),1);
          v2=vois(1);
          A(i,v1)=1/(2*pasx);
          A(i,v2)=-4/(2*pasx);
          A(i,i)=3/(2*pasx);

       elseif vois(4)==0  % neumann en bas : -du/dy
          v1=mvois(vois(2),2);
          v2=vois(2);
          A(i,v1)=1/(2*pasy);
          A(i,v2)=-4/(2*pasy);
          A(i,i)=3/(2*pasy);

       end
       B(i)=Conbord(i,2);
        
    else %--------------noeuds  sans condition: equation de conservation 
        %calcul des coef de diffusions
        M1=(coor(i,:)+coor(mvois(i,1),:))/2;
        D1=FDiff1(M1);
        M2=(coor(i,:)+coor(mvois(i,2),:))/2;
        D2=FDiff1(M2);
        M3=(coor(i,:)+coor(mvois(i,3),:))/2;
        D3=FDiff1(M3);
        M4=(coor(i,:)+coor(mvois(i,4),:))/2;
        D4=FDiff1(M4);

        %remplissage de A
        A(i,i) = (D1+D3)/pasx^2+ (D2+D4)/pasy^2 ;
        A(i,vois(1))=-D1/pasx^2;
        A(i,vois(3))=-D3/pasx^2;
        A(i,vois(2))=-D2/pasy^2;
        A(i,vois(4))=-D4/pasy^2;
 
        
        %terme source
        B(i)= FSource1(coor(i,:));
    end
end
