local rev = require 'rev_lib'

local agent = {}

deep = 2


local function minmax(board, sym, deep)
    if deep == 0 then
        my, en = rev.count(board, sym)
        return my - en, nil, nil
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
        my, en = rev.count(board, sym)
        return my - en, nil, nil
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
