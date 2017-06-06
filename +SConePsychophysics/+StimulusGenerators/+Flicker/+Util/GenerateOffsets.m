% This function generates two vectors, one of offset steps and another of
% corresponding offset sizes (in this case, they will be the phase offsets
% for the given offest step numbers)

function [offsetSteps, offsetSizes] = GenerateOffsets(stimulusParameters)
% figure out constraints on offset step sizes
maxOffsetStepNum = floor(stimulusParameters.maxOffset / stimulusParameters.offsetStepSize);
minOffsetStepNum = ceil(stimulusParameters.minOffset / stimulusParameters.offsetStepSize);

% make an array of offset steps (these will be the containers.Map keys)
offsetSteps = (minOffsetStepNum:maxOffsetStepNum);

% multiply that array by the step size to get an array of offset sizes
offsetSizes = offsetSteps * stimulusParameters.offsetStepSize;
end