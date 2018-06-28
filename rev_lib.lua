local rev = {}

function rev.board_tostr(board) --do printowania
    local res = {}
    for i = 1, 8 do
        local r = {}
        for j = 1, 8 do
            if board[i][j] == nil then
                r[#r+1] = '.'
            else r[#r+1] = board[i][j]
            end
        end
        r[#r+1] = '\n'
        res[#res + 1] = table.concat(r)
    end
    return table.concat(res)
end

function rev.make_free_board()
    local board = {}
    for i = 1, 8 do
        board[i] = {}
    end
    return board
end    

function rev.make_board() --tworzenie planszy
    local board = rev.make_free_board()
    board[4][4] = '#'
    board[4][5] = 'o'
    board[5][4] = 'o'
    board[5][5] = '#'
    return board
end


function rev.deep_copy(board)    --deep copy obrazka
    local copy = {}
    for i = 1, 8 do
        local new = {}
        local old = board[i]
        for j = 1, 8 do
            new[j] = old[j]
        end
        copy[i] = new
    end
    return copy
end

function rev.attacking(board, x, y, sym)
    if board[y][x] ~= nil then
        return false
    end
    local i = y
    local j = x
    local ensym
    if sym == 'o' then
        ensym = '#'
    else
        ensym = 'o'
    end
    if i + 1 <= 8 and board[i + 1][j] == ensym then
        local i1 = i + 2                            --dół
        while i1 <= 8 and board[i1][j] == ensym do
            i1 = i1 + 1
        end
        if i1 <= 8 and board[i1][j] == sym then
            return true
        end
    end
    if i - 1 >= 1 and board[i - 1][j] == ensym then
        local i1 = i - 2                            --góra
        while i1 >= 1 and board[i1][j] == ensym do
            i1 = i1 - 1
        end
        if i1 >= 1 and board[i1][j] == sym then
            return true
        end
    end
    if board[i][j + 1] == ensym then
        local j1 = j + 2                            --prawo
        while board[i][j1] == ensym do
            j1 = j1 + 1
        end
        if board[i][j1] == sym then
            return true
        end
    end
    if board[i][j - 1] == ensym then
        local j1 = j - 2                            --lewo
        while board[i][j1] == ensym do
            j1 = j1 - 1
        end
        if board[i][j1] == sym then
            return true
        end
    end
    if i + 1 <= 8 and board[i+1][j+1] == ensym then
        local i1 = i + 2                            --dół-prawo
        local j1 = j + 2
        while i1 <= 8 and board[i1][j1] == ensym do
            i1 = i1 + 1
            j1 = j1 + 1
        end
        if i1 <= 8 and board[i1][j1] == sym then
            return true
        end
    end
    if i - 1 >= 1 and board[i-1][j+1] == ensym then
        local i1 = i - 2                            --góra-prawo
        local j1 = j + 2
        while i1 >= 1 and board[i1][j1] == ensym do
            i1 = i1 - 1
            j1 = j1 + 1
        end
        if i1 >= 1 and board[i1][j1] == sym then
            return true
        end
    end
    if i + 1 <= 8 and board[i+1][j-1] == ensym then
        local i1 = i + 2                            --dół-lewo
        local j1 = j - 2
        while i1 <= 8 and board[i1][j1] == ensym do
            i1 = i1 + 1
            j1 = j1 - 1
        end
        if i1 <= 8 and board[i1][j1] == sym then
            return true
        end
    end
    if i - 1 >= 1 and board[i-1][j-1] == ensym then
        local i1 = i - 2                            --góra-lewo
        local j1 = j - 2
        while i1 >= 1 and board[i1][j1] == ensym do
            i1 = i1 - 1
            j1 = j1 - 1
        end
        if i1 >= 1 and board[i1][j1] == sym then
            return true
        end
    end
    return false
end

function rev.swap_checks(board, x, y, sym)    --'zbijanie'
    --print(x, y, sym)
    local i = y
    local j = x
    local ensym
    if sym == 'o' then
        ensym = '#'
    else
        ensym = 'o'
    end
    if board[i][j] == sym then
        local i1 = i + 1            --dół
        while i1 <= 8 and board[i1][j] == ensym do
            i1 = i1 + 1
        end
        if i1 <= 8 and board[i1][j] == sym then
            i1 = i1 - 1
            while i1 ~= i do
                board[i1][j] = sym
                i1 = i1 - 1
            end
        end
        local i1 = i - 1            --góra
        while i1 >= 1 and board[i1][j] == ensym do
            i1 = i1 - 1
        end
        if i1 >= 1 and board[i1][j] == sym then
            i1 = i1 + 1
            while i1 ~= i do
                board[i1][j] = sym
                i1 = i1 + 1
            end
        end
        local j1 = j + 1            --prawo
        while board[i][j1] == ensym do
            j1 = j1 + 1
        end
        if board[i][j1] == sym then
            j1 = j1 - 1
            while j1 ~= j do
                board[i][j1] = sym
                j1 = j1 - 1
            end
        end
        local j1 = j - 1            --lewo
        while board[i][j1] == ensym do
            j1 = j1 - 1
        end
        if board[i][j1] == sym then
            j1 = j1 + 1
            while j1 ~= j do
                board[i][j1] = sym
                j1 = j1 + 1
            end
        end 
        local i1 = i + 1            --dół-prawo
        local j1 = j + 1
        while i1 <= 8 and board[i1][j1] == ensym do
            i1 = i1 + 1
            j1 = j1 + 1
        end
        if i1 <= 8 and board[i1][j1] == sym then
            i1 = i1 - 1
            j1 = j1 - 1
            while j1 ~= j do
                board[i1][j1] = sym
                i1 = i1 - 1
                j1 = j1 - 1
            end
        end
        local i1 = i - 1            --góra-prawo
        local j1 = j + 1
        while i1 >= 1 and board[i1][j1] == ensym do
            i1 = i1 - 1
            j1 = j1 + 1
        end
        if i1 >= 1 and board[i1][j1] == sym then
            i1 = i1 + 1
            j1 = j1 - 1
            while j1 ~= j do
                board[i1][j1] = sym
                i1 = i1 + 1
                j1 = j1 - 1
            end
        end
        local i1 = i + 1            --dół-lewo
        local j1 = j - 1
        while i1 <= 8 and board[i1][j1] == ensym do
            i1 = i1 + 1
            j1 = j1 - 1
        end
        if i1 <= 8 and board[i1][j1] == sym then
            i1 = i1 - 1
            j1 = j1 + 1
            while j1 ~= j do
                board[i1][j1] = sym
                i1 = i1 - 1
                j1 = j1 + 1
            end
        end
        local i1 = i - 1            --góra-lewo
        local j1 = j - 1
        while i1 >= 1 and board[i1][j1] == ensym do
            i1 = i1 - 1
            j1 = j1 - 1
        end
        if i1 >= 1 and board[i1][j1] == sym then
            i1 = i1 + 1
            j1 = j1 + 1
            while j1 ~= j do
                board[i1][j1] = sym
                i1 = i1 + 1
                j1 = j1 + 1
            end
        end
    end
    return board
end

function rev.move_good(board, x, y, sym)
                                    --true gdy ruch jest dozwolony
    if x < 1 or x > 8 then
        return
    end
    if y < 1 or y > 8 then
        return
    end
    if board[y][x] == nil and rev.attacking(board, x, y, sym) then
        return true
    end
end

function rev.poss_move(board, sym)      --true gdy istnieje ruch 
    local free = {}
    for i = 1, 8 do
        for j = 1, 8 do
            if board[i][j] == nil then
                free[#free + 1] = {j, i}
            end
        end
    end
    local x
    local y
    for i = 1, #free do
        x, y = free[i][1], free[i][2]
        if rev.attacking(board, x, y, sym) then
            return true
        end
    end
    return false
end

function rev.white_win(board)
    local white = 0
    local black = 0
    for i = 1, 8 do
        for j = 1, 8 do
            if board[i][j] == 'o' then
                white = white + 1
            elseif board[i][j] == '#' then
                black = black + 1
            end
        end
    end
    if white > black then
        return true
    elseif black > white then
        return false
    end
end

function rev.count(board, sym)
    local my = 0
    local en = 0
    for i = 1, 8 do
        for j = 1, 8 do
            if board[i][j] == sym then
                my = my + 1
            elseif board[i][j] then
                en = en + 1
            end
        end
    end
    return my, en
end


return rev
