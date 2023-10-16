symulacja_obiektu4y_p1(1, 1, 2, 2)

sim_end = 200;
y_step = zeros(1, sim_end+1);
D1 = ones(1, sim_end+1);
D1(1) = 0;
for i=2:sim_end+1
    y_step(i) = symulacja_obiektu4y_p1(D1(max(1, i-10)), D1(max(1, i-11)), y_step(max(1, i-1)), y_step(max(1, i-2)));
end

plot(y_step)