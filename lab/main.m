y = readmatrix("pqfile.txt");
plot(y);

function y = model(u, y, k)
T1 = 15
T2 = 15
K = 0.4;
alfa1 = exp(-1/T1);
alfa2 =exp(-1/T2);
a1 = -alfa1-alfa2;
a2 = alfa1*alfa2;
b1 = K / (T1 - T2) * (T1*(1-alfa1) - T2*(1-alfa2));
b2 = K/(T1 - T2) * (alfa1 * T2 *(1-alfa2) - alfa2*T1*(1-alfa1));
y = b1*u(k - Td - 1) + b2*u(k- Td -2) - a1*y(k- 1) - a2*y(k - 2);
end

function s = get_s(sim_end)
    Ypp = 32.5;
    Upp = 29;
    y = readmatrix("pqfile.txt");
    y = y(:, 4);
    s = zeros(1, sim_end);
    for i=1:length(s)
        s(i) = (y(i) - Ypp) / (39 - Upp);
    end
end