rev = require 'rev_lib'

cpu = {'rand','idiot','novice','basic','standard','flatmc','proto'}

bc = {0.6, 0.5, 0}
wh = {1, 1, 1}
bl = {0, 0, 0}
gr = {0, 1, 0}


function restart()
    if diff_level == nil or diff_level < 1 or diff_level > 7 then
        diff_level = 1
    end
    if human == nil then
        human = 1
        hsym = 'o'
        csym = '#'
    end
    mx = nil
    my = nil
    wwin = nil
    bwin = nil
    turn = 1
    player = require(cpu[diff_level]).player
    board = rev.make_board()
end

function love.load()
    love.window.setTitle('Reversi')
    success = love.window.setMode(700, 650)
    restart()
end

function love.mousereleased(x, y, button, istouch)
    if button == 1 then
        if x > 22 and x < 578 and y > 22 and y < 578 then --plansza
            py = math.floor((y - 22) / 70) + 1
            px = math.floor((x - 22) / 70) + 1
            if move and rev.move_good(board, px, py, hsym) then
                mx = px
                my = py
                board[my][mx] = hsym
                move = false
                rev.swap_checks(board, mx, my, hsym)
                turn = turn + 1
            end
        end
        if x > 600 and y > 50 and y < 600 then  --poziom trudności
            diff_level = math.floor((y - 50) / 70) + 1
            restart()
        end
        if x < 300 and y > 600 and y < 650 then --zmiana koloru
            human = 1 - human
            help = hsym
            hsym = csym
            csym = help
            restart()
        end
        if x > 600 and y > 600 then     --restart
            restart()
        end
    end
end

function love.update(dt)
    if turn % 2 == 1 then
        symbol = 'o'
    else
        symbol = '#'
    end
    if rev.poss_move(board, symbol) == false then
        move = false
        if rev.white_win(board) then
            wwin = true
        elseif rev.white_win(board) == false then
            bwin = true
        end
        return
    end
    if turn % 2 ~= human then
        mx, my = player(csym, board)
        if mx ~= nil and rev.move_good(board, mx, my, csym) then
            board[my][mx] = csym
            rev.swap_checks(board, mx, my, csym)
        else
            if rev.white_win(board) then
                wwin = true
            elseif rev.white_win(board) == false then
                bwin = true
            end
            return
        end
        turn = turn + 1
    else
        move = true
    end
end

function love.draw()
    --plansza
    love.graphics.setColor(unpack(bc))
    love.graphics.rectangle('fill', 10, 10, 580, 580)
    love.graphics.setColor(unpack(bl))
    love.graphics.rectangle('fill', 18, 18, 564, 564)
    love.graphics.setColor(unpack(bc))
    xst = 22
    yst = 22
    y = yst
    size = 66
    jump = 70
    for i = 1, 8 do
        x = xst
        for j = 1, 8 do
            love.graphics.rectangle('fill', x, y, size, size)
            x = x + jump
        end
        y = y + jump
    end

    --podświetlenie ostatniego ruchu
    if mx then
        x1 = xst + (mx - 1) * jump
        y1 = yst + (my - 1) * jump
        love.graphics.setColor(unpack(gr))
        love.graphics.rectangle('fill', x1, y1, size, size)
    end

    --pionki
    x = -15
    y = -15
    r = 30
    jump = 70
    for i = 1, 8 do
        for j = 1, 8 do
            if board[i][j] == 'o' then
                love.graphics.setColor(unpack(wh))
                love.graphics.circle('fill', x+j*jump, y+i*jump, r)
            end
            if board[i][j] == '#' then
                love.graphics.setColor(unpack(bl))
                love.graphics.circle('fill', x+j*jump, y+i*jump, r)
            end
        end
    end

    --poziom trudności
    love.graphics.setColor(unpack(bc))
    love.graphics.print("Easy", 620, 10, nil, 2)
    k = 0
    j = 70
    for i = 1, 7 do
        love.graphics.print(i.."", 640, k + i * j, nil, 3)
    end
    love.graphics.print("Hard", 620, 565, nil, 2)
    k = 45
    love.graphics.line(640, k+diff_level*j, 664, k+diff_level*j)

    --reset
    love.graphics.print("Restart", 600, 610, nil, 2)

    --napisy
    love.graphics.setColor(unpack(bc))
    if human == 1 then
        love.graphics.print("You are white.", 10, 600, nil, 3)
    else
        love.graphics.print("You are black.", 10, 600, nil, 3)
    end        

    if wwin or bwin then
        if wwin then
            love.graphics.print("White wins!", 330, 600, nil, 3)
        else
            love.graphics.print("Black wins!", 330, 600, nil, 3)
        end
    else
        if turn % 2 == 1 then
            love.graphics.print("White turn", 350, 600, nil, 3)
        else
            love.graphics.print("Black turn", 350, 600, nil, 3)
        end
    end
end


