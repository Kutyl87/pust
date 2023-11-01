function y_w = model(u, y, kk, Td, K,T1, T2)
alfa1 = exp(-1/T1);
alfa2 =exp(-1/T2);
y_w(1:kk) = y(1);
a1 = -alfa1-alfa2;
a2 = alfa1*alfa2;
b1 = (K / (T1 - T2)) * (T1*(1-alfa1) - T2*(1-alfa2));
b2 = (K/(T1 - T2)) * (alfa1 * T2 *(1-alfa2) - alfa2*T1*(1-alfa1));
for k=Td+3:kk
y_w(k) = b1*u(k - Td - 1) + b2*u(k- Td -2) - a1*y_w(k- 1) - a2*y_w(k - 2);
end
end