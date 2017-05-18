function results = RunExperiment(cycler, keyboardCheckInterval, maxRuntime)
% convert the runtime from seconds to frames, rounds up 
maxRuntimeInFrames = ceil(cycler.TimeToFrames(maxRuntime));

% start a counter for the frame number
frameNumber = 1;
% start a timer for checking for keyboard input (this will 
% make sure that if a subject holds down a key for an extended
% period of time, there it doesn't move through offsets excessively
% quickly)
keyboardTimer = SConePsychophysics.Utils.KeyboardInputTimer(keyboardCheckInterval);

% run the actual experiment by showing successive frames and checking
% for user input
while frameNumber <= maxRuntimeInFrames && cycler.continueCycling
    % have the cycler display the frame
    cycler.DisplayFrame(frameNumber)
    
    % increment the frame counter
    frameNumber = frameNumber + 1;
    
    % if sufficient time has passed, check the keyboard for input
    if keyboardTimer.ToCheckKeyboard();
        [isKey, ~, keyCode, ~] = KbCheck();
        
        if isKey
            SConePsychophysics.Utils.HandleKeyboardInput(keyCode, cycler);
            keyboardTimer.Reset();
        end
    end
end

% get the results to be sent back to Main
results = cycler.CompileResults();
end