function stimulusRect = GetStimulusRectangle(stimulusParameters)
sideLength = 2 * stimulusParameters.radius + 1;
stimulusRect = [0 0 sideLength sideLength];
end