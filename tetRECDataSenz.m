clc;
clear all;
close all;

% List available serial ports
availablePorts = serialportlist;

if isempty(availablePorts)
    error('No serial ports available.');
end

% Open the first available serial port
srlPort = availablePorts(1);
baudRate = 115200;
s = serialport(srlPort, baudRate);
% Configure serial port
configureTerminator(s, "LF");
flush(s); % Clear any existing data in the buffer





% Close the serial port
clear s;
disp('Session Terminated...');
