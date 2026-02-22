local roundscript = {
    easy = {
        [1] = {5,1},
        [2] = {8,1},
        [3] = {10,1},
        [4] = {10,2},
        [5] = {20,2},

    }
}

function roundscript:getData(round)
    local difficulty = 'easy'
    local data = self[difficulty]

    local enemies = 4
    local difficulty = 4

    if data[round] then
        enemies = data[round][1]
        difficulty = data[round][2]
    end

    return enemies,difficulty
end


return roundscript