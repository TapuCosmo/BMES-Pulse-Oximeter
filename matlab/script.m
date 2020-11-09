clear all;

config = jsondecode(fileread("../config.json")).matlab;

ard = arduino(config.arduinoPort, config.arduinoBoard);
