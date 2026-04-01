local controls = {
    mouse_lastClicked = 0,

    keyboardClicked = false,
    keyboard_lastClicked = '',

    modifierClicked = false,
    typeableClicked = false,
    numberClicked = false,

    last_typable = '',
    last_number = '',
    last_modifier = '',
	
	dragging = false,
	dragStartX, dragStartY,
	camStartX, camStartY,
}

CursorX,CursorY = 0,0



function controls:update()
    local scale = Scale or 1
    --Cursor
    CursorX,CursorY = love.mouse.getPosition()
    CursorX = CursorX/scale
    CursorY = CursorY/scale

    CursorX = math.ceil(CursorX)
    CursorY = math.ceil(CursorY)

    -- alphabet
    aClick = false
    bClick = false
    cClick = false
    dClick = false
    eClick = false
    fClick = false
    gClick = false
    hClick = false
    iClick = false
    jClick = false
    kClick = false
    lClick = false
    mClick = false
    nClick = false
    oClick = false
    pClick = false
    qClick = false
    rClick = false
    sClick = false
    tClick = false
    uClick = false
    vClick = false
    wClick = false
    xClick = false
    yClick = false
    zClick = false

    --wheel
    wheelUp = false
    wheelDown = false
	
    --control keys
    escapeClick = false

	--arrow keys
	up 		= false
	down 	= false
	left 	= false
	right 	= false

    -- numbers
    oneClick = false
    twoClick = false
    threeClick = false
    fourClick = false
    fiveClick = false
    sixClick = false
    sevenClick = false
    eightClick = false
    nineClick = false
    zeroClick = false

    -- mouse
    leftClick = false
    rightClick = false

    -- general flags
    controls.keyboardClicked = false
    controls.modifierClicked = false
    controls.typeableClicked = false
    controls.numberClicked = false
end

function love.keypressed(key)
    controls.keyboardClicked = true
    controls.keyboard_lastClicked = key

    if key == "a" then aClick = true; controls.typeableClicked = true; controls.last_typable = "a"
    elseif key == "b" then bClick = true; controls.typeableClicked = true; controls.last_typable = "b"
    elseif key == "c" then cClick = true; controls.typeableClicked = true; controls.last_typable = "c"
    elseif key == "d" then dClick = true; controls.typeableClicked = true; controls.last_typable = "d"
    elseif key == "e" then eClick = true; controls.typeableClicked = true; controls.last_typable = "e"
    elseif key == "f" then fClick = true; controls.typeableClicked = true; controls.last_typable = "f"
    elseif key == "g" then gClick = true; controls.typeableClicked = true; controls.last_typable = "g"
    elseif key == "h" then hClick = true; controls.typeableClicked = true; controls.last_typable = "h"
    elseif key == "i" then iClick = true; controls.typeableClicked = true; controls.last_typable = "i"
    elseif key == "j" then jClick = true; controls.typeableClicked = true; controls.last_typable = "j"
    elseif key == "k" then kClick = true; controls.typeableClicked = true; controls.last_typable = "k"
    elseif key == "l" then lClick = true; controls.typeableClicked = true; controls.last_typable = "l"
    elseif key == "m" then mClick = true; controls.typeableClicked = true; controls.last_typable = "m"
    elseif key == "n" then nClick = true; controls.typeableClicked = true; controls.last_typable = "n"
    elseif key == "o" then oClick = true; controls.typeableClicked = true; controls.last_typable = "o"
    elseif key == "p" then pClick = true; controls.typeableClicked = true; controls.last_typable = "p"
    elseif key == "q" then qClick = true; controls.typeableClicked = true; controls.last_typable = "q"
    elseif key == "r" then rClick = true; controls.typeableClicked = true; controls.last_typable = "r"
    elseif key == "s" then sClick = true; controls.typeableClicked = true; controls.last_typable = "s"
    elseif key == "t" then tClick = true; controls.typeableClicked = true; controls.last_typable = "t"
    elseif key == "u" then uClick = true; controls.typeableClicked = true; controls.last_typable = "u"
    elseif key == "v" then vClick = true; controls.typeableClicked = true; controls.last_typable = "v"
    elseif key == "w" then wClick = true; controls.typeableClicked = true; controls.last_typable = "w"
    elseif key == "x" then xClick = true; controls.typeableClicked = true; controls.last_typable = "x"
    elseif key == "y" then yClick = true; controls.typeableClicked = true; controls.last_typable = "y"
    elseif key == "z" then zClick = true; controls.typeableClicked = true; controls.last_typable = "z"

    elseif key == "escape" then escapeClick = true; controls.typeableClicked = false;


    elseif key == "1" then oneClick = true; controls.numberClicked = true; controls.last_number = "1"
    elseif key == "2" then twoClick = true; controls.numberClicked = true; controls.last_number = "2"
    elseif key == "3" then threeClick = true; controls.numberClicked = true; controls.last_number = "3"
    elseif key == "4" then fourClick = true; controls.numberClicked = true; controls.last_number = "4"
    elseif key == "5" then fiveClick = true; controls.numberClicked = true; controls.last_number = "5"
    elseif key == "6" then sixClick = true; controls.numberClicked = true; controls.last_number = "6"
    elseif key == "7" then sevenClick = true; controls.numberClicked = true; controls.last_number = "7"
    elseif key == "8" then eightClick = true; controls.numberClicked = true; controls.last_number = "8"
    elseif key == "9" then nineClick = true; controls.numberClicked = true; controls.last_number = "9"
    elseif key == "0" then zeroClick = true; controls.numberClicked = true; controls.last_number = "0"
    elseif key == "up" then up = true;
    elseif key == "down" then down = true;
    elseif key == "left" then left = true;
    elseif key == "right" then right = true;
    end
end


function love.mousepressed(x, y, button)
    controls.keyboardClicked = true
    controls.mouse_lastClicked = button

        


    if button == 1 then
        leftClick = true
        leftHeld = true
    elseif button == 2 then
        rightClick = true
    end
	
	
	if button == 3 then  -- middle mouse button
--        controls.dragging = true
--        controls.dragStartX, controls.dragStartY = x, y
--        controls.camStartX, controls.camStartY = camera.x, camera.y
    end
end

function love.wheelmoved(x,y)
    if y > 0 then
        wheelUp = true
    elseif y < 0 then
        wheelDown = true
    end
end

function love.focus(focused)
    if not focused then
        leftHeld = false
    end
end

function love.mousereleased(x,y,button)
        

    if button == 1 then
        leftHeld = false
    end
	if button == 3 then
		controls.dragging = false
	end
end

return controls
