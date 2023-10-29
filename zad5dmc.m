figure
lambda = 1;
    D =140;
    N =30;
    Nu =10;
    Upp = 2;
    Ypp = 0.8;
    Umin= 1.2;
    Umax = 2.8;
    deltaumax = 0.03;
    kk = 1000;
    yzad(1:260)=0.9;
    yzad(261:451)= 0.67;
    yzad(452:762) = 0.7;
    yzad(763:898) = 0.98;
    yzad(899:kk) = 0.59;
    s = get_s(kk);
    t = linspace(1,kk,kk);
    Ns = [5, 1, 0.6, 0.1, 0.01];
hold on
for i = 1:5
    [u, y, e] = dmcfunction(Upp, Ypp,s, yzad, D, N, Nu, Ns(i), deltaumax, Umin, Umax);
    stairs(t,y,'LineWidth',1, 'LineStyle','--');
end
stairs(t,yzad,'LineWidth',1, 'LineStyle','--');
title('Charakterystyki y,y_{zad}'); 
xlabel('k - number próbki');
ylabel('Wartość')
legend("Wartość na wyjściu y dla {\lambda} = 5", "Wartość na wyjściu y dla {\lambda} = 1", "Wartość na wyjściu y dla {\lambda} = 0.6", "Wartość na wyjściu y dla {\lambda} = 0.1", "Wartość na wyjściu y dla {\lambda} = 0.01", "Wartość zadana y_{zad}",Location="northwest")
matlab2tikz ('zad5DMC_y_lambda.tex' , 'showInfo' , false)