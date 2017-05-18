%% Benham's Top
clc;
p = SConePsychophysics.StimulusGenerators.BenhamsTop.Parameters.DebugExample();
g = @SConePsychophysics.StimulusGenerators.BenhamsTop.Generate;
s = '/Users/jacobbaudin/Desktop/results';
SConePsychophysics.Main(p, g, s, 'DebugMode', true, 'RenderInQuadrants', false);

%% Flicker
clc;
p = SConePsychophysics.StimulusGenerators.Flicker.Parameters.DebugExample();
g = @SConePsychophysics.StimulusGenerators.Flicker.Generate;
s = '/Users/jacobbaudin/Desktop/results';
SConePsychophysics.Main(p, g, s, 'DebugMode', true, 'RenderInQuadrants', false);

     %%
Screen('CloseAll'); 