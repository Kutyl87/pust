function [u, y, e] = dmcfunction(Upp, Ypp, s,yzad, D, N, Nu, lambda, deltaumax, Umin, Umax)
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
