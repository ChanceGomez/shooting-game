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
    self.defaultFont = perfect_dos_16 or love.graphics.newFont()
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
    local text = nil                -- Contains the text that is wanted to be rendered
    local font = self.defaultFont   -- Is the font that is used to draw
    local x,y = 0,0                 -- Position for the text
    local limit = 1000              -- How far the text can go in the x pos
    local defaultColor = {1,1,1,1}  -- default color to revert to if no change

    --Check to see if text == tble
    --If table is true then get all the variables needed and if missing then return 
    --With exception of x,y 
    if type(arg1) == "table" then
        if arg1.text then
            text = arg1.text
        else
            text = ""
        end
        
        if arg1.font then
            font = arg1.font or font
        end

        if arg1.x then
            x = arg1.x or x
        end

        if arg1.y then
            y = arg1.y or y
        end

        if arg1.limit then
            limit = arg1.limit or limit
        end

        if arg1.defaultColor then
            defaultColor = arg1.defaultColor or defaultColor
        end

    --if arg1 is not a table then assume it is choosing each arg individually
    else
        text = arg1 or ""
        font = arg2 or self.defaultFont
        x = arg3 or x
        y = arg4 or y
        limit = arg5 or limit
        defaultColor = arg6 or defaultColor
    end
    
    --Divide up the text into words seperated by whitespace
    for word in string.gmatch(text, "%S+") do
        --wrapper to insert into words
        local wrapper = {
            word = "",
            color = {1,1,1,1},
        }
        --boolean to tell system if it is inside a delimiter
        local isWord = true

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
            if isWord then
                wrapper.word = wrapper.word .. letter
            end

            --Check to see if letter is a comma (,) if so then no longer in decimal
            if letter == "," then
                endDecimal()
            end

            --Check to see if left delimiter if so then switch isWord to let system know
            if letter == "}" then
                endDecimal()
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
        local word = word.word

        --check to see if word will go over limit
        if textX - x + font:getWidth(word) > limit then
            Return()
        end

        --print the word
        love.graphics.setColor(color)
        love.graphics.setFont(font)
        love.graphics.print(word,textX,textY)

        --Increase the x position based on previous addition
        textX = textX + font:getWidth(word .. ' ')

        --Check to see if crossed limit
        if textX - x > limit then
           Return()
        end
    end
end


return customtext