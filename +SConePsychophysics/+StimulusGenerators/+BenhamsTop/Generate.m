function output = Generate(stimulusParameters, hardwareParameters, varargin)
ip = inputParser();
ip.addOptional('ReturnOnlyFrameData', false, @(x) islogical(x)); % a flag for debugging
ip.parse(varargin{:});

% needs to return a map, indexed by offset, of 3d arrays for frames

% figure out constraints on offset step sizes
maxOffsetStepNum = floor(stimulusParameters.maxOffset / stimulusParameters.offsetStepSize);
minOffsetStepNum = ceil(stimulusParameters.minOffset / stimulusParameters.offsetStepSize);

% make an array of offsets (these will be the containers.Map keys)
offsetSteps = (minOffsetStepNum:maxOffsetStepNum);

% multiply that array by the step size to get an array of offset sizes
offsetSizes = offsetSteps * stimulusParameters.offsetStepSize;

% make a cell array that will store all of the frames
frames = cell(1, numel(offsetSizes));

% calculate the frames for each offset
for fr = 1:numel(offsetSizes)
   frames{fr} = GenerateFrame(stimulusParameters, offsetSizes(fr));
end

% place the offsetSteps and associated frames into a containers.Map object
% which will allow the frames to be looked up by providing an offsetSize
output = containers.Map(num2cell(offsetSteps), frames);

% default will be to return a cycler, but if for the sake of visualizing
% the frames, you only want the frameData, call the function with the
% optional arguments: (..., 'ReturnOnlyFrameData', true)
if ~ip.Results.ReturnOnlyFrameData
    output = SConePsychophysics.Cyclers.Spinner(hardwareParameters, stimulusParameters, output);
end

    % this function generates a single frame at the specified offset
    function frame = GenerateFrame(stimulusParameters, offsetSize)
        % generate two matrices, one for all of the x-values and one for
        % all of the y-values in a grid with size 2 * radius + 1 and a
        % center of 0
        [xValues, yValues] = meshgrid(-stimulusParameters.radius:stimulusParameters.radius, ...
            -stimulusParameters.radius:stimulusParameters.radius);
        
        % using the x and y value grids, and the Pythagorean theorem,
        % calculate a matrix of radii over that same grid; also normalize
        % the values between 0 and 1 (this will make specifying arc
        % positions easier later on)
        radii = (((xValues .^ 2) + (yValues .^ 2)) .^ (1 / 2)) / stimulusParameters.radius;
        
        % calculate thetas for the same grid of x and y values (this will
        % help us define arc positions later on)
        thetas = atan2(yValues, xValues);
        
        % create an array that will serve as eventual frame; initializing
        % it now as all zeros will help speed things up because it will
        % tell MATLAB now how big it will be and allow MATLAB to allocate
        % enough space in memory; it will be a 3d array, with the first two
        % dimensions being heigh and width, and the final dimension making
        % it so there will be a matrix for each color channel (RGB)
        frameSideLength = 2 * stimulusParameters.radius + 1; 
        frame = zeros(frameSideLength, frameSideLength, 3);
        
        % now, generate the actual Benham's top design; this will be done
        % twice, once for the red and green frames (which will be
        % identical) and once for the blue frame
        % start by precomputing some values that will be of use as we
        % construct the design; first, the increment between the start
        % points of two neighboring arcs (this will be the width of the
        % arcs plus the distance between them)
        arcRadiusIncrement = stimulusParameters.arcThickness +  stimulusParameters.arcMargin;
        % next, half of the width of an arc
        halfArcWidth = stimulusParameters.arcThickness / 2;
        
        % now, make the two frames, but beforehand, put the two possible
        % offsets (one for R & G, which will be 0, and the other for B,
        % which will vary) into a vector so that we can use them in the
        % loop
        thetaOffsets = [0 offsetSize];
        for i = 1:2
            % initialize the frame (a 2d matrix that will eventually be
            % placed into the 3d matrix we intialized above); initialize
            % all of the values to be the background value
            currFrame = stimulusParameters.backgroundIntensity * ones(frameSideLength, frameSideLength);
            
            % add a hemidisk to the current frame; to figure out which
            % pixels are in region of the hemidisk, we will construct a
            % couple logical matrices (meaning that the values will all be
            % true or false) based on a couple criteria; we will then use
            % these matrices to specify which of the values within
            % currFrame fall within the hemidisk
            
            % first logical matrix, true if values are on bottom half of
            % the image, false otherwise (we need the mod becuase sometimes
            % the offset will push values past 2*pi)
            isOnBottom = mod(thetas + thetaOffsets(i), 2 * pi) > pi;
            
            % the next logical matrix, true if the values fall within the
            % radius (i.e., we have a square matrix of values, make all of
            % the values that fall within the biggest circle that can fit
            % within that square true, and those outside the circle false)
            isWithinCircle = radii <= 1;
            
            % now combine our 2 logical matrices into a final one that only
            % has true values where both of the other matrices had true
            % values (so, inside the circle and on the bottom half)
            isWithinHemidisk = isOnBottom & isWithinCircle;
            
            % now, use that logical matrix to specify which of the values
            % in our current frame to set to have the intensity of "dark"
            currFrame(isWithinHemidisk) = stimulusParameters.darkIntensity;
            
            % now add the arcs; we will start by making a counter so that
            % we can keep track of which arc we are on
            arcCounter = 0;
            
            % arcs will be added in groups (the number of groups specified
            % in stimulusParameters.numArcGroups); the number of arcs per
            % group will be specified in stimulusParameters.numArcsInGroups;
            % this will loop through each arc and add them
            for j = 1:stimulusParameters.numArcGroups
                for k = 1:stimulusParameters.numArcsInGroups(j)
                    % determine the radius of this given arc (this radius
                    % will specify the distance from the center of the
                    % frame of the center of the width of the arc)
                    currArcRadius = stimulusParameters.startArcRadius + arcCounter * arcRadiusIncrement;
                    
                    % again, make a logical matrix with true values for
                    % those elements within this arc
                    % start with a matrix determining if elements are
                    % within the specified angle range for this arc group
                    isWithinAngleRange = IsAngleBetween(thetas + thetaOffsets(i), ...
                        stimulusParameters.arcGroupThetas{j}(1), stimulusParameters.arcGroupThetas{j}(2));
                    % the second logical matrix will be true when the
                    % radius falls within the specified width of the arc
                    % (or radius +/- halfWidth)
                    isWithinArcWidth = (radii > currArcRadius - halfArcWidth) & (radii < currArcRadius + halfArcWidth);
                    % combine these into a matrix that will only be true
                    % for values within the angle range and the radius
                    isWithinArc = isWithinAngleRange & isWithinArcWidth;
                    
                    % use this logical matrix to specify which values of
                    % the currFrame to make dark
                    currFrame(isWithinArc) = stimulusParameters.darkIntensity;
                    
                    % increment the arcCounter so that the next radius will
                    % be bigger by arcRadiusIncrement
                    arcCounter = arcCounter + 1;
                end
            end
            
            % if we are on the first pass through this loop (when i is 1),
            % add the generated frame to our 3d frame in the red and green
            % channels, if it is the second pass, add it to the blue
            % channel
            if i == 1
                frame(:, :, 1) = currFrame;
                frame(:, :, 2) = currFrame;
            else
                frame(:, :, 3) = currFrame;
            end
        end
    end

    % this function returns a logical matrix where those values of theta
    % between angleLower and angleUpper are true, and the rest are false
    function tf = IsAngleBetween(theta, angleLower, angleUpper)
        theta = mod(theta, 2 * pi);
        tf = (theta >= angleLower & theta <= angleUpper) ...
            | (theta >= angleLower + 2 * pi & theta <= angleUpper + 2 * pi);
    end
end