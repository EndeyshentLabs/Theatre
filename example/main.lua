Th = require("theatre")
OldPrint = print

function love.load()
    Th:setupLogger(OldPrint)
    Th:new("s", "game")
end

function love.draw()
    Th:draw()
end

function love.keypressed(...)
    Th:keypressed(...)
end
