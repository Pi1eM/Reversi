local rev = require('rev_lib')
local randp = require('rand').player

local agent = {}

math.randomseed(os.clock() * 4523456)

local games = 500

local function play(p1, p2, board, sym)   
                                --rozgrywka(wywołuje ai(sym, board))
    local player
    local i = 1
    if sym == '#' then
        i = 2
    end
    while true do
        if i % 2 == 1 then
            symbol = '#'
            player = p1
        else
            symbol = 'o'
            player = p2
        end
        x, y = player(symbol, board)
        if x ~= nil and rev.move_good(board, x, y, symbol) then
            board[y][x] = symbol
            rev.swap_checks(board, x, y, symbol)
        elseif x == nil and rev.poss_move(board, symbol) ~= true then
            break
        else
            return
        end
        i = i + 1
    end
    local winner = rev.white_win(board)
    return winner
end


function agent.player(sym, board)
    local moves = {}
    for i = 1, 8 do
        for j = 1, 8 do
            if board[i][j]==nil and rev.attacking(board,j,i,sym) then
                moves[#moves + 1] = {j, i}
            end
        end
    end
    if #moves == 0 then
        return
    end

    local gpm = games / #moves
    local win
    local copy
    local x
    local y
    for i = 1, #moves do
        local num = 0
        for j = 1, gpm do
            copy = rev.deep_copy(board)
            x, y = moves[i][1], moves[i][2]
            copy[y][x] = sym
            rev.swap_checks(copy, x, y, sym)
            win = play(randp, randp, copy, sym)
            if win then
                num = num + 1
            elseif win == false then
                num = num - 1
            end
        end
        if sym == '#' then
            num = -num
        end
        moves[i][3] = num
    end

    local best = moves[1]
    for i = 2, #moves do
        if moves[i][3] > best[3] then
            best = moves[i]
        end
    end

    return best[1], best[2]
end


return agent
