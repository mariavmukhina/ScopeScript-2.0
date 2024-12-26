
% Initialize serial communication
arduinoSerial = serialport("COM4", 115200); % Replace "COM3" with your Arduino's port

configureTerminator(arduinoSerial, "LF"); % Use newline as the terminator
pause(2); % Allow Arduino to initialize
disp("Arduino Connected")
%%
writeline(arduinoSerial, 'O');
%%
for i = 1:50
    writeline(arduinoSerial, 'F');
    pause(1);
    writeline(arduinoSerial, 'O');
    pause(1);
    disp(i);
end
%%
for i = 1:10
    mmc.setSerialPortCommand("COM4",'O','');
    pause(1)
    mmc.setSerialPortCommand("COM4",'B','');
    pause(1)

end

%%

for i = 1:100

    setPekaLED(0);
    pause(0.05)
    setPekaLED(1, 20*i);
    pause(0.05)

end

%%

global ti2; % Ensure ti2 is initialized properly
    
% Initialize variables
tic; % Start the timer
for i = 1:1
    ti2.DiaLampSwitch.Value = 0; % Turn on LED
    ti2.DiaLampSwitch.Value = 1; % Turn off LED
end
elapsedTime = toc; % Stop the timer

disp(toc)
%%
tic; % Start the timer
for i = 1:100
    writeline(arduinoSerial, 'B'); % Turn on LED
    writeline(arduinoSerial, 'O'); % Turn off LED
end
elapsedTime = toc; % Stop the timer

disp(toc)

%%

% Cleanup
clear arduinoSerial;
disp("arduino cleared")