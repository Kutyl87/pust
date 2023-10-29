addpath('D:\SerialCommunication'); % add a path to the functions
initSerialControl COM13 % initialise com port


%% Parametry zadania
Upp = 29;
Ypp = 32.25;
Umin= 0;
Umax = 90;
Tp=1;
deltaumax = 90;

%% Parametry regulatora PID
%Random
% Kp = 1.7;
% Ti =13;
% Td = 0.9;

%Ziegler-Nichols
Kp = 1.2;
Ti = 19.5;
Td = 2.625;

%Ziegler-Nichols Updated
% Kp = 3.9;
% Ti = 10.5;
% Td = 2.625;

%% Wyznaczone warto�ci r1,r2,r0
r1 = Kp*((Tp/(2*Ti)) -2 *(Td/Tp) -1);
r2 = Kp*Td/Tp;
r0 = Kp*(1+(Tp/(2*Ti)) + (Td/Tp));

%% Inicjalizacja wektor�w
kk=1200; 
u(1:kk)=Upp;
y(1:kk)=Ypp;
e(1:kk)=0;

measurements1 = ones(12, 1)*readMeasurements(1);
plot(measurements1)

%% Przyk�adowe warto�ci zadanej yzad
yzad(1:51)=32.5;
yzad(52:451)=35;
yzad(452:kk) = 45;
%% P�tla regulatora
for k=12:kk
 measurements1 = [ measurements1(1:end);readMeasurements(1)];
 y(k)=measurements1(k);
 e(k)=yzad(k)-y(k);
 u(k)=r2*e(k-2)+r1*e(k-1)+r0*e(k)+u(k-1);

%% Skalowanie warto�ci u

% Sprawdzenie czy skok znajduje si� w przedziale
deltau = u(k) - u(k-1);
u(k) = u(k-1) + min(abs(deltau), abs(deltaumax)) * sign(deltau);

% Sprawdzenie czy U znajduje si� w przedziale, ew. �ci�cie
u(k) = max(min(u(k),Umax),Umin);
sendControls([5], [u(k)]);
waitForNewIteration();
refreshdata
drawnow
plot(measurements1)
hold on;
t = linspace(1,kk,kk);
stairs(t,yzad,'LineWidth',1, 'LineStyle','--');
title('Charakterystyki y,y_{zad}'); 
xlabel('k - number pr�bki');
ylabel('Warto��')
legend("Warto�� na wyj�ciu y", "Warto�� zadana y_{zad}")
hold off
matlab2tikz ('zad5_pid.tex' , 'showInfo' , false)
end
%% Przygotowanie wykres�w i wizualizacja 
% t = linspace(1,kk,kk);
% figure
% stairs(t,u,'LineWidth',1.5, Color='r');
% title('u - sterowanie'); 
% xlabel('k - number pr�bki');
% ylabel("Warto�� sterowania")
% % matlab2tikz ('zad4PID_u.tex' , 'showInfo' , false)
% figure
% stairs(t,y,'LineWidth',1.5); 
% hold on;
% stairs(t,yzad,'LineWidth',1, 'LineStyle','--');
% title('Charakterystyki y,y_{zad}'); 
% xlabel('k - number pr�bki');
% ylabel('Warto��')
% legend("Warto�� na wyj�ciu y", "Warto�� zadana y_{zad}",Location="southwest")
% % matlab2tikz ('zad4PID_y.tex' , 'showInfo' , false) 