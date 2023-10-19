Ypp = 0.8;
Upp = 2;
u_end = 2.4;
sim_end = 200;
y = step_simulation(1, sim_end);

max_diff = 0.0003;
stop_time = 0;
for i=2:sim_end
    if (abs(y(i) - y(i-1)) < max_diff)
        if(y(i) ~= Ypp )
            stop_time = i;
            break
        end
    end
end
s = zeros(1, stop_time);
for i=1:length(s)
    s(i) = (y(i) - Ypp) / (1 - Upp);
end
hold on;
grid on
grid minor
title('Znormalizowana odpowiedź skokowa')
xlabel('próbka, k')
ylabel('s_k')
plot(s);
hold off;
matlab2tikz ('zad3_s.tex' , 'showInfo' , false) 

