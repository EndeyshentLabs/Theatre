# Theatre

Easy to use minimalistic state switcher library for LOVE2D where every state is
represented by a file.

## Usage

1. Get the `theatre.lua` file
2. Create a directory for states
3.

```lua
-- main.lua
Theatre = require("theatre")
OldPrint = print

function love.load()
    Theatre:setupLogger(OldPrint)

    -- states/   - dir for states
    -- mainmenu  - first state (will be states/mainmenu.lua)
    Theatre:new("states", "mainmenu")
end

function love.update(dt)
    Theatre:update(dt)
end

function love.draw()
    Theatre:draw()
end

-- LOVE2D Callback. See bottom of `theatre.lua` for a list
function love.keypressed(...)
    Theatre:keypressed(...)
end
```

```lua
-- states/mainmenu.lua
local M = {}

function M.draw()
    love.graphics.print("Main Menu", 100, 100)
end

function M.keypressed(k, sc)
    if sc == "space" then
        Theatre:switch("game")
    end
end
```

```lua
-- states/game.lua
local M = {}

function M.draw()
    love.graphics.print("epik gameplay", 100, 100)
end

function M.keypressed(k, sc)
    if sc == "p" then
        Theatre:switch("mainmenu")
    end
end
```

## Documentation

TBD. (you can read the code for now)
