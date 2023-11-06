kk=1200;
yzad(1:51)=32.5;
yzad(52:451)=35;
yzad(452:kk) = 45;


[u, y, e] = dmcfunction(29, 32.68, get_s(770), yzad, 300, 50, 40, 1, 10, 0, 90)



function [u, y, e] = dmcfunction(Upp, Ypp, s,yzad, D, N, Nu, lambda, deltaumax, Umin, Umax)
    % Inicjalizacja wektorów
    addpath('D:\SerialCommunication'); % add a path to the functions
    initSerialControl COM13 % initialise com port
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
        y(k) = readMeasurements(1);
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
        sendControls([5], [u(k)]);
        waitForNewIteration();
        refreshdata
        drawnow
        plot(y)
        hold on;
        t = linspace(1,kk,kk);
        stairs(t,yzad,'LineWidth',1, 'LineStyle','--');
        title('Charakterystyki y,y_{zad}'); 
        xlabel('k - number próbki');
        ylabel('Wartość')
        legend("Wartość na wyjściu y", "Wartość zadana y_{zad}")
        hold off
        matlab2tikz ('zad5_dmc.tex' , 'showInfo' , false)   

        % Wprowadzenie zmian wartości zadanej
    end
end