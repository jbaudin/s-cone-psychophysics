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