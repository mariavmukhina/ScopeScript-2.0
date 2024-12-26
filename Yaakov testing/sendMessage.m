function response = sendMessage(arduinoSerial, msg)
    % sendMessage: Sends a message to the Arduino via serial communication
    % Inputs:
    %   - arduinoSerial: The serialport object connected to the Arduino
    %   - msg: The message to send to the Arduino (e.g., "ON", "OFF")
    % Output:
    %   - response: The response received from the Arduino

    % Flush serial buffer to clear any old data
    flush(arduinoSerial);
    
    % Send the command
    writeline(arduinoSerial, msg); % Write the provided message
    pause(0.2); % Short delay to ensure Arduino has time to respond
    
    % Read and return the response
    response = readline(arduinoSerial); % Read response from Arduino
    disp("Arduino responded: " + response); % Print response
end
