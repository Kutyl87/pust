%Parametry zadania
Upp = 2;
Ypp = 0.8;
Umin= 1.2;
Umax = 2.8;
Tp=0.5;
deltaumax = 0.10;
%%Parametry regulatora PID
Kp =4;
Ti =10;
Td = 2;

%%Wyznaczone wartości r1,r2,r0
r1 = Kp*((Tp/(2*Ti)) -2 *(Td/Tp) -1);
r2 = Kp*Td/Tp;
r0 = Kp*(1+(Tp/(2*Ti)) + (Td/Tp));



%% Inicjalizacja wektorów
kk=1000;
u(1:kk)=Upp; y(1:kk)=Ypp;
yzad(1:260)=1.2;
yzad(261:451)= 0.67;
yzad(452:762) = 0.7;
yzad(763:898) = 0.98;
yzad(899:1000) = 0.59;
e(1:kk)=0;
scaled_u(1:kk) = 0;
%% Pętla regulatora
for k=12:kk
 y(k)=symulacja_obiektu4y_p1(u(k-10),u(k-11),y(k-1),y(k-2));
 e(k)=yzad(k)-y(k);
 u(k)=r2*e(k-2)+r1*e(k-1)+r0*e(k)+u(k-1);
 u(k) = max(min(min(abs(scaled_u(k)-scaled_u(k-1)), ...
     abs(deltaumax)) * sign(scaled_u(k) - scaled_u(k-1)) + ...
     u(k) +scaled_u(k-1),Umax),Umin)

end
%% Przygotowanie wykresów i wizualizacja
t = linspace(1,kk,kk);
figure
stairs(t,u,'LineWidth',1.5, Color='r');
hold on
stairs(t,e,'LineWidth',1.5, Color='b');
title('u - sterowanie');
xlabel('k - number próbki');
ylabel("Wartość sterowania")
print('zad3poprawu.png','-dpng','-r400')
figure
stairs(t,y,'LineWidth',1.5);
hold on;
stairs(t,yzad,'LineWidth',1, 'LineStyle','--');
title('Charakterystyki y,y_{zad}');
xlabel('k - number próbki');
ylabel('Wartość')
legend("Wartość na wyjściu y", "Wartość zadana y_{zad}",Location="southeast")
print('zad3poprawy.png','-dpng','-r400')