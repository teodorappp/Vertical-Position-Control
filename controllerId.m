
%%G-T
Kf=0.26/8.05;
Tf=1/8.05;
ts=0.5
sigma=0.01 

tita=(abs(log(sigma)))/sqrt((log(sigma))^2+pi^2);
wn=4/(ts*tita);
wb=wn*sqrt(1-2*tita^2+sqrt(2-4*tita^2+4*tita^4)) 

Hf=tf(Kf,[Tf 1 0])
Hc=tf([(wn*Tf)/(2*tita), wn/(2*tita)],[Kf/(2*tita*wn), Kf])

%Verificare rezultate
Hd=series(Hc,Hf);
H0=feedback(Hd,1);
hold on
title('Raspuns la treapta unitara');
step(H0) 
%% metode frecventiale
close all

 Hf=tf(0.26/8.05,[1/8.05,1,0]);

sigma=0.02;
tita=abs(log(sigma))/sqrt(pi^2+(log(sigma))^2)
A=1/(4*tita*tita*sqrt(2))
Adb=20*log10(A)

figure
bode(Hf)
wf=0.1242;
F=-11.7;
VrPdB =-(F-Adb);
VrP = 10^(VrPdB/20)
HcP=VrP;
Hdes_P= HcP*Hf;
H0_P=feedback(Hdes_P,1);

figure
bode(Hdes_P)
figure
step(H0_P)
%de la reg. P
wt1_regP = 0.036;
cvRegP = 1.25; 
VrP = 1.1183; 
tsRegP = 108;

Tf=1/8.05;
wf=1/Tf;
% proiectam reg. PD
ts_stelat=2;
wt2 = wt1_regP * (tsRegP/ts_stelat);
Td = Tf;
TnPD = Td*(ts_stelat/tsRegP);
VrPD = VrP*(wt2/wt1_regP);

HcPD = tf([VrPD*Td VrPD],[TnPD 1]);
HdPD = series(HcPD, Hf);
H0PD = feedback(HdPD, 1);
figure
step(H0PD)
title('Raspuns la treapta cu PD');
%% metodele modulului si simetriei
Hf1=tf(0.26,[1,8.05,0]);
te=0.01;

%modul
Hdm1=tf(1,[2*(te^2) 2*te 0]);
Hcm1=minreal(Hdm1/Hf1)
Hm1nou=series(Hcm1,Hf1);

H0m1=feedback(Hm1nou,1);

figure
step(H0m1)

%simetrie
Hds1=tf([4*te 1],[8*(te^3) 8*(te^2) 0 0]);
Hcs1=minreal(Hds1/Hf1)
Hds1nou=series(Hcs1,Hf1);
H0s1=feedback(Hds1nou,1);

figure
step(H0s1)



