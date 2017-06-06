% This function calculates the rectangle size for the stimulus specified in
% stimulusParameters and returns it in the standard Psychtoolbox format.
% Currently all stimuli are actually squares, so this will always return a
% square.
%
% inputs:
%       stimulusParameters: stimulus parameters object that must contain a
%               radius property
%
% returns:
%       stimulusRect: the calculated rectangle for the stimulus in the
%               format: [0 0 length length].

function stimulusRect = GetStimulusRectangle(stimulusParameters)
sideLength = 2 * stimulusParameters.radius + 1;
stimulusRect = [0 0 sideLength sideLength];
end