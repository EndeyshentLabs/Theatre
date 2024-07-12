local M = {}
M.__index = M

function M.start()
    print("Entering imaginable game")
end

function M.pause()
    print("Pausing game...")
end

function M.resume()
    print("Resumed the game!")
end

function M.draw()
    love.graphics.setColor(1, 0, 0)
    love.graphics.print("Imagine game here", 100, 100)
end

function M.keypressed(k, sc)
    if sc == "p" then
        Th:push("pause")
    end
end

return M
