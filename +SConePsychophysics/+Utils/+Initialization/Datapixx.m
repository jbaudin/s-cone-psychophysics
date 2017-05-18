function Datapixx(hardwareParameters, varargin)
ip = inputParser();
ip.addOptional('DebugMode', false, @(x) islogical(x));
ip.addOptional('RenderInQuadrants', true, @(x) islogical(x));
ip.parse(varargin{:});

% add rendering mode to hardwareParameters
hardwareParameters.renderInQuadrants = ip.Results.RenderInQuadrants;

% if debugging, short circuit this and don't load Datapixx
if ip.Results.DebugMode
    return;
end

% open Datapixx
Datapixx('Open');

% Propixx has different sequences for different display speeds:
%    0 for normal
%    2 for 480 Hz where each quadrant of the image is a frame
%    5 for 1440 Hz where each color channel of each quadrant is a frame
if ip.Results.RenderInQuadrants
    propixxMode = 2;
else
    propixxMode = 0;
end
Datapixx('SetPropixxDlpSequenceProgram', propixxMode);

% synchronize Datapixx registers to local register cache (whatever that
% means...)
Datapixx('RegWrRd');
end