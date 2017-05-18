classdef Cycler < handle
    properties
        hardwareParameters
        stimulusComponents
    end
    
    properties (Access = private)
        currOffset
        offsetMin
        offsetMax
        
        continueCycling
        drawTextureFxn
        
        baseRectangleCenter
        rectangleCenterOffsets
    end
    
    methods
        function obj = Cycler(hardwareParameters, stimulusComponents)
            obj.hardwareParameters = hardwareParameters;
            obj.stimulusComponents = stimulusComponents;
            obj.currOffset = 0;
            obj.continueCycling = true;
            
            if obj.hardwareParameters.renderInQuadrants
                obj.drawTextureFxn = @(frameNum) obj.DrawTextureInQuadrants(frameNume);
                obj.baseRectangleCenter = CenterRectOnPoint( ...
                    SConePsychophysics.Utils.GetFrameRectangle(obj.hardwareParameters), ...
                    obj.hardwareParameters.width / 4, obj.hardwareParameters.height / 4);
                obj.ComputeRectangleCenterOffsets();
            else
                obj.drawTextureFxn = @(frameNum) obj.DrawTextureEntireScreen(frameNum);
                obj.baseRectangleCenter = CenterRectOnPoint( ...
                    SConePsychophysics.Utils.GetFrameRectangle(obj.hardwareParameters), ...
                    obj.hardwareParameters.width / 2, obj.hardwareParameters.height / 2);
            end
        end
        
        function ComputeRectangleCenterOffsets(obj)
            width = obj.hardwareParameters.width;
            height = obj.hardwareParameters.height;
            obj.rectangleCenterOffsets = {[0 0 0 0], ...
                [(width / 2) 0 (width / 2) 0], ...
                [0 (height / 2) 0 (height / 2)], ...
                [(width / 2) (height / 2) (width / 2) (height / 2)]};
        end
        
        function IncrementOffset(obj)
            if obj.currOffset < obj.offsetMax
                obj.currOffset = obj.currOffset + 1;
            end
        end
        
        function DecrementOffset(obj)
            if obj.currOffset > obj.offsetMin
                obj.currOffset = obj.currOffset - 1;
            end
        end
        
        function DisplayFrame(obj, frameNumber)
            % call the appropriate draw texture method (defined in
            % constructor)
            obj.drawTextureFxn(obj.FramesToTime(frameNumber));            
        end
        
        function DrawTextureInQuadrants(obj, frameTime)
            frameTimes = frameTime + ((0:3) / 4) * obj.hardwareParameters.theoreticalFrameDuration;
            for i = 1:4
                [texture, rotation] = obj.GenerateSingleFrame(frameTimes(i));
                Screen('DrawTexture', ...
                    obj.hardwareParameters.window, ...
                    texture, ...
                    [], ...
                    obj.baseRectangleCenter + obj.rectangleCenterOffsets{i}, ...
                    rotation);
            end
        end
        
        function DrawTextureEntireScreen(obj, frameTime)
            [texture, rotation] = obj.GenerateSingleFrame(frameTime);
            Screen('DrawTexture', ...
                obj.hardwareParameters.window, ...
                texture, ...
                [], ...
                obj.baseRectangelCenter, ...
                rotation);
        end
        
        % this may be the only thing that needs to be overriden in
        % subclasses ...
        function frame, rotation = GenerateSingleFrameTexture(obj, frameTime)
            
        end
        
        function frames = TimeToFrames(obj, time)
            frames = time * obj.hardwareParameters.theoreticalRefreshRate;
        end
        
        function time = FramesToTime(obj, frames)
            time = frames / obj.hardwareParameters.theoreticalRefreshRate;
        end
        
        function CompileResults(obj)
            disp('implement CompileResults!');
        end
        
        function tf = ToContinueCycling(obj)
            tf = obj.continueCycling;
        end
        
        function StopCycling(obj)
            obj.continueCycling = false;
        end
    end
end