%% Parametry zadania
Upp = 2;
Ypp = 0.8;
Umin= 1.2;
Umax = 2.8;
deltaumax = 0.03;

%% Parametry regulatora DMC
N =102;
Nu =102;
D =102;

%% Inicjacja macierzy M i Mp
M = zeros(N,Nu);
Mp = zeros(N,D-1);

%% Wyznaczenie współczynników odpowiedzi skokowej
kk=1000;
yzad(1:260)=0.9;
yzad(261:451)= 0.67;
yzad(452:762) = 0.7;
yzad(763:898) = 0.98;
yzad(899:1000) = 0.59;

%% Inicjalizacja wektorów
u(1:kk)=Upp; 
y(1:kk)=Ypp;
e(1:D-1)=0;

%% Macierz M
for i= 1:N
    for j = 1:Nu
        if (i-j+1)>0
            M(i,j) = s(i-j+1);
        end
    end
end

%% Macierz Mp
for i = 1:N
    for j = 1:D-1
        Mp(i,j) = s(min(i+j,D)) - s(j);
    end
end

%% Wyznaczenie K i dobranie parametrów kary
lambda = 180;
Gamma = eye(N,N);
Alpha = eye(Nu,Nu) * lambda;
K = inv(M' * Gamma * M + Alpha) * M' * Gamma;

%% Inicjalizacja wektora du i współczynniki równania różnciowego
du = zeros(0:12);
counter = 2;

%% Główna pętla regulatora
for k=D:kk
 dUp = [];
 y(k)=symulacja_obiektu4y_p1(u(k-10),u(k-11),y(k-1),y(k-2));
 e(k)=yzad(k)-y(k);
 Yzadk = yzad(k) *ones(N,1);
 Yk = y(k) *ones(N,1);
 
%% Skalowanie wartości u

% Sprawdzenie czy skok znajduje się w przedziale
deltau = u(k) - u(k-1);
u(k) = u(k-1) + min(abs(deltau), abs(deltaumax)) * sign(deltau);

% Sprawdzenie czy U znajduje się w przedziale, ew. ścięcie
u(k) = max(min(u(k),Umax),Umin);
 for i=1:D-1
     if (k-i-1) > 0
        dUp = [dUp;u(k-i) - u(k-i-1)];
     else
        dUp = [dUp;u(k-i)];
     end
 end
 dU = K*(Yzadk - Yk - Mp * dUp);
 u(k)= dU(1) + u(k-1);
 %% Wprowadzenie zmian wartości zadanej 

end

%% Wizualizacja
t = linspace(1,kk,kk);
figure; 
stairs(t,u,'LineWidth',1.5, Color='r');
title('u - sterowanie'); 
xlabel('k - number próbki');
ylabel("Wartość sterowania")
figure; 
stairs(t,y,'LineWidth',1.5); 
hold on;
stairs(t,yzad,'LineWidth',1, 'LineStyle','--');
title('Charakterystyki y,y_{zad}'); 
xlabel('k - number próbki');
ylabel('Wartość')
legend("Wartość na wyjściu y", "Wartość zadana y_{zad}",Location="southeast")