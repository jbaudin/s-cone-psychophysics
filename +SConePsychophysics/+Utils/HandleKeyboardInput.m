% This function interprets a key code and updates a cylcer accordingly.
%
% inputs:
%       keyCode: a string code for the pressed key
%       cycler: Cycler object to modify based on the key that was pushed
%
% key behaviors:
%       left arrow: decrements cycler
%       right arrow: increments cycler
%       space: stops cycler cycling (and effectively submits results)

function HandleKeyboardInput(keyCode, cycler)
keyName = KbName(keyCode);
switch keyName
    case 'LeftArrow'
        cycler.DecrementOffset();
    case 'RightArrow'
        cycler.IncrementOffset();
    case 'space'
        cycler.StopCycling();
end
end