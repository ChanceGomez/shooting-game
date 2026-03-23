--[[
    Author: Chance Francisco Gomez | chance.f.gomez@gmail.com
    File: customtext.lua

    ---------------------------------------------------------------------
    
    How it works: 
        text that is being inputted should be formatted as such
        "{1,1,1,1}Hello my name is {1,0,0,1}Chance"
        the {} is the delimter while the inside info is the color
        
    Features:
        Accepts decimal inputs in the color delimiter
]]


local customtext = {
    yMargin = 4, -- yMargin is the margin between two texts on y level
}

-- Load default font if wanting normal text to have a specific font
function customtext:load()
    self.defaultFont = perfect_dos_16 or love.graphics.newFont() -- Change 'perfect_dos_16' to default font
end


--Function to get the transform the text into a word array
local function getFormattedWords(text,defaultColor)
    local words = {}

    --Divide up the text into words seperated by whitespace
    for word in string.gmatch(text, "%S+") do
        --wrapper to insert into words
        local wrapper = {
            word = "",
            color = {1,1,1,1},
            nextLine = false,
        }
        --boolean to tell system if it is inside a delimiter
        local isWord = true
        local inEscapeSequence = false
        local leavingEscapeSequence = false

        -- Boolean to tell system if current number is a decimal to check for period
        local isDecimal = false
        local currentDecimal = "."

        --Variable to store previous letter
        local previousLetter = ""

        --temp table to get the color inside the delimiter then insert into wrapper.color
        local color = {}
        local function endDecimal()
            --make sure actually in decimal
            if isDecimal then
                isDecimal = false
            else
                return
            end
            --Turn decimal into real number
            local currentDecimal = tonumber(currentDecimal)
            --make sure it is a valid decimal
            if currentDecimal == nil then return end
            --insert into color table
            table.insert(color,currentDecimal)
        end
        --Go through each letter of the word
        for letter in word:gmatch(".") do
            leavingEscapeSequence = false
            --Check to see if character has a '/'
            if letter == "/" then
                inEscapeSequence = true
            end

            --Check to see if in an escape sequence
            if inEscapeSequence and letter ~= "/" then
                if letter == 'n' then
                    wrapper.nextLine = true
                end

                --Leave escape sequence
                inEscapeSequence = false
                leavingEscapeSequence = true
            end
            --Check to see if delimter if true then switch isWord to false so that no letters are added
            if letter == "{" then
                isWord = false
            --Check to see if inside delimiter and is on a number value
            elseif letter ~= "}" and letter ~= "," and isWord == false then
                if letter == "." then
                    isDecimal = true
                    if previousLetter ~= "," then
                        table.remove(color,#color)
                    end
                end
                --Check to see if inside a decimal but make sure its not the decimal
                if isDecimal and letter ~= "." then
                    
                    currentDecimal = currentDecimal .. letter
                end
                
                --Make sure not inside a decimal
                if not isDecimal then
                    local colorValue = tonumber(letter)
                    if colorValue < 0 and colorValue > 1 then
                        colorValue = defaultColor[#color]
                    end
                    table.insert(color,colorValue)
                end
            end

            --if outside delimiter then add the letter to the word
            if isWord and not inEscapeSequence and not leavingEscapeSequence then
                wrapper.word = wrapper.word .. letter
            end

            --Check to see if letter is a comma (,) if so then no longer in decimal
            if letter == "," then
                endDecimal()
                currentDecimal = '.'
            end

            --Check to see if left delimiter if so then switch isWord to let system know
            if letter == "}" then
                endDecimal()
                currentDecimal = '.'
                isWord = true
            end

            --Set previous letter
            previousLetter = letter
        end

        --Make sure color is valid
        if #color ~= 4 then
            --if only 3 color values add default alpha of 1
            if #color == 3 then
                table.insert(color,1)

            --if less then or more then 3 just set to default color
            else
                color = defaultColor
            end
        end

        --add the color to the wrapper
        wrapper.color = color

        --add wrapper to words
        table.insert(words, wrapper)
    end
    return words
end

local function argumentHandler(self,arg1,arg2,arg3,arg4,arg5,arg6)
    local text = arg1 or ""
    local font = arg2 or self.defaultFont
    local x = arg3 or 0
    local y = arg4 or 0
    local limit = arg5 or 1000
    local defaultColor = arg6 or {1,1,1,1}

    if type(arg1) == "table" then
        text = arg1.text or text
        font = arg1.font or font
        x = arg1.x or x
        y = arg1.y or y
        limit = arg1.limit or limit
        defaultColor = arg1.defaultColor or defaultColor
    end

    return text,font,x,y,limit,defaultColor
end

--Gets the dimensions that a text will be
function customtext:getDimensions(arg1,arg2,arg3,arg4,arg5,arg6)
    local words = {} -- Contains all the words that will be rendered to screen

    -- Send arguments through the handler to get nils out
    local text,font,x,y,limit,defaultColor = argumentHandler(self,arg1,arg2,arg3,arg4,arg5,arg6)

    --[[
        Logic
    ]]

    local width = 0
    local height = font:getHeight() -- get the initial height
    
    --Get the formatted words into an array
    words = getFormattedWords(text,defaultColor)
   

    local function Return()
        width = 0
        height = height + font:getHeight() + self.yMargin
    end
    
    --loop through to get width & height
    for i, word in ipairs(words) do
        local text = word.word

        if word.nextLine then
            Return()
        end

        if width + font:getWidth(text) > limit then
            Return()
        end
        width = width + font:getWidth(text .. ' ')
        
        if width > limit then
            Return()
        end
    end

    return limit,height
end

--[[
    arg1: text or (table containing rest of data)
    arg2: font
    arg3: x
    arg4: y
    arg5: max length (limit)
    arg6: default color (the default color when there is not a designated change in color)
]]
function customtext:draw(arg1,arg2,arg3,arg4,arg5,arg6)
    local words = {}                -- Contains all the words that will be rendered to screen

    -- Send arguments through the handler to get nils out
    local text,font,x,y,limit,defaultColor = argumentHandler(self,arg1,arg2,arg3,arg4,arg5,arg6)

    -- Get the text into a formatted array
    words = getFormattedWords(text,defaultColor)

    --Draw all the words
    local textX,textY = x,y
    --function to return x to default position but adding to the y level
    local function Return()
        textX = x
        textY = textY + font:getHeight() + self.yMargin
    end

    --Cycle through all the words to print them in the correct order
    for i, word in ipairs(words) do
        local color = word.color
        local text = word.word


        if word.nextLine then
            Return()
        end

        --check to see if word will go over limit
        if textX - x + font:getWidth(text) > limit then
            Return()
        end

        --print the text
        love.graphics.setColor(color)
        love.graphics.setFont(font)
        love.graphics.print(text,textX,textY)

        --Increase the x position based on previous addition
        textX = textX + font:getWidth(text .. ' ')

        --Check to see if crossed limit
        if textX - x > limit then
           Return()
        end
    end
end


return customtext