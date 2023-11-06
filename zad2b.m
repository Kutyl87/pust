sim_end = 500;
possible_u = [1.2:0.01:2.8];
stat_y = [];
for i= 1:size(possible_u, 2)
    y_step = step_simulation(possible_u(i), sim_end);
    stat_y(i) = y_step(end);
end

plot(possible_u, stat_y)
title('Zależność wyjścia od sterowania')
xlabel('Sterowanie')
ylabel('Wyjście')
matlab2tikz ('zad2_stat.tex' , 'showInfo' , false)