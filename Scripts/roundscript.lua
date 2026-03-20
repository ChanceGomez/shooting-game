--[[
    Author: Chance Francisco Gomez | chance.f.gomez@gmail.com
    File: roundscript.lua

    ---------------------------------------------------------------

    How it works:
        This file is a datapoint to plan & change how the rounds should go.
        For example in the roundscript there is 'easy', 'medium', 'hard' in each of 
        these subcategories there can exist a different amount of enemies and difficulty scaling

        {5,3} = 5 enemies, level 3 difficulty
]]

local roundscript = {
    easy = {
        [1] = {5,1},
        [2] = {8,1},
        [3] = {10,1},
        [4] = {10,2},
        [5] = {20,3},
        [6] = {10,4},
        [7] = {15,4},
        [8] = {5,6},
        [9] = {8,6},

    }
}

function roundscript:getData(round,difficulty)
    local difficulty = difficulty or 'easy'
    local data = self[difficulty]

    local enemies = 9000
    local difficulty = 5

    if data[round] then
        enemies = data[round][1]
        difficulty = data[round][2]
    end

    return enemies,difficulty
end


return roundscript