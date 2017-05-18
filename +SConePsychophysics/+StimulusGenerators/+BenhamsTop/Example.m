clc;

p = SConePsychophysics.StimulusGenerators.BenhamsTop.Parameters();
p.backgroundIntensity = 0.5;
p.darkIntensity = 0;
p.rotationFrequency = 5;
p.offsetStepSize = 0.1;
p.maxOffset = 1;
p.minOffset = -1;
p.radius = 100;
p.numArcGroups = 3;
p.numArcsInGroups = [4 3 3];
p.arcGroupThetas = {[0 pi / 3], [(pi / 3) (2 * pi / 3)], [(2 * pi / 3) pi]};
p.arcThickness = 0.04;
p.arcMargin = 0.04;
p.startArcRadius = 0.18;

frameData = SConePsychophysics.StimulusGenerators.BenhamsTop.Generate(p, [], 'ReturnOnlyFrameData', true);

%%
offsets = cell2mat(frameData.keys());
for i = 1:numel(offsets)
   curr = frameData(offsets(i));
   figure;
   for j = 1:3
      subplot(1, 3, j);
      imagesc(255 * curr(:,:,j));
   end
end

%% offsets = cell2mat(frameData.keys());
for i = 1:numel(offsets)
   curr = frameData(offsets(i));
   figure;
   imagesc(255 * curr);
end