y = readmatrix("pqfile.txt");
% plot(y);
y_size = size(y(:,4));
kk = y_size(1);
u(1:kk) = 39;
u(1) = 32;
yx = model(u,y(:,4),kk);
% plot(yx);
% hold on
% plot(y)
t = linspace(1,kk,kk);
err = sum((transpose(y(:,4)) -yx).^2);
figure
stairs(t,yx,'LineWidth',1)
hold on;
stairs(t,y,'LineWidth',1, 'LineStyle','-');
title('Charakterystyki y,y_{zad}'); 
xlabel('k - number próbki');
ylabel('Wartość')
legend("Odpowiedź skokowa", "Aproksymowana odpowiedź skokowa  skokowa", location='southeast')
hold off
matlab2tikz ('zad3_lab_odpowiedz_skok_approx_2.tex' , 'showInfo' , false)
function y_w = model(u, y, kk)
% T1 = 0.0002;
% T2 = 107.1386;
% K = 0.9339;
T1 =1.0001;
T2 =108.0218;
K =  0.9340 ;
Td = 15;
alfa1 = exp(-1/T1);
alfa2 =exp(-1/T2);
y_w(1:kk) = y(1);
a1 = -alfa1-alfa2;
a2 = alfa1*alfa2;
b1 = (K / (T1 - T2)) * (T1*(1-alfa1) - T2*(1-alfa2));
b2 = (K/(T1 - T2)) * (alfa1 * T2 *(1-alfa2) - alfa2*T1*(1-alfa1));
for k=Td+3:kk
y_w(k) = b1*u(k - Td - 1) + b2*u(k- Td -2) - a1*y_w(k- 1) - a2*y_w(k - 2);
end
end
