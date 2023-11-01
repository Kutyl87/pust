%% Parametry zadania
Upp = 2;
Ypp = 0.8;
Umin= 1.2;
Umax = 2.8;
Tp=0.5;
deltaumax = 0.03;

%% Parametry regulatora PID
%Random
% Kp = 1.7;
% Ti =13;
% Td = 0.9;

%Ziegler-Nichols
Kp = 3.2;
Ti = 11.5;
Td = 2.625;

%Ziegler-Nichols Updated
% Kp = 3.9;
% Ti = 10.5;
% Td = 2.625;

%% Wyznaczone wartości r1,r2,r0
r1 = Kp*((Tp/(2*Ti)) -2 *(Td/Tp) -1);
r2 = Kp*Td/Tp;
r0 = Kp*(1+(Tp/(2*Ti)) + (Td/Tp));

%% Inicjalizacja wektorów
kk=1000;
u(1:kk)=Upp;
y(1:kk)=Ypp;
e(1:kk)=0;

%% Przykładowe wartości zadanej yzad
yzad(1:260)=0.9;
yzad(261:451)= 0.67;
yzad(452:762) = 0.7;
yzad(763:898) = 0.98;
yzad(899:1000) = 0.59;
%% Pętla regulatora
for k=12:kk
 y(k)=symulacja_obiektu4y_p1(u(k-10),u(k-11),y(k-1),y(k-2));
 e(k)=yzad(k)-y(k);
 u(k)=r2*e(k-2)+r1*e(k-1)+r0*e(k)+u(k-1);

%% Skalowanie wartości u

% Sprawdzenie czy skok znajduje się w przedziale
deltau = u(k) - u(k-1);
u(k) = u(k-1) + min(abs(deltau), abs(deltaumax)) * sign(deltau);

% Sprawdzenie czy U znajduje się w przedziale, ew. ścięcie
u(k) = max(min(u(k),Umax),Umin);
end
%% Przygotowanie wykresów i wizualizacja
t = linspace(1,kk,kk);
figure
stairs(t,u,'LineWidth',1.5, Color='r');
title('u - sterowanie');
xlabel('k - number próbki');
ylabel("Wartość sterowania")
% matlab2tikz ('zad4PID_u.tex' , 'showInfo' , false)
figure
stairs(t,y,'LineWidth',1.5);
hold on;
stairs(t,yzad,'LineWidth',1, 'LineStyle','--');
title('Charakterystyki y,y_{zad}');
xlabel('k - number próbki');
ylabel('Wartość')
legend("Wartość na wyjściu y", "Wartość zadana y_{zad}",Location="southwest")
% matlab2tikz ('zad4PID_y.tex' , 'showInfo' , false)