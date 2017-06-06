% This function starts a session with the Datapixx projector
% 
% inputs:
%       hardwareParameters: a HardwareParameters object; this is where all
%       of the relevant parameters

function Datapixx(hardwareParameters)
% open Datapixx
Datapixx('Open');

% Propixx has different sequences for different display speeds:
%    0 for normal
%    2 for 480 Hz where each quadrant of the image is a frame
%    5 for 1440 Hz where each color channel of each quadrant is a frame
if hardwareParameters.RenderInQuadrants
    propixxMode = 2;
else
    propixxMode = 0;
end
Datapixx('SetPropixxDlpSequenceProgram', propixxMode);

% synchronize Datapixx registers to local register cache (whatever that
% means...)
Datapixx('RegWrRd');
end