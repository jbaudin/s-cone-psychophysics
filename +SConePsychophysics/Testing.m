%% Benham's Top
clc;
p = SConePsychophysics.StimulusGenerators.BenhamsTop.Parameters.DebugExample();
g = @SConePsychophysics.StimulusGenerators.BenhamsTop.Generate;
s = '/Users/jacobbaudin/Desktop/results';
SConePsychophysics.Main(p, g, s, 'DebugMode', true, 'RenderInQuadrants', true);

%% Flicker (with wrapper / parameter builder)
clc;
b =  SConePsychophysics.StimulusGenerators.Flicker.SameFrequencyFlickerParameters.DebugExample();
p = b.Build();
g = @SConePsychophysics.StimulusGenerators.Flicker.Generate;
s = '/Users/jacobbaudin/Desktop/results';
SConePsychophysics.Main(p, g, s, 'DebugMode', true, 'RenderInQuadrants', true);

%% Stockman
clc;
p =  SConePsychophysics.StimulusGenerators.Flicker.Parameters.StockmanExample();
g = @SConePsychophysics.StimulusGenerators.Flicker.Generate;
s = '/Users/jacobbaudin/Desktop/results';
SConePsychophysics.Main(p, g, s, 'DebugMode', true, 'RenderInQuadrants', true);

%%
Screen('CloseAll');  