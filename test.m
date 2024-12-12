clc; 
clear;
% load('Identif_ex.mat', 'arx_time');
% load('Identif_ex.mat', 'arx_u');
Ns = 1000; %Number of samples
Ts = 0.01;
T_pause = 0.0005;
N_sampl_plot = 50;
time = [];
Y = [];
dc=[];
time = [time 0];
start = 0;
plotTitle = 'Serial Data Log';  % plot title
xLabel = 'Time (s)';            % x-axis label
yLabel = 'Data';                % y-axis label
plotGrid = 'on';                % 'off' to turn off grid
min = 0;                        % set y-min
max = 80;                      % set y-max
scrollWidth = 10;               % display period in plot, plot entire data log if <= 0

%Define Function Variables
data = 0;
count = 0;

%Define UI elements

figureHandle = figure('NumberTitle','off',...
        'Name','DC Motor control');
ports = serialportlist;

compop = uicontrol('Parent',figureHandle,...
        'Style', 'popupmenu',...
        'String', ports,...
        'Position', [20 30 80 20]);  

startbutton = uicontrol('Parent',figureHandle,...
        'Style', 'togglebutton',...
        'String', 'Start',...
        'Position', [20 5 80 20]); 
    
textRef = uicontrol('Parent',figureHandle,...
        'Style', 'text',...
        'String', 'Referinta',...
        'Position', [260 5 80 20]);    
ref= uicontrol('Parent',figureHandle,...
        'Style', 'edit',...
        'String', 0,...
        'Position', [340 5 80 20]); 
textCom = uicontrol('Parent',figureHandle,...
        'Style', 'text',...
        'String', 'Comanda',...
        'Position', [260 30 80 20]);    
sld2 = uicontrol('Parent',figureHandle,...
        'Style', 'edit',...
        'String', 0,...
        'Position', [340 30 80 20]);


% textTi = uicontrol('Parent',figureHandle,...
%         'Style', 'text',...
%         'String', 'Ti',...
%         'Position', [100 5 80 20]);    
% sldTi = uicontrol('Parent',figureHandle,...
%         'Style', 'edit',...
%         'String', 0,...
%         'Position', [150 5 80 20]); 
% textKp = uicontrol('Parent',figureHandle,...
%         'Style', 'text',...
%         'String', 'Kp',...
%         'Position', [100 30 80 20]);    
% sldKp = uicontrol('Parent',figureHandle,...
%         'Style', 'edit',...
%         'String', 0,...
%         'Position', [150 30 80 20]);

    
bg = uibuttongroup('Position',[0.8 0.01 0.20 0.115]);
              
% Create three radio buttons in the button group.
r1 = uicontrol(bg,'Style',...
                  'radiobutton',...
                  'String','MANUAL',...
                  'Position',[10 25 80 20],...
                  'HandleVisibility','off');
              
r2 = uicontrol(bg,'Style','radiobutton',...
                  'String','AUTOMAT',...
                  'Position',[10 5 80 20],...
                  'HandleVisibility','off');
              
axesHandle = axes('Parent',figureHandle,...
        'YGrid','on',...
        'XGrid','on',...
        'Position', [0.1 0.25 0.85 0.65]);
hold on;

plotHandle = plot(axesHandle,time,data,'-m',time,data,...
                'LineWidth',1,...
                'MarkerEdgeColor','k',...
                'MarkerFaceColor',[.49 1 .63],...
                'MarkerSize',2);
             
title(plotTitle,'FontSize',25);
xlabel(xLabel,'FontSize',15);
ylabel(yLabel,'FontSize',15);
axis([0 10 min max]);
% grid(plotGrid);

while(startbutton.Value == 0)
    compop.String = cellstr(serialportlist);
    pause(0.2)
end

%User Defined Properties 
srlPort = char(compop.String(compop.Value));           % define COM port #
baudRate = 115200;
s = serialport(srlPort,baudRate);
%s.InputBufferSize = 65535;


disp(strcat('Serial Comm Opened on port: ',srlPort));
% fopen(s);
disp('Starting Session');
% profiler on -history
flush(s);

pause(2)
write(s, 1,'uint8');               %flag that starts the communication

while ishandle(plotHandle) %Loop when Plot is Active
     if(s.NumBytesAvailable>=4)
        dat = (read(s,2,'uint16')); %Read Data from Serial as int
        count = count + 1;  

        Y(count) = dat(1)/100; %Extract 1st Data Element   
        dc(count)=dat(2)/100;

       if(mod(count,N_sampl_plot) ==0) 
         if(scrollWidth > 0)
            set(plotHandle,'XData',time(time > time(count)-scrollWidth),'YData',Y(time > time(count)-scrollWidth));
            axis([time(count)-scrollWidth time(count) min max]);
            else
            set(plotHandle,'XData',time,'YData');
            axis([0 time(count) min max]);
         end
            x=cast(str2double(get(ref, 'String')),'uint16');
            x2=cast(str2double(get(sld2, 'String')),'uint16');
             write(s, x2,'uint16');
            write(s, x,'uint16');
          
            if(get(r1,'Value') == get(r1,'Max'))
                x_cmd = 0;
                xKp=cast(str2double(get(sldKp, 'String'))*1000,'uint16');
                xTi=cast(str2double(get(sldTi, 'String'))*1000,'uint16');
            else
                x_cmd = 1;
                xKp=0;
                xTi=0;
            end
          
%             write(s, x_cmd,'uint16');
            %write(s, xKp,'uint16');
            %write(s, xTi,'uint16');
       end
       time = [time time(end)+Ts];
     end
     pause(T_pause);
end

write(s, 0,'uint64');

% profiler off
s.NumBytesAvailable
time = time(1:length(time)-1);
if(~isempty(time))
    s.NumBytesAvailable
    figure; plot(time,Y);
    figure; plot(time,dc);
%     figure;subplot(2,1,1);plot(arx_time,arx_u);
%     subplot(2,1,2);plot(arx_time,arx_Y);
end




%Close Serial COM Port and Delete useless Variables

% clear s count dat delay max min baudRate ...
%         scrollWidth;
 
 
disp('Session Terminated...');