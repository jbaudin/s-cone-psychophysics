% This function will run a prepare, run, and save the results from a single
% experiment.  Its inputs are:
%   stimulusParameters: an object that contains all of the parameters
%           necessary to specify the stimulus
%   generator: a handle to the generator function (this function must take
%           as inputs the stimulusParameters and hardware parameters from
%           the session, and return a cycler for the experiment)
%   session: an SConePsychophysics.PsychtoolboxSession object that will
%           control where the experiment is displayed
%   savePath: a string specifying the path of the folder in which to save
%           the results of the experiment

function Main(stimulusParameters, generator, session, savePath)
% create the stimulus cycler; stimulus generators will return the
% appropriate cycler
cycler = generator(stimulusParameters, session.hardwareParameters);

% run the experiment by giving the cycler to the function that controls a
% given experiment
results = SConePsychophysics.RunExperiment(cycler);

% clear the screen to its background
session.Clear();

% save the parameters and results
session.hardwareParameters.Save(fullfile(savePath, 'hardwareParameters.txt'));
stimulusParameters.Save(fullfile(savePath, 'stimulusParameters.txt'));
results.Save(fullfile(savePath, 'results.txt'));
end