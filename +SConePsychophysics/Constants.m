% This is where constants for the psychophysics experiments are defined.
% Place things here if they will span multiple functions/classes/etc.  
% To access one of these values from another function, use the following:
%       SConePsychophysics.Constants.___VARIABLE_NAME_HERE___

classdef Constants
    properties (Constant)
        % Controls the maximum amount of time the stimulus will be
        % displayed
        MAX_RUNTIME = 60 % in seconds
        
        % Controls amount of time between checks for keystrokes during
        % experiments
        KEYBOARD_CHECK_INTERVAL = 0.25 % in seconds
        
        % Controls the default background value for the window; this can be
        % overridden when a PsychtoolboxSession is created by providing the
        % optional argument, ..., 'BackgroundIntensity', newIntensity, ...
        % newIntensity can also be a 3 element vector specifying RGB values
        BACKGROUND_INTENSITY = 0 % 0 - 1 scale
        
        % For convenience, stimuli can be specified in color spaces other
        % than RGB.  For now, those other spaces are limited to being
        % related by a linear transformation.  These transformations are 
        % defined here as 3 by 3 matrices such that:
        %   stim_rgb = matrix * stim_other_space
        % Each color space also needs a string to identify it.  The naming
        % conventions for these are as follows (for some space called something):
        %   string identifier: COLOR_SPACE_SOMETHING
        %   transform matrix: SOMETHING_TO_RGB
        % To add a new stimulus transformation, specify these two
        % constants, and add them to the COLOR_SPACE_PROJECTION_MATRICES
        % map (see below).
        
        % For specifying the stimulus in RGB space, in this case,
        % the transformation matrix is the identity matrix.
        COLOR_SPACE_RGB = 'rgb';
        RGB_TO_RGB = [1 0 0; 0 1 0; 0 0 1];
        
        % For specifying the stimulus in LMS (i.e. cone-isolating) space,
        % this matrix will transform from cone isolating space to RGB
        % space.
        COLOR_SPACE_LMS = 'lms';
        LMS_TO_RGB = [0 1 0; 0 0 1; 1 0 0];
        
        % A map from color space string identifiers to projection matrices.
        % It is constructed with a cell array of string identifiers and a
        % cell array of their associated transformation matrices.
        %
        % If one were to add the example color space "something" from
        % above, this would be changed to:
        % COLOR_SPACE_PROJECTION_MATRICES = containers.Map( ...
        %     {SConePsychophysics.Constants.COLOR_SPACE_LMS, ...
        %     SConePsychophysics.Constants.COLOR_SPACE_RGB, ...
        %     SConePsychophysics.Constants.COLOR_SPACE_SOMETHING}, ...
        %     {SConePsychophysics.Constants.LMS_TO_RGB, ...
        %     SConePsychophysics.Constants.RGB_TO_RGB, ...
        %     SConePsychophysics.Constants.SOMETHING_TO_RGB});
        
        COLOR_SPACE_PROJECTION_MATRICES = containers.Map( ...
            {SConePsychophysics.Constants.COLOR_SPACE_LMS, ...
            SConePsychophysics.Constants.COLOR_SPACE_RGB}, ...
            {SConePsychophysics.Constants.LMS_TO_RGB, ...
            SConePsychophysics.Constants.RGB_TO_RGB});
        
        
        % Controls the bounds on the values stimuli can take once they are
        % converted to RGB space.  These are the values that are used by
        % stimulus generators when they check to make sure a given
        % parameter set yields only stimuli within the monitor bounds.  
        MONITOR_SPACE_UPPER_BOUNDS = [1 1 1];
        MONITOR_SPACE_LOWER_BOUNDS = [0 0 0];
    end
end