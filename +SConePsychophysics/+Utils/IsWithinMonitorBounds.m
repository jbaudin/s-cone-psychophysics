% This function determines if a point in RGB space is within the bounds of
% the monitor's display range.
%
% inputs:
%       stim: a point in RGB space to be tested
%
% returns:
%       tf: a boolean, based on whether or not stim is a valid point within
%           the monitor's display range

function tf = IsWithinMonitorBounds(stim)
% check to make sure the values for each stim dimension are lower than the
% upper bounds for that dimension, and greater than the lower bounds; these
% bounds are set in the constants class
withinUpperBound = all(stim <= reshape(SConePsychophysics.Constants.MONITOR_SPACE_UPPER_BOUNDS, size(stim)));
withinLowerBound = all(stim >= reshape(SConePsychophysics.Constants.MONITOR_SPACE_LOWER_BOUNDS, size(stim)));

% return true only if the stimulus in monitor space is within the
% upper and lower bounds
tf = withinUpperBound && withinLowerBound;
end