a = fmincon(@pid_calculation, [5, 8, 2], [], [], [], [], [0, 0, 0], [100, 1000, 1000])

Kp = 3.9;
Ti = 10.0;
Td = 2.8;

a = [Kp, Ti, Td];
h = pid_calculation(a)

function error = pid_calculation(x)
    Kp = x(1);
    Ti = x(2);
    Td = x(3);
    Upp = 2;
    Ypp = 0.8;
    Umin= 1.2;
    Umax = 2.8;
    Tp=0.5;
    deltaumax = 0.03;
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
    yzad(1:451)=0.9;
    yzad(452:1000) = 0.59;
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
    error = calculate_square_error(yzad, y);
end

function error = calculate_square_error(y_zad, y_wy)
s = (y_zad-y_wy);
error = sum((y_zad-y_wy).^2);
end