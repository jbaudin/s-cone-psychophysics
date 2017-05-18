function frameRect = GetFrameRectangle(hardwareParameters)
frameRect = [0 0 hardwareParameters.width hardwareParameters.height];
if hardwareParameters.renderInQuadrants
    frameRect = frameRect / 2;
end
end