% This function checks if the parameters specified in the input
% 'stimulusParameters' will results in a stimulus that remains within the
% range of the monitor.  If not, it throws an error.

function CheckStimulusInMonitorRange(stimulusParameters, hardwareParameters)
% make a time vector for the maximum possible experiment duration
frameDur = hardwareParameters.theoreticalFrameDuration;
time = frameDur:frameDur:SConePsychophysics.Constants.MAX_RUNTIME;

% generate a matrix of stimuli in stimulus space; row i of this matrix will
% be the stimulus in the i-th dimension in stimulus space
% make sure the frequencies are in a column vector
frequencies = stimulusParameters.frequencies;
amplitudes = stimulusParameters.peakIntensities - stimulusParameters.backgroundIntensities;
backgrounds = stimulusParameters.backgroundIntensities;

% get the projection matrix to transform the stimulus from stimulus space
% to monitor (i.e. RGB) space
projectionMatrix = SConePsychophysics.Constants.COLOR_SPACE_PROJECTION_MATRICES(stimulusParameters.colorSpace);

% get an array of offsets
[~, offsetSizes] = SConePsychophysics.StimulusGenerators.Flicker.Util.GenerateOffsets(stimulusParameters);

% check to see if the stimulus will be ok for all offsets, if not, throw an
% error
% make a function handle for clarity 
checkFxn = @(offset) OffsetIsInBounds(time, backgrounds, amplitudes, frequencies, offset, projectionMatrix);
if ~all(arrayfun(@(x) checkFxn(x), offsetSizes))
    % close the Psychtoolbox screen
    Screen('CloseAll');
    error(['The given set of stimulusParameters result in a stimulus that is out of the range ' ...
        'that the monitor can produce.']);
end

    % the function that does the actual check to make sure the stimulus
    % will be in bounds
    function tf = OffsetIsInBounds(time, backgrounds, amplitudes, frequencies, offset, projectionMatrix)
        % generate the stimulus in stimulus space
        stimulusInStimulusSpace = zeros(3, numel(time));
        offsets = [0 0 offset];
        for i = 1:3
            stimulusInStimulusSpace(i, :) = backgrounds(i) + ...
                amplitudes(i) * sin(2 * pi * frequencies(i) * time + offsets(i));
        end
        
        % transform the stimulus from stimulus space to monitor space
        stimulusInMonitorSpace = projectionMatrix * stimulusInStimulusSpace;
        
        % get the minimum and maximum values for each of the dimensions in monitor
        % space
        minimumValues = min(stimulusInMonitorSpace, [], 2);
        maximumValues = max(stimulusInMonitorSpace, [], 2);
        
        % check if these values fall within the bounds
        tf = SConePsychophysics.Utils.IsWithinMonitorBounds(maximumValues) ...
            && SConePsychophysics.Utils.IsWithinMonitorBounds(minimumValues);
    end
end