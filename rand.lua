local attacking = require('rev_lib').attacking

local agent = {}

math.randomseed(os.clock() * 4523456)

function agent.player(symbol, board)
    local free = {}
    for i = 1, 8 do
        for j = 1, 8 do
            if board[i][j]==nil and attacking(board,j,i,symbol) then
                free[#free + 1] = {j, i}
            end
        end
    end
    if #free == 0 then
        return
    end
    local r = math.random(#free)
    return free[r][1], free[r][2]
end


return agent
