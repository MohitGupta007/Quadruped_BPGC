    clc;clear all; close all;

Tm = 0.4;   % Swing Phase Period
Ts = 0.4;   % Stance Phase Period
S = 2.0; %cm  Stride length
H = 1.0; %cm   Stride Length
T = 0.8;
dt = 0.01;

k=0.1; % Scaling Factor
Td= k*Ts;

t = 0:dt:T/2 - dt;
x = zeros(2*length(t),1);
y= zeros(2*length(t),1);

oy=-11; %cm
ox = -S/2;

%% Swing Phase

for i=1:length(t)
    x(i) = S*(t(i)/Tm - sin(2*pi*t(i)/Tm)/(2*pi));
    if (t(i)>=0 && t(i)<=(Tm/2))
        y(i) = 2*H*(t(i)/Tm - sin(4*pi*t(i)/Tm)/(4*pi));
    else
        y(i) = 2*H*(1 - t(i)/Tm + sin(4*pi*t(i)/Tm)/(4*pi));
    end
end


%% Stance Phase

for i = 1:length(t)
    v = (pi*S)/((pi + 4*k - 2*pi*k)*Ts);
    y(2*length(t)+1 - i) = 0;
    if(0<=t(i) && t(i)<Td)
        x(2*length(t)+1-i) = 2*v*Td/pi*(1-cos(pi*t(i)/(2*Td)));
    elseif (Td<=t(i) && t(i)<Ts-Td)
        x(2*length(t)+1-i) = 2*v*Td/pi + v*(t(i)-Td);
    else
        x(2*length(t)+1-i) = 2*v*Td/pi + v*(Ts-2*Td) + 2*v*Td/pi*(cos(pi*(Ts-t(i))/(2*Td)));
    end
end
%plot(x,y,'o-');
x3 = x;
x3(1:length(x)/2,1) = x(length(x)/2+1:length(x),1);
x3(length(x)/2+1:length(x),1) = x(1:length(x)/2,1);
y3 = y;
x3(1:length(y)/2,1) = y(length(x)/2+1:length(y),1);
x3(length(y)/2+1:length(y),1) = x(1:length(y)/2,1);

%% CPG using Hopf Oscillators

alpha = 50;
b = 50;
gamma = 50;
beta = 0.5; % for trot; for walk beta = 0.75
delta = 0.3; %for trot; for walk delta = 1
meu1 = 1;
meu2 = 1;
 
 R = [1 0 -1 0 1 0 -1 0
     0 1 0 -1 0 1 0 -1
     -1 0 1 0 -1 0 1 0
     0 -1 0 1 0 -1 0 1
     1 0 -1 0 1 0 -1 0
     0 1 0 -1 0 1 0 -1
     -1 0 1 0 -1 0 1 0
     0 -1 0 1 0 -1 0 1];
 
 x = [x' x' x' x']'
 x = [x' x' x' x']';
 y = [y' y' y' y']'
 y = [y' y' y' y']';
 x3 = [x3' x3' x3' x3']';
 x3 = [x3' x3' x3' x3']';
 y3 = [y3' y3' y3' y3']';
 y3 = [y3' y3' y3' y3']';
  
 v = [x';y';x3';y3';x';y';x3';y3'];
 x2 = v;
 
 C = eye(8);
 
 for i=2:length(x)-1
%      if i>=length(x)/2
%          R = [1 0 -1 0 0 1 0 -1
%               0 1 0 -1 -1 0 1 0
%               -1 0 1 0 0 -1 0 1
%               0 -1 0 1 1 0 -1 0
%               0 -1 0 1 1 0 -1 0
%               1 0 -1 0 0 1 0 -1 
%               0 1 0 -1 -1 0 1 0 
%               -1 0 1 0 0 -1 0 1];
%          delta = 1; beta=0.75;
%      end
%      if i>=length(x)*3/4      
%          R = [1 0 -1 0 1 0 -1 0
%              0 1 0 -1 0 1 0 -1
%              -1 0 1 0 -1 0 1 0
%              0 -1 0 1 0 -1 0 1
%              1 0 -1 0 1 0 -1 0
%              0 1 0 -1 0 1 0 -1
%              -1 0 1 0 -1 0 1 0
%              0 -1 0 1 0 -1 0 1];
%          delta = 0.3;beta = 0.5;
%      end
     r1 = sqrt(x2(1,i)^2 + x2(2,i)^2);
     r2 = sqrt(x2(3,i)^2 + x2(4,i)^2);
     r3 = sqrt(x2(5,i)^2 + x2(6,i)^2);
     r4 = sqrt(x2(7,i)^2 + x2(8,i)^2);
     w1 = pi/(beta*T*(exp(-b*x2(2,i))+1)) + pi/((1-beta)*T*(exp(b*x2(2,i))+1));
     w2 = pi/(beta*T*(exp(-b*x2(4,i))+1)) + pi/((1-beta)*T*(exp(b*x2(4,i))+1));
     w3 = pi/(beta*T*(exp(-b*x2(6,i))+1)) + pi/((1-beta)*T*(exp(b*x2(6,i))+1));
     w4 = pi/(beta*T*(exp(-b*x2(8,i))+1)) + pi/((1-beta)*T*(exp(b*x2(8,i))+1));
     A = [alpha*(meu1-r1^2) -w1 0 0 0 0 0 0
          w1 gamma*(meu1-r1^2) 0 0 0 0 0 0
          0 0 alpha*(meu2-r2^2) -w2 0 0 0 0
          0 0 w2 gamma*(meu2-r2^2) 0 0 0 0
          0 0 0 0 alpha*(meu1-r3^2) -w3 0 0 
          0 0 0 0 w3 gamma*(meu1-r3^2) 0 0
          0 0 0 0 0 0 alpha*(meu2-r4^2) -w4
          0 0 0 0 0 0 w4 gamma*(meu2-r4^2)];
     B = delta*R;
     v(:,i) = A*x2(:,i) + B*x2(:,i);
     x2(:,i+1) = x2(:,i) + dt*v(:,i);
 end
t2 = 0:dt:16*T - dt;
% plot(t2,v(2,:))
figure(1)
plot(t2,x2(2,:))
hold on
plot(t2,x2(4,:))
plot(t2,x2(6,:))
plot(t2,x2(8,:))

x2(2,:) = H*x2(2,:).*(x2(2,:)>=0) + oy;
x2(4,:) = H*x2(4,:).*(x2(4,:)>=0) + oy;
x2(6,:) = H*x2(6,:).*(x2(6,:)>=0) + oy;
x2(8,:) = H*x2(8,:).*(x2(8,:)>=0) + oy;

x2(1,:) = S*x2(1,:);
x2(3,:) = S*x2(3,:);
x2(5,:) = S*x2(5,:);
x2(7,:) = S*x2(7,:);

figure(2)
plot(x2(1,:),x2(2,:))
xlim([-3,3])
ylim([-12,-9])
figure(3)
plot(x2(3,:),x2(4,:))
xlim([-3,3])
ylim([-12,-9])