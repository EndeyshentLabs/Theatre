local function logStr(format, ...)
    return "[THEATRE:" .. debug.getinfo(2, "n").name .. "] " .. string.format(format, ...)
end

local Theatre = {}
Theatre.__index = Theatre

---@type table<string, Theatre.State>
Theatre.states = {}

---@type string
Theatre.previous = ""

---@type string
Theatre.current = ""

---@type table<string>
Theatre.stack = {}

---Initializes Theatre gamestate library
---@param dir string Directory of gamestate files
---@param startState? string Initial gamestate
function Theatre:new(dir, startState)
    assert(love.filesystem.getInfo(dir) ~= nil, logStr("Directory '%s' doesn't exists!", dir))
    local files = love.filesystem.getDirectoryItems(dir)
    if #files < 1 then
        io.stderr:write(logStr("WARNING: No gamestates found in '%s'", dir))
        return
    end

    for _, v in pairs(files) do
        if string.sub(v, #v - 3) == ".lua" then
            local name = string.sub(v, 0, #v - 4)
            ---@type boolean, Theatre.State
            local err, state = pcall(require, dir .. "." .. name)
            if not err then
                error(logStr("Couldn't load gamestate '%s':\n%s", name, state))
            end

            state.__visited = false
            self.states[name] = state
        end
    end

    if startState then
        self.stack[1] = startState
        self:switch(startState)
    end
end

function Theatre:setupLogger(oldprint)
    self.oldprint = oldprint
    _G.print = self.print
end

function Theatre.print(msg, ...)
    Theatre.oldprint("[" .. Theatre.current .. "] " .. string.format(msg, ...))
end

function Theatre:switch(stateName, ...)
    assert(self.states[stateName], logStr("State '%s' doesn't exists!", stateName))

    self:exit()

    self.previous = self.current
    self.current = stateName
    self.stack[#self.stack] = self.current

    if not self.states[stateName].__visited then
        self:init()
    end
    self:start(self.previous, ...)
end

function Theatre:push(stateName, ...)
    assert(self.states[stateName], logStr("State '%s' doesn't exists!", stateName))

    self:pause()

    self.current = stateName
    self.stack[#self.stack + 1] = self.current

    if not self.states[stateName].__visited then
        self:init()
    end
    self:start(self.stack[#self.stack - 1], ...)
end

function Theatre:pop(...)
    self:exit()

    self.stack[#self.stack] = nil
    self.current = self.stack[#self.stack]

    self:resume(...)
end

local function safeCall(fName, ...)
    if Theatre.states[Theatre.current] and Theatre.states[Theatre.current][fName] then
        Theatre.states[Theatre.current][fName](...)
    end
end

-- Callbacks {{{

---@private
function Theatre:init(...)
    safeCall("init", ...)
end

---@private
function Theatre:start(previous, ...)
    safeCall("start", previous, ...)
end

---@private
function Theatre:pause(...)
    safeCall("pause", ...)
end

---@private
function Theatre:resume(...)
    safeCall("resume", ...)
end

---@private
function Theatre:exit(...)
    safeCall("exit", ...)
end

---@param dt number
function Theatre:update(dt)
    safeCall("update", dt)
end

function Theatre:draw()
    safeCall("draw")
end

function Theatre:keypressed(...)
    safeCall("keypressed", ...)
end

function Theatre:keyreleased(...)
    safeCall("keyreleased", ...)
end

function Theatre:textedited(...)
    safeCall("textedited", ...)
end

function Theatre:textinput(...)
    safeCall("textinput", ...)
end

function Theatre:directorydropped(...)
    safeCall("directorydropped", ...)
end

function Theatre:displayrotated(...)
    safeCall("displayrotated", ...)
end

function Theatre:filedropped(...)
    safeCall("filedropped", ...)
end

function Theatre:focus(...)
    safeCall("focus", ...)
end

function Theatre:mousefocus(...)
    safeCall("mousefocus", ...)
end

function Theatre:resize(...)
    safeCall("resize", ...)
end

function Theatre:visible(...)
    safeCall("visible", ...)
end

function Theatre:mousemoved(...)
    safeCall("mousemoved", ...)
end

function Theatre:mousepressed(...)
    safeCall("mousepressed", ...)
end

function Theatre:mousereleased(...)
    safeCall("mousereleased", ...)
end

function Theatre:wheelmoved(...)
    safeCall("wheelmoved", ...)
end

function Theatre:gamepadaxis(...)
    safeCall("gamepadaxis", ...)
end

function Theatre:gamepadpressed(...)
    safeCall("gamepadpressed", ...)
end

function Theatre:gamepadreleased(...)
    safeCall("gamepadreleased", ...)
end

function Theatre:joystickadded(...)
    safeCall("joystickadded", ...)
end

function Theatre:joystickaxis(...)
    safeCall("joystickaxis", ...)
end

function Theatre:joystickhat(...)
    safeCall("joystickhat", ...)
end

function Theatre:joystickpressed(...)
    safeCall("joystickpressed", ...)
end

function Theatre:joystickreleased(...)
    safeCall("joystickreleased", ...)
end

function Theatre:joystickremoved(...)
    safeCall("joystickremoved", ...)
end

function Theatre:touchmoved(...)
    safeCall("touchmoved", ...)
end

function Theatre:touchpressed(...)
    safeCall("touchpressed", ...)
end

function Theatre:touchreleased(...)
    safeCall("touchreleased", ...)
end

--}}}

return Theatre -- NOTE: Maybe use `setmetatable({}, Theatre)`

---Gamestate
---See [Love2D Callbacks](https://love2d.org/wiki/love#Callbacks)
---@class Theatre.State
---@field __visited        boolean (PRIVATE)
---@field init             function Fires ONLY ON FIRST switch to this gamestate
---@field start            function Fires ON EVERY switch to this gamestate
---@field pause            function Fires when pushing from this gamestate
---@field resume           function Fires when poping to this gamestate
---@field exit             function Fires ON EVERY switch from this gamestate
---@field update           function Love2D callback
---@field draw             function Love2D callback
---@field keypressed       function Love2D callback
---@field keyreleased      function Love2D callback
---@field textedited       function Love2D callback
---@field textinput        function Love2D callback
---@field directorydropped function Love2D callback
---@field displayrotated   function Love2D callback
---@field filedropped      function Love2D callback
---@field focus            function Love2D callback
---@field mousefocus       function Love2D callback
---@field resize           function Love2D callback
---@field visible          function Love2D callback
---@field mousemoved       function Love2D callback
---@field mousepressed     function Love2D callback
---@field mousereleased    function Love2D callback
---@field wheelmoved       function Love2D callback
---@field gamepadaxis      function Love2D callback
---@field gamepadpressed   function Love2D callback
---@field gamepadreleased  function Love2D callback
---@field joystickadded    function Love2D callback
---@field joystickaxis     function Love2D callback
---@field joystickhat      function Love2D callback
---@field joystickpressed  function Love2D callback
---@field joystickreleased function Love2D callback
---@field joystickremoved  function Love2D callback
---@field touchmoved       function Love2D callback
---@field touchpressed     function Love2D callback
---@field touchreleased    function Love2D callback

-- vim:set fen fdm=marker:
