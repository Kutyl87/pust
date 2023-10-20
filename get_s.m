function s = get_s(sim_end)
    Ypp = 0.8;
    Upp = 2;
    y = step_simulation(1, sim_end);
    s = zeros(1, sim_end);
    for i=1:length(s)
        s(i) = (y(i) - Ypp) / (1 - Upp);
    end
end