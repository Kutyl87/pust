function s = get_s(sim_end)
    Ypp = 0.8;
    Upp = 2;
    y = step_simulation(1.6, sim_end+3);
    y = y(3:end);
    s = zeros(1, sim_end+2);
    for i=1:length(s)
        s(i) = (y(i) - Ypp) / (1.6 - Upp);
    end
end
