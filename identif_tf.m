
%%interpolare
q_points=[0 0.5 1.3 1.55];
pwm_values=[0 20 60 100];
Ts=0.01;

 d_tub=0.093 %m
 d_ball=0.035;%m
 A=pi*(d_tub/2)^2;
 g=9.8;
 m=2.7/1000 %grame
 Vb=(4*pi*(d_ball/2)^3)/3;
 ro=1.225;
 Cd=1;

%  simGetData=sim('blowerControlBall');
%  input=simGetData.get('simin');
%  time=input.time;
% %  u=input.Data;
%  load('Identif_ex.mat', 'arx_Y', 'arx_u', 'arx_time');
%  arx_u_ts = timeseries(arx_u, arx_time);
%  assignin('base', 'arx_u_ts', arx_u_ts);

%  output=simGetData.get('simout');
%  y=output.Data;
%  na=2;
%  nb=2;
%  nk=0;

%  model_arx=arx(data,[na nb nk ]);
%  G=tf(model_arx);
%  Gc=d2c(G,'zoh');
%  zpk(minreal(Gc))

% load('model_arx_expData.mat', 'Gc')
% load('model_arx_expData.mat', 'model_arx')
% load('model_arx_expData.mat', 'u')
% load('model_arx_expData.mat', 'y')
% dataexp=iddata(y,u,Ts);
% Gcexp=minreal(Gc)
% figure
% bode(Gc)
% figure
% compare(dataexp,Gc)
% load('model_arx.mat', 'Gc')
% load('model_arx.mat', 'y')
% load('model_arx.mat', 'u')
% data=iddata(y,u,Ts);
% figure
% compare(data,Gc)
% Gc=minreal(Gc)
% figure
% bode(Gc)
% 
% %%design  LQR controller
% numerator = -1.5337e-08 * [1, (509.4 - 172.1), 509.4 * -172.1];
% denominator = [1, 0.9044, 9.947e-05];

% [A, B, C, D] = tf2ss(numerator, denominator);
%  
% Q = eye(size(A));  
% R = 50;             
% 
% %LQR gain
% K = lqr(A, B, Q, R);
% 
% % Define the closed-loop system
% A_cl=A-B*K;
% B_cl=B;
% C_cl=C;
% D_cl=D;
% [num,den]=ss2tf(A_cl, B_cl, C_cl, D_cl);
% H=tf(num,den);
% % H=zpk(minreal(H));
% P_Con=tf(pidtune(Gcexp,'P'))

%Pi_Con=tf(pidtune(Gcexp,'PI')) %kp=100, Ti=2.56e-05
% kp=100; Ti=2.56e-05;
% Pi=tf([kp*Ti,kp],[Ti,0]);
% Pidiscret=c2d(Pi,Ts,'zoh')

M=(0.27-0.25)/0.1;
T0=(10.4-10)*2;
zeta=-log(M)/sqrt(pi^2+log(M)^2);
wn=2*pi/(T0*sqrt(1-zeta^2));
K=0.1/0.1;


Gcl=tf(wn^2,[1,2*zeta*wn,wn^2])
H=tf(0.26,[1,8.05,0])







