clear all
close all
clc

lambda=488;
mr=1.475;
mi=0.0;
h2o=1.32;
m=(mr+mi*i)/h2o;   
k=2.0*pi*h2o/lambda;




absci=[0:5:3300]; 
sa=size(absci);

mesure=textread('manipe.txt');
theory=textread('manipe_theory.txt');

    theory(:,1)=theory(:,1)*1;  %FSH 0.8
    theory(:,2)=theory(:,2)*0.97;  %SSH 0.80
  
sm=size(mesure);

[fs_fit,S_fs,mu_fs]=polyfit(theory(:,3),theory(:,1),14);
fs_interp=polyval(fs_fit,absci,[],mu_fs);

[ss_fit,S_ss,mu_ss]=polyfit(theory(:,3),theory(:,2),3);
ss_interp=polyval(ss_fit,absci,[],mu_ss);

%creation des vecteurs de calcul
%creation de la matrice de calcul : lignes : mesure / colonne : interpolation
%on calcule la distance entre chaque point de mesure et les points de l'interpolation

Xunity_m=ones(1,sa(2));
Xm=mesure(:,1); %mesure(1:10,1);

Xmes=Xm*Xunity_m;

Xunity_f=ones(sm(1),1); %ones(10,1);
Xf=fs_interp;

Xfit=Xunity_f*Xf;

DX=Xmes-Xfit;


Yunity_m=ones(1,sa(2));
Ym=mesure(:,2); %mesure(1:10,2);

Ymes=Ym*Yunity_m;

Yunity_f=ones(sm(1),1); %ones(10,1);
Yf=ss_interp;

Yfit=Yunity_f*Yf;

DY=Ymes-Yfit;


d=((DX).^2+(DY).^2).^0.5;
dmin=d.';
[A,I]=min(dmin);

%Construction de la nouvelle courbe
rayons=absci.';

fid=fopen('lisse2.txt','w+');

for i=1:sm(1)
    lisse(i,1)=fs_interp(I(i));
    lisse(i,2)=ss_interp(I(i));
    lisse(i,3)=rayons(I(i));
    lisse(i,4)=mesure(I(i),3);
    fprintf(fid,'%g\t %g\t %g\t %g\r',lisse(i,1),lisse(i,2),lisse(i,3),lisse(i,4));
end

fclose(fid);



