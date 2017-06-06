% generation is easier for this case, it will just need to return a cycler
% with the approriate offset values (this will be a map that goes from keys
% of offset step position to actual offsets in radians)
function cycler = Generate(stimulusParameters, hardwareParameters)

% because stimuli are not required to be specified in RGB space, the
% parameters must first be checked to see if they will result in any
% stimuli that are outside of the range of the monitor, perform that check
% here (it will throw and error and close Psychtoolbox screen if out of
% range).
SConePsychophysics.StimulusGenerators.Flicker.Util.CheckStimulusInMonitorRange(stimulusParameters, hardwareParameters);

% generate an array of offset steps (integers that identify the given step
% number) and an array of offset sizes (the actual time offset of those
% steps)
[offsetSteps, offsetSizes] = SConePsychophysics.StimulusGenerators.Flicker.Util.GenerateOffsets(stimulusParameters);

% make these into a lookup for the cycler
offsetLookup = containers.Map(num2cell(offsetSteps), num2cell(offsetSizes));

% make the cylcer to return
cycler = SConePsychophysics.Cyclers.Oscillator(hardwareParameters, stimulusParameters, offsetLookup);
end