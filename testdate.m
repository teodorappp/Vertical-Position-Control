clc;
clear all;

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
configureTerminator(s,"LF");
flush(s); % Clear any existing data in the buffer
while true
    if s.NumBytesAvailable >= 1
        start_bit = read(s, 1, "uint8");
        if start_bit == 0x01
            disp('Start bit detected');
            break;
        end
    end
end
if s.NumBytesAvailable >= 8
    rx_data = read(s, 8, "uint8");
    TransmitData.data_ch = rx_data;
    int1 = typecast(uint8(TransmitData.data_ch(1:4)), 'uint32');
    int2 = typecast(uint8(TransmitData.data_ch(5:8)), 'uint32');
    disp('Received Integers:');
    disp(int1);
    disp(int2);
else
    disp('Not enough data received');
end
% Close the serial port
clear s;
disp('Session Terminated...');