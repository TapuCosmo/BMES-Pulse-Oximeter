clear all;

config = jsondecode(fileread("../config.json")).matlab;

ard = arduino(config.arduino.port, config.arduino.board);

configurePin(ard, config.arduino.pins.photoresistor, "AnalogInput");
configurePin(ard, config.arduino.pins.redLED, "DigitalOutput");
configurePin(ard, config.arduino.pins.irLED, "DigitalOutput");
