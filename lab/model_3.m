a = fmincon(@calculate_transfer_parameters,[0.35, 10, 20], [], [], [], [], [0, 1, 1], [1000, 1000, 1000]);
function error = calculate_transfer_parameters(x)
    K = x(1);
    T1 = x(2);
    T2 = x(3);
    Td = 15;
    y = readmatrix("pqfile.txt");
    y_size = size(y(:,4));
    kk = y_size(1);
    u(1:kk) = 39;
    u(1) = 29;
    y_w = model(u,y(:,4),kk,Td, K, T1, T2);
    error = calculate_square_error(y(:,4),transpose(y_w));
    % error
end
function error = calculate_square_error(y_zad, y_wy)
s = (y_zad-y_wy);
error = sum((y_zad-y_wy).^2);
end