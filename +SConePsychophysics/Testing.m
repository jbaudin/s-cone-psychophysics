% % Benham's Top
clear all;
clc;
sess = SConePsychophysics.PsychtoolboxSession('DebugMode', true, 'DebugModeFullScreen',  true,'RenderInQuadrants', true);
p = SConePsychophysics.StimulusGenerators.BenhamsTop.Parameters.DebugExample();
g = @SConePsychophysics.StimulusGenerators.BenhamsTop.Generate;  
s = '/Users/jacobbaudin/Desktop/results'; 
SConePsychophysics.Main(p, g, sess, s);
 
%% Flicker (with wrapper / parameter builder)
b =  SConePsychophysics.StimulusGenerators.Flicker.SameFrequencyFlickerParameters.DebugExample();
p = b.Build( ); 
g = @SConePsychophysics.StimulusGenerators.Flicker.Generate;
s =   '/Users/jacobbaudin/Desktop/results';
SConePsychophysics.Main(p, g, sess, s);

%% Stockman
p =  SConePsychophysics.StimulusGenerators.Flicker.Parameters.StockmanExample();
g = @SConePsychophysics.StimulusGenerators.Flicker.Generate; 
s = '/Users/jacobbaudin/Desktop/results';
SConePsychophysics.Main(p, g, sess, s);

%%
Screen('CloseAll');  