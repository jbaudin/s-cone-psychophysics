function HandleKeyboardInput(keyCode, cycler)
switch keyCode
    case 'LeftArrow'
        cycler.DecrementOffset();
    case 'RightArrow'
        cycler.IncrementOffset();
    case 'Space'
        cycler.StopCycling();
end
end