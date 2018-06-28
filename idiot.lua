local rev = require 'rev_lib'

local agent = {}


function balance(board, x, y, sym)
    local new_board = rev.deep_copy(board)
    new_board[y][x] = sym
    rev.swap_checks(new_board, x, y, sym)
    my, en = rev.count(new_board, sym)
    return my - en
end


function agent.player(symbol, board)
    local free = {}
    for i = 1, 8 do
        for j = 1, 8 do
            if board[i][j] == nil and rev.attacking(board,j,i,symbol)
                then free[#free + 1] = {j, i}
            end
        end
    end
    if #free == 0 then
        return
    end
    local max = balance(board, free[1][1], free[1][2], symbol)
    local imax = 1
    for i = 2, #free do
        local m = balance(board, free[i][1], free[i][2], symbol)
        if m > max then
            max = m
            imax = i
        end
    end
    return free[imax][1], free[imax][2]
end


return agent
