local rev = require 'rev_lib'

local agent = {}

deep = 5

---[[ 97.1, 2.5
wterm = 100
wcor = 10
--]]
--[[ 94.8, 4.4
wterm = 50
wcor = 10
--]]
--[[ 96.8, 2.2
wterm = 100
wcor = 20
--]]
--[[ 95.9, 3.7
wterm = 100
wcor = 5
--]]
--[[ 96.5, 3.0
wterm = 100
wcor = 12
--]]


local function heur1(board, sym, isterm)
    my, en = rev.count(board, sym)
    local res = my - en

    if isterm and res > 0 then
        return res + wterm
    elseif isterm and res < 0 then
        return res - wterm
    end

    local cor = board[1][1]
    if cor == sym then
        res = res + wcor
    elseif cor then
        res = res - wcor
    end
    cor = board[8][1]
    if cor == sym then
        res = res + wcor
    elseif cor then
        res = res - wcor
    end
    cor = board[1][8]
    if cor == sym then
        res = res + wcor
    elseif cor then
        res = res - wcor
    end
    cor = board[8][8]
    if cor == sym then
        res = res + wcor
    elseif cor then
        res = res - wcor
    end

    return res
end

local function minmax(board, sym, deep)
    if deep == 0 then
        return heur1(board, sym), nil, nil
    end

    local ensym
    if sym == 'o' then
        ensym = '#'
    else
        ensym = 'o'
    end
    
    local moves = {}
    for i = 1, 8 do
        for j = 1, 8 do
            if board[i][j] == nil and rev.attacking(board, j, i, sym)
                then moves[#moves + 1] = {j, i}
            end
        end
    end
    if #moves == 0 then
        --my, en = rev.count(board, sym)
        return heur1(board, sym, true), nil, nil
    end

    local maxx = moves[1][1]
    local maxy = moves[1][2]
    local copy = rev.deep_copy(board)
    copy[maxy][maxx] = sym
    copy = rev.swap_checks(copy, maxx, maxy, sym)
    local maxv = -minmax(copy, ensym, deep - 1)
    moves[1][3] = maxv
    for i = 2, #moves do
        local x = moves[i][1]
        local y = moves[i][2]
        copy = rev.deep_copy(board)
        copy[y][x] = sym
        copy = rev.swap_checks(copy, x, y, sym)
        local v = -minmax(copy, ensym, deep - 1)
        moves[i][3] = v
        if v > maxv then
            maxv = v
            maxx = x
            maxy = y
        end
    end
    return maxv, maxx, maxy
end


function agent.player(symbol, board)
    _, x, y = minmax(board, symbol, deep)
    return x, y
end


return agent
