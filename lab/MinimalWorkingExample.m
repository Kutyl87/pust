function MinimalWorkingExample()
    addpath('D:\SerialCommunication'); % add a path to the functions
    initSerialControl COM13 % initialise com port
    figure
    measurements1 = ones(400, 1)*readMeasurements(1);
    plot(measurements1)
    i = 1;
    went = 10;
    while(1)
       
        %% obtaining measurements
        measurements1 = [ measurements1(2:end);readMeasurements(1)]% read measurements from 1 to 7
        refreshdata
        drawnow
        plot(measurements1)
        measurements3 = readMeasurements(3);
        matlab2tikz ('zad1_pp.tex' , 'showInfo' , false)
        %% processing of the measurements and new control values calculation

        %% sending new values of control signals
        sendControls([ 1,2, 5], ... send for these elements
                     [ 50,0, 29]);  % new corresponding control values
        
         measurement = readMeasurements(1:1); 
        %% synchronising with the control process
        waitForNewIteration(); % wait for new batch of measurements to be ready
        if(i > 20)
            went = 60;
        end
        i = i+ 1;
    end
end