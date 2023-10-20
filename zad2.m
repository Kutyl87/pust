sim_end = 200;
possible_u = [1.2:0.4:2.8];
hold on
grid on
grid minor

plots = [];

for i= 1:size(possible_u, 2)
    y_step = step_simulation(possible_u(i), sim_end);
    plots(i) = plot([0:0.5:sim_end/2],  y_step, 'DisplayName', 'U = ' + string(possible_u(i)));
end
hold off
lgd = legend('Location', 'east');
xlim([0, sim_end/2])
title('Symulacja obiektu dla różnego sterowania U')
xlabel('Czas[s]')
ylabel('Wyjście')
matlab2tikz ('zad2_wiele.tex' , 'showInfo' , false) 