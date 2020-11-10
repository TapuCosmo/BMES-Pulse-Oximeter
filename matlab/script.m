clear all;

scriptPath = genpath(pwd);
addpath(scriptPath);

% Read config values from config file
config = jsondecode(fileread("../config.json")).matlab;

prPin = config.arduino.pins.photoresistor;
redLEDPin = config.arduino.pins.redLED;
irLEDPin = config.arduino.pins.irLED;

samplePeriod = config.samplePeriod;
maxSamples = config.maxSamples;

% Set up Arduino
ard = arduino(config.arduino.port, config.arduino.board);

configurePin(ard, prPin, "AnalogInput");
configurePin(ard, redLEDPin, "DigitalOutput");
configurePin(ard, irLEDPin, "DigitalOutput");

readings = [];

% Only red LED for now to measure heartbeat
writeDigitalPin(ard, redLEDPin, 1);

% Measure heartbeat
tic();

for i = 1:maxSamples
    loopStartTime = toc();
    readings(i) = readVoltage(ard, prPin);
    sleep(samplePeriod - toc() + loopStartTime);
end

endTime = toc();

% Fourier transform
X = detrend(readings);
Y = fft(X);
P2 = abs(Y / maxSamples);
P1 = P2(1:maxSamples / 2 + 1);
P1(2:end - 1) = 2 * P1(2:end - 1);
f = (maxSamples / endTime) * (0:(maxSamples / 2)) / maxSamples;

% Fourier transform graph
figure(1);
plot(f, P1);
title("Signal Frequencies");
xlabel("f (Hz)");

% Voltage graph
figure(2);
plot(0:(endTime / maxSamples):endTime - 0.0001, readings);
title("Voltage Readings");
xlabel("t (s)");
ylabel("Voltage (V)");

rmpath(scriptPath);
