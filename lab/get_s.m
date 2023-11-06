function s = get_s(sim_end)
    Ypp = 32.68;
    Upp = 29;
    y = readmatrix("pqfile.txt");
    y = y(:, 4);
    y = y(2:end);
    s = zeros(1, sim_end);
    for i=1:length(s)
        s(i) = (y(i) - Ypp) / (39 - Upp);
    end
end