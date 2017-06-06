% % Benham's Top
clear all;
clc;
p = SConePsychophysics.StimulusGenerators.BenhamsTop.Parameters.DebugExample();
g = @SConePsychophysics.StimulusGenerators.BenhamsTop.Generate;  
sess = SConePsychophysics.PsychtoolboxSession('DebugMode', true, 'DebugModeFullScreen',  false, ...
    'RenderInQuadrants', false, 'BackgroundIntensity', p.backgroundIntensityMonitorSpace);
% s = '/Users/psycho/Desktop/SlaveCode/Jacob/results/benhams-top';
s = '/Users/jacobbaudin/Desktop';
SConePsychophysics.Main(p, g, sess, s); 
 
sess.Close();
%%  Flicker (with wrapper /  parameter builder)
p =  SConePsychophysics.StimulusGenerators.Flicker.Parameters.DebugExample();
g = @SConePsychophysics.StimulusGenerators.Flicker.Generate;
sess = SConePsychophysics.PsychtoolboxSession('DebugMode', true, 'DebugModeFullScreen',  false, ...
    'RenderInQuadrants', false, 'BackgroundIntensity', p.backgroundIntensityMonitorSpace);
% s = '/Users/psycho/Desktop/SlaveCode /Jacob/results/flicker';
s = '/Users/jacobbaudin/Desktop';
SConePsychophysics.Main(p, g, sess, s);

sess.Close();
%% Stockman
p =   SConePsychophysics.StimulusGenerators.Flicker.Parameters.StockmanExample();
g = @SConePsychophysics.StimulusGenerators.Flicker.Generate; 
sess = SConePsychophysics.PsychtoolboxSession('DebugMode', true, 'DebugModeFullScreen',  false, ...
    'RenderInQuadrants', false, 'BackgroundIntensity', p.backgroundIntensityMonitorSpace);
% s = '/Users/psycho/Desktop/SlaveCode/Jacob/results/stockman-flicker';
s = '/Users/jacobbaudin/Desktop';
SConePsychophysics.Main(p, g, sess, s);
 
sess.Close();
%%
Screen('CloseAll');  