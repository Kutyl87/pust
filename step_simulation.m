function y_step = step_simulation(u, sim_end)
    Ypp = 0.8;
    Upp = 2;
    y_step = ones(1, sim_end+1)*Ypp;
    u = ones(1, sim_end+1)*u;
    u(1) = Upp;
    
    for i=2:sim_end+1
        y_step(i) = symulacja_obiektu4y_p1(u(max(1, i-10)), u(max(1, i-11)), y_step(max(1, i-1)), y_step(max(1, i-2)));
    end
end