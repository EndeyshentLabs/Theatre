local M = {}

function M.start()
    print("Entering imaginable pause menu")
end

function M.draw()
    love.graphics.setColor(0, 1, 0)
    love.graphics.print("Imagine pause menu here", 200, 200)
end

function M.keypressed(k, sc)
    if sc == "p" then
        Th:pop()
    end
end

return M
