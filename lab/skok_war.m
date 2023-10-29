addpath('D:\SerialCommunication'); % add a path to the functions
initSerialControl COM13 % initialise com port
figure
measurements1 = ones(1, 1)*readMeasurements(1);
plot(measurements1)
i = 1;
went = 10;
while(1)

    %% obtaining measurements
    measurements1 = [ measurements1(1:end);readMeasurements(1)]% read measurements from 1 to 7
    refreshdata
    drawnow
    plot(measurements1)
    measurements3 = readMeasurements(3)
    matlab2tikz ('zad2_39.tex' , 'showInfo' , false)
    %% processing of the measurements and new control values calculation

    %% sending new values of control signals
    sendControls([5, 1], ... send for these elements
                 [29, 50]);  % new corresponding control values

     measurement = readMeasurements(1:1); 
    %% synchronising with the control process
    waitForNewIteration(); % wait for new batch of measurements to be ready
end