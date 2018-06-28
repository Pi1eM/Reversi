local rev = require 'rev_lib'

prog1 = 'human'
prog1 = 'rand'
prog1 = 'idiot'
prog1 = 'novice'
prog1 = 'basic'
prog1 = 'standard'
prog1 = 'flatmc'
prog1 = 'proto'

prog2 = 'idiot'
prog2 = 'basic'
prog2 = 'novice'
prog2 = 'proto'
prog2 = 'human'
prog2 = 'flatmc'
prog2 = 'rand'
prog2 = 'standard'

local p1 = require(prog1).player
local p2 = require(prog2).player
--verbose = true
--my_debug = true
n = 1000

local function play(p1, name1, p2, name2)   
                                --rozgrywka(wywołuje ai(sym, board))
    local board = rev.make_board()
    local symbol
    local player
    if my_debug then
        print(rev.board_tostr(board))
    end
    for i = 1, 60 do
        --[[
        if my_debug then
            io.read()
        end
        --]]
        if i % 2 == 1 then
            symbol = 'o'
            player = p1
        else
            symbol = '#'
            player = p2
        end
        x, y = player(symbol, board)
        if x ~= nil and rev.move_good(board, x, y, symbol) then
            board[y][x] = symbol
            rev.swap_checks(board, x, y, symbol)
        elseif x == nil and rev.poss_move(board, symbol) then
            io.write("illegal move: move is possible\n")
            io.write("player: ", symbol, "\n")
            print(rev.board_tostr(board))
            return
        elseif x == nil then
            break
        else
            io.write("illegal move: ", x, " ", y, "\n")
            io.write("player: ", symbol, "\n")
            print(rev.board_tostr(board))
            return
        end
        if my_debug then
            print(rev.board_tostr(board))
        end
    end
    if verbose then
        io.write(rev.board_tostr(board))
    end
    local winner = rev.white_win(board)
    if verbose then
        if winner then
            io.write('White ('..name1..') wins!\n')
        elseif winner == false then
            io.write('Black ('..name2..') wins!\n')
        else
            io.write('Draw.\n')
        end
    end
    return winner
end

local function test(p1, p2, n)
    local w1 = 0
    local w2 = 0
    local draws = 0
    local winner
    local k = 0
    for i = 1, n do
        if i % 2 == 1 then
            winner = play(p2, prog2, p1, prog1)
        else
            winner = play(p1, prog1, p2, prog2)
        end

        if winner and i % 2 == 1 then
            w1 = w1 + 1
        elseif winner and i % 2 == 0 then
            w2 = w2 + 1
        elseif winner == false and i % 2 == 1 then
            w2 = w2 + 1
        elseif winner == false and i % 2 == 0 then
            w1 = w1 + 1
        else
            draws = draws + 1
        end
        --[[if (100 * i) // n > k then
            k = (100 * i) // n
            io.write(k.." %\n")
        end]]
        if i % 10 == 0 then
            io.write("Gra "..i.."/"..n.."...\n")
        end
    end
    io.write("Wyniki (liczba gier: "..n.."):\n")
    io.write(prog1..": "..w1..", "..(w1/n * 100).."%\n")
    io.write(prog2..": "..w2..", "..(w2/n * 100).."%\n")
    io.write("Remisy: "..draws..", "..(draws/n * 100).."%\n")
    io.write("\n")
end


--play(p1, prog1, p2, prog2)
test(p1, p2, n)






