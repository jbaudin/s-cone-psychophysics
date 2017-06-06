% A superclass for cycler objects.  A cycler is an object that manages the
% presentation of some stimulus in which a subject will cycle through
% different 'offsets' (defined differently depending on the specific
% stimulus).  Upon the writing of this, there are two subclasses of Cycler
% (Oscillator and Spinner) that implement this for different types of
% stimuli.  This superclass will contain methods that will be of use for
% all cyclers, as well as define some Abstract methods (i.e., not defined
% here, but subclasses are required to define them).

classdef Cycler < handle
    properties
        % hadware parameters object describing current setup
        hardwareParameters
        % stimulus parameters used to create stimulus currently being
        % displayed
        stimulusParameters
        % the components of the stimulus to be cycled through; this will be
        % a matlab containers.Map object that will have its keys be offsets
        % and its values be something useful for generating the frame for
        % that given offset (exactly what the values will be will vary from
        % stimulus to stimulus because the offsets mean different things
        % for different stimuli)
        stimulusComponents
    end
    
    properties (Access = protected)
        % the current offset (effectively the current state) of the cycler
        currOffset
        % the maximum allowed offset
        offsetMin
        % the minimum allowed offset
        offsetMax
        
        % a boolean value specifying whether cycling should continue (or
        % whether or not the experiment should stop)
        continueCycling
        
        % a function handle to the function that will draw a texture to be
        % displayed (varies based on whether or not stimulus is being drawn
        % in quadrants or not)
        drawTextureFxn
    end
    
    methods (Abstract)
        % these methods must be defined in subclasses
        DrawInQuadrants(obj, frameNum)
        DrawEntireScreen(obj, frameNum)
        CompileResults(obj)
    end
    
    methods
        function obj = Cycler(hardwareParameters, stimulusParameters, stimulusComponents)
            % create the cylcer object, and add values to its properties
            obj.hardwareParameters = hardwareParameters;
            obj.stimulusComponents = stimulusComponents;
            obj.stimulusParameters = stimulusParameters;
            
            % initialize the current offset to 0 and calculate the bounds
            % on the offsets (based on things specified in the stimlulus
            % parameters)
            obj.currOffset = 0;
            obj.offsetMax = floor(stimulusParameters.maxOffset / stimulusParameters.offsetStepSize);
            obj.offsetMin = ceil(stimulusParameters.minOffset / stimulusParameters.offsetStepSize);
            
            % initialize the continue cyling boolean to true
            obj.continueCycling = true;
            
            % set the drawTextureFxn - this will vary based on whether or
            % not the stimulus is rendered in quadrants; these two
            % methods it will choose between the the two abstract methods
            % that all subclasses must implement
            if obj.hardwareParameters.renderInQuadrants
                obj.drawTextureFxn = @(frameNum) obj.DrawInQuadrants(frameNum);
            else
                obj.drawTextureFxn = @(frameNum) obj.DrawEntireScreen(frameNum);
            end
        end
        
        function rect = DetermineStimulusRectangle(obj)
            rect = SConePsychophysics.Utils.GetStimulusRectangle(obj.stimulusParameters);
        end    
        
        function IncrementOffset(obj)
            % increment the offset, up to some max offset, if at the max
            % offset, beep
            if obj.currOffset == obj.offsetMax
                SConePsychophysics.Utils.PlayThreeBeeps();
            end
            
            obj.currOffset = min(obj.currOffset + 1, obj.offsetMax);
        end
        
        function DecrementOffset(obj)
            % decrement the offset, up to some min offset, if at the min
            % offset, beep
            if obj.currOffset == obj.offsetMin
                SConePsychophysics.Utils.PlayThreeBeeps();
            end
            
            obj.currOffset = max(obj.currOffset - 1, obj.offsetMin);
        end
        
        function DisplayFrame(obj, frameNumber)
            % call the appropriate draw texture method (defined in
            % constructor)
            obj.drawTextureFxn(obj.FramesToTime(frameNumber));
            
            % flip the image from the buffer to the front (i.e., display
            % the texture that was just created)
            Screen('Flip', obj.hardwareParameters.window);
        end
        
        function frameTimes = CalculateQuadrantFrameTimes(obj, frameTime)
            % calculates the frame times for all of the frames when
            % displaying in quadrants (these will be offset by 1/4 of the
            % frame period)
            frameTimes = frameTime + ((0:3) / 4) * obj.hardwareParameters.theoreticalFrameDuration;
        end
        
        function frames = TimeToFrames(obj, time)
            % convert a given time to a frame number (not necessarily an
            % integer frame number)
            frames = time * obj.hardwareParameters.theoreticalRefreshRate;
        end
        
        function time = FramesToTime(obj, frames)
            % convert a frame number to a time in seconds
            time = frames / obj.hardwareParameters.theoreticalRefreshRate;
        end
        
        function tf = ToContinueCycling(obj)
            % return a boolean for whether or not to continue cycling
            tf = obj.continueCycling;
        end
        
        function StopCycling(obj)
            % a method that causes the cyclers continueCycling value to be
            % changed to false
            obj.continueCycling = false;
        end
    end
end