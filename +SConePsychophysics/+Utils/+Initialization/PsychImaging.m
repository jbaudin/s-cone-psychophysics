function PsychImaging()
% prepares setup of imaging pipeline for onscreen window
PsychImaging('PrepareConfiguration');

% setup framebuffer 
PsychImaging('AddTask', 'General', 'FloatingPoint32BitIfPossible');
end