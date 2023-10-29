    % 120 120 1
    % lambda = 0.1473;
    % N =86;
    % Nu =33;
    %70 70 1
    %% start 10 lot of jumps
    lambda = 0.0235;
    %% start 10 less jumps
%     lambda = 0.2063;
    %% start 10 one jump
%     lambda = 0.1052;
%% start 10 two jumps
    lambda = 0.6;
    D =140;
    N =30;
    Nu =10;
    Upp = 2;
    Ypp = 0.8;
    Umin= 1.2;
    Umax = 2.8;
    deltaumax = 0.03;
    kk = 1001;
    yzad(1:260)=0.9;
    yzad(261:451)= 0.67;
    yzad(452:762) = 0.7;
    yzad(763:898) = 0.98;
    yzad(899:kk) = 0.59;
    s = get_s(kk);

[u, y, e] = dmcfunction(Upp, Ypp,s, yzad, D, N, Nu, lambda, deltaumax, Umin, Umax);
 %% Wizualizacja
t = linspace(1,kk,kk);
figure; 
stairs(t,u,'LineWidth',1.5, Color='r');
title('u - sterowanie'); 
xlabel('k - number próbki');
ylabel("Wartość sterowania")
% matlab2tikz ('zad5DMC_u_140.tex' , 'showInfo' , false)
figure; 
stairs(t,y,'LineWidth',1.5); 
hold on;
stairs(t,yzad,'LineWidth',1, 'LineStyle','--');
title('Charakterystyki y,y_{zad}'); 
xlabel('k - number próbki');
ylabel('Wartość')
legend("Wartość na wyjściu y", "Wartość zadana y_{zad}",Location="northwest")
% matlab2tikz ('zad5DMC_y_140.tex' , 'showInfo' , false)