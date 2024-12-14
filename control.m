clear
clc
close all
K = 9/4; 
GP=tf(4,[1 2.5 1]); % GP transfer function  (S-domain)
GP_H=tf(4,[0.05 1.125 2.55 1]); % GP*H transfer function (S-domain)
zpk(GP_H); %Puts the open loop transfer function in its minimal form by pole-zero cancelation

F_F=c2d(GP,0.1,'zoh'); %feed forword transfer function (z-domain)
LOOP=c2d(GP_H,0.1,'zoh'); % open loop transfer function (z-domain)
zpk(LOOP); %Puts the open loop transfer function in its minimal form by pole-zero cancelation

TF_Z=F_F/(1+LOOP); % system transfer function (z-domain)
zpk(TF_Z); %Puts the transfer function in its minimal form by pole-zero cancelation

TF_W= d2c(TF_Z,'tustin'); %Bilinear transformation for closed loop 
zpk(TF_W) %Puts the transfer function in its minimal form by pole-zero cancelation

LOOP_W= d2c(LOOP,'tustin'); %Bilinear transformation for open loop
zpk(LOOP_W); %Puts the transfer function in its minimal form by pole-zero cancelation

%% Plotting Step Response Before and After Adding Gain
t = 0:0.1:100; 
u = ones(size(t)); % Step input (constant value of 1)
[y, t] = lsim(TF_W, u, t);
figure('Name', 'Step Response Before Adding Gain') ;
plot(t, u, 'y', t, y, 'm', 'LineWidth', 2) ;
xlabel('Time (sec)');
ylabel('Amplitude');
title('Step Response before adding gain(k)');
legend('Input', 'Output');
grid on;

%after Gain
GP_2=tf(4*K,[1 2.5 1]) ;
GP_H_2=tf(4*K,[0.05 1.125 2.55 1]) ;
F_F_2=c2d(GP_2,0.1,'zoh') ;
LOOP_2=c2d(GP_H_2,0.1,'zoh');
TF_Z_2=F_F_2/(1+LOOP_2) ;
TF_W_2= d2c(TF_Z_2,'tustin') ;
LOOP_W_2= d2c(LOOP_2,'tustin') ;

[y,t,x] = lsim(TF_W_2,u,t);
figure('Name','Step Response After Adding Gain');
plot(t,u,'y', t,y,'m', 'LineWidth',2);
xlabel('Time (sec)');
ylabel('Amplitude');
title('Step Response After adding gain(k=9/4)');
legend('Input', 'Output');
grid on;


%% after compensetor
comp=tf([0.44 1],[0.12 1]); %lead compensetor tf
GP_3=tf(4*K,[1 2.5 1]) ;
GP_H_3=tf(4*K,[0.05 1.125 2.55 1]) ;
F_F_3=c2d(GP_3,0.1,'zoh') ;
LOOP_3=c2d(GP_H_3,0.1,'zoh');
TF_Z_3=F_F_3/(1+LOOP_3) ;
TF_W_3= d2c(TF_Z_3,'tustin') ;
LOOP_W_3= d2c(LOOP_3,'tustin')*comp ;
zpk(LOOP_W_3);

[y,t,x] = lsim(TF_W_3,u,t);
figure('Name','Step Response After Adding Compensator');
plot(t,u,'y', t,y,'m', 'LineWidth',2);
xlabel('Time (sec)');
ylabel('Amplitude');
title('Step Response After Adding Compensator');
legend('Input', 'Output');
grid on;

%% Bode-Plot 
figure('Name','Bode-Plot before adding gain ');
title('Bode-Plot before adding gain');
margin(LOOP_W);
figure('Name','Bode-Plot After Adding gain');
title('Bode-Plot After Adding gain');
margin(LOOP_W_2);
figure('Name','Bode-Plot After Adding gain and Compensator');
title('Bode-Plot After Adding gain and Compensator');
margin(LOOP_W_3);
