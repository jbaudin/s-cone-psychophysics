% This function takes a 3-channel frame and converts the values from one 3
% dimensional space to another via the provided transformation matrix.
%
% inputs:
%       oldStimulus: a 3-channel frame in an array of shape height x width x 3
%
% returns:
%       newStimulus: a 3-channel frame of shape identical to oldStimulus,
%               but with the 3 dimensional values for each pixel
%               transformed to a new space

function newStimulus = TransformStimulusSpace(oldStimulus, transformationMatrix)
% figure out stimulus dimensions
[h, w, c] = size(oldStimulus);

% make sure it has 3 channels, if not, throw an error
if c ~= 3
    error('Inputs to TransformStimulusSpace must have a size of 3 in the third dimension.');
end

% do the actual transformation; doing some reshaping first is significantly
% faster than looping through all fo the pixels (by something in the range
% of a factor of 10 - 100), so do this first
oldStimulusReshaped = reshape(oldStimulus, [h * w 3])';
% project to new space
newStimulusReshaped = transformationMatrix * oldStimulusReshaped;
% return to original shape
newStimulus = reshape(newStimulusReshaped', [h w 3]);
end