% %% Parametry zadania
% Upp = 2;
% Ypp = 0.8;
% Umin= 1.2;
% Umax = 2.8;
% deltaumax = 0.07;
% 
% %% Parametry regulatora DMC
% D =140;
% N =32;
% Nu =29;
% lambda = 13;
% yzad(1:260)=0.9;
% %% Wartość zadana
% kk=1001;
% yzad(1:260)=0.9;
% yzad(261:451)= 0.67;
% yzad(452:762) = 0.7;
% yzad(763:898) = 0.98;
% yzad(899:kk) = 0.59;
% [u, y, e] = dmcfunction(Upp, Ypp,s, yzad, D, N, Nu, lambda, deltaumax, Umin, Umax);
% 
% %% Wizualizacja
% t = linspace(1,kk,kk);
% figure; 
% stairs(t,u,'LineWidth',1.5, Color='r');
% title('u - sterowanie'); 
% xlabel('k - number próbki');
% ylabel("Wartość sterowania")
% matlab2tikz ('zad4DMC_u_popraw.tex' , 'showInfo' , false)
% figure; 
% stairs(t,y,'LineWidth',1.5); 
% hold on;
% stairs(t,yzad,'LineWidth',1, 'LineStyle','--');
% title('Charakterystyki y,y_{zad}'); 
% xlabel('k - number próbki');
% ylabel('Wartość')
% legend("Wartość na wyjściu y", "Wartość zadana y_{zad}",Location="southeast")
% matlab2tikz ('zad4DMC_y_popraw.tex' , 'showInfo' , false)
a = fmincon(@calculate_dmc_parameters, [120, 120, 1], [-1,1,0], 0, [], [], [0, 0, 0], [120, 120, 1000])
function error = calculate_dmc_parameters(x)
    N = x(1);
    Nu = x(2);
    lambda = x(3);
    N = round(N);
    Nu = round(Nu);
    D = 120;
    Upp = 2;
    Ypp = 0.8;
    Umin= 1.2;
    Umax = 2.8;
    deltaumax = 0.07;
    kk = 1001;
    yzad(1:260)=0.9;
    yzad(261:451)= 0.67;
    yzad(452:762) = 0.7;
    yzad(763:898) = 0.98;
    yzad(899:kk) = 0.59;
    s = get_s(kk);
    [u, y, e] = dmcfunction(Upp, Ypp,s, yzad, D, N, Nu, lambda, deltaumax, Umin, Umax);
    error = sum(e.^2);
end
function error = calculate_square_error(y_zad, y_wy)
s = (y_zad-y_wy);
error = sum((y_zad-y_wy).^2);
end