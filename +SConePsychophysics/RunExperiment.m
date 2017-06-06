% Runs a single experiment using a provided cycler.  Will run until 
% subject submits results, or until a max runtime (specified in constants)
% is reached.
%
% Takes keyboard inputs from the user:
%       left arrow: decrement offset
%       right arrow: increment offset
%       space: submit offset and end experiment
%
% Inputs:
%    cycler: a Cycler object (upon writing this, this will either be an
%           Oscillator or a Spinner), which will have been returned from
%           the Generate function for some stimulus
%
% Returns:
%   results: the results returned from the cycler when the subject
%           submitted the results

function results = RunExperiment(cycler)
% convert the runtime from seconds to frames, rounding up; the runtime is
% set in the Constants class file
maxRuntimeInFrames = ceil(cycler.TimeToFrames(SConePsychophysics.Constants.MAX_RUNTIME));

% start a counter for the current frame number
frameNumber = 1;

% start a timer for checking for keyboard input (this will 
% make sure that if a subject holds down a key for an extended
% period of time, it doesn't move through offsets excessively
% quickly); the minimum delay between keyboard checks is set in the
% constants class
keyboardTimer = SConePsychophysics.Utils.KeyboardInputTimer(SConePsychophysics.Constants.KEYBOARD_CHECK_INTERVAL);

% run the actual experiment by showing successive frames and checking
% for user input
while frameNumber <= maxRuntimeInFrames && cycler.ToContinueCycling()
    % have the cycler display the frame
    cycler.DisplayFrame(frameNumber)
    
    % increment the frame counter
    frameNumber = frameNumber + 1;
    
    % if sufficient time has passed, check the keyboard for input
    if keyboardTimer.ToCheckKeyboard();
        % do the check and determine both if the keyboard was struck and if
        % it was, what the key code was
        [isKey, ~, keyCode, ~] = KbCheck();
        
        % if a key has been pushed, send it to the function that handles
        % keyboard input and reset the keyboard timer
        if isKey
            SConePsychophysics.Utils.HandleKeyboardInput(keyCode, cycler);
            keyboardTimer.Reset();
        end
    end
end

% get the results from the cycler to be sent back to Main
results = cycler.CompileResults();
end