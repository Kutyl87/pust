%% Parametry zadania
Upp = 2;
Ypp = 0.8;
Umin= 1.2;
Umax = 2.8;
deltaumax = 0.07;

%% Parametry regulatora DMC
D =140;
N =32;
Nu =29;
lambda = 13;
yzad(1:260)=0.9;
%% Wartość zadana
kk=1001;
yzad(1:260)=0.9;
yzad(261:451)= 0.67;
yzad(452:762) = 0.7;
yzad(763:898) = 0.98;
yzad(899:kk) = 0.59;
[u, y, e] = regulator_DMC(Upp, Ypp,s, yzad, D, N, Nu, lambda, deltaumax, Umin, Umax);

%% Wizualizacja
t = linspace(1,kk,kk);
figure; 
stairs(t,u,'LineWidth',1.5, Color='r');
title('u - sterowanie'); 
xlabel('k - number próbki');
ylabel("Wartość sterowania")
matlab2tikz ('zad4DMC_u_popraw.tex' , 'showInfo' , false)
figure; 
stairs(t,y,'LineWidth',1.5); 
hold on;
stairs(t,yzad,'LineWidth',1, 'LineStyle','--');
title('Charakterystyki y,y_{zad}'); 
xlabel('k - number próbki');
ylabel('Wartość')
legend("Wartość na wyjściu y", "Wartość zadana y_{zad}",Location="southeast")
matlab2tikz ('zad4DMC_y_popraw.tex' , 'showInfo' , false)
function [u, y, e] = regulator_DMC(Upp, Ypp, s,yzad, D, N, Nu, lambda, deltaumax, Umin, Umax)
    % Inicjalizacja wektorów
    kk = length(yzad);
    u = zeros(1, kk);
    y = zeros(1, kk);
    e = zeros(1, kk);
    u(1:kk) = Upp;
    y(1:kk) = Ypp;
    e(1:D-1) = 0;

    M = zeros(N,Nu);
    Mp = zeros(N,D-1);

    % Macierz M
    for i = 1:N
        for j = 1:Nu
            if (i-j+1) > 0
                M(i,j) = s(i-j+1);
            end
        end
    end

    % Macierz Mp
    for i = 1:N
        for j = 1:D-1
            Mp(i,j) = s(min(i+j,D)) - s(j);
        end
    end

    % Wyznaczenie K i dobranie parametrów kary
    Gamma = eye(N, N);
    Alpha = eye(Nu, Nu) * lambda;
    K = inv(M' * Gamma * M + Alpha) * M' * Gamma;

    % Inicjalizacja wektora du i współczynników równania różnicowego
    du = zeros(1, 12);

    % Główna pętla regulatora
    for k = 12:kk
        dUp = [];
        y(k) = symulacja_obiektu4y_p1(u(k-10), u(k-11), y(k-1), y(k-2));
        e(k) = yzad(k) - y(k);
        Yzadk = yzad(k) * ones(N, 1);
        Yk = y(k) * ones(N, 1);
        for i = 1:D-1
            dUp = [dUp; u(max(k-i, 1)) - u(max(k-i-1, 1))];
        end
        dU = K * (Yzadk - Yk - Mp * dUp);
        u(k) = dU(1) + u(k-1);

        % Skalowanie wartości u
        deltau = u(k) - u(k-1);
        u(k) = u(k-1) + min(abs(deltau), abs(deltaumax)) * sign(deltau);

        % Sprawdzenie czy U znajduje się w przedziale, ew. ścięcie
        u(k) = max(min(u(k), Umax), Umin);

        % Wprowadzenie zmian wartości zadanej
    end
end