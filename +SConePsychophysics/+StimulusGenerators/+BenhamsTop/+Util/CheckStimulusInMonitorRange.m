% This function checks if the parameters specified in the input
% 'stimulusParameters' will results in a stimulus that remains within the
% range of the monitor.  If not, it throws an error.

function CheckStimulusInMonitorRange(stimulusParameters)
% there are only a very limited number of pixel values that will be
% produced; go through and create these in stimulus space, covert them to
% monitor space, and make sure they are within the bounds of the monitor

% there is the case where everything at the backgroundIntensities
backgroundBackgroundBackground = stimulusParameters.backgroundIntensities;
% the case where everything is at the darkIntensities
darkDarkDark = stimulusParameters.darkIntensities;
% the case where dimensions 1 & 2 are dark and 3 is background
darkDarkBackground = [stimulusParameters.darkIntensities(1:2) stimulusParameters.backgroundIntensities(3)];
% the case where dimensions 1 & 2 are background and 3 is dark
backgroundBackgrounDark = [stimulusParameters.backgroundIntensities(1:2) stimulusParameters.darkIntensities(3)];

% compile these all together
stimuliToCheck = {backgroundBackgroundBackground, darkDarkDark, darkDarkBackground, backgroundBackgrounDark};

% check them all, if they aren't in the bounds, throw an error
if ~all(cellfun(@(x) SConePsychophysics.Utils.IsWithinMonitorBounds(x), stimuliToCheck))
    % close the Psychtoolbox screen
    Screen('CloseAll');
    error(['The given set of stimulusParameters result in a stimulus that is out of the range ' ...
        'that the monitor can produce.']);
end
end