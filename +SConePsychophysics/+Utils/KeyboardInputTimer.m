% This class implements a simple timer that determines if a specified
% interval of time has passed.  It is used to know when to check the
% keyboard for input.
%
% Create a timer with some interval 'someInterval':
%   myTimer = SConePsychophysics.Utils.KeyboardTimer(someInterval);
%
% Determine if interval has passed and keyboard should be checked (this 
% returns true or false):
%   tf = myTimer.ToCheckKeyboard();
%
% Reset the timer to repeat this cycle:
%   myTimer.Reset();

classdef KeyboardInputTimer < handle
    properties (Access = private)
        startTime
        minimumCheckInterval
    end
    
    methods
        function obj = KeyboardInputTimer(minimumCheckInterval)
            obj.minimumCheckInterval = minimumCheckInterval;
            obj.startTime = tic;
        end
        
        function tf = ToCheckKeyboard(obj)
            tf = toc(obj.startTime) >= obj.minimumCheckInterval;
        end
        
        function Reset(obj)
           obj.startTime = tic; 
        end
    end
end