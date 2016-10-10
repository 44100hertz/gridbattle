--[[
### stage_actor ###
 - A set of extensible actor functions
 - stores and runs all actors
 - ALL actor data and functions are exposed here, do nottouch
 - that data is not exposed to the rest of the game

### in-module functionality ##
idle():
   required function for when nothing is going on

init():
   initialize ALL module state
   extends the current init
   do instead of just putting things in the package header

update():
   calls a module function, so should not be extended
   ideally is a clean state machine

draw():
   replaces the current draw function
   TODO: make draw return a canvas or custom type, for z-buffer

--]]

local actors = {} -- A PRIVATE numbered list of all active actors
stage_actor = {} -- The returned class; should be automatic

actors[1] = require "actors/player" -- For testing

-- Start or re-start an actor without reloading its module
local function init(o)
   -- init values
   o.space = o.space or {x=2, y=2} -- Actor starting position
   o.side = o.side or "left"       -- Actor starting stage side
   o.speed = o.speed or 1          -- State speed
   
   -- init calculations
   stage.occupy(o.space)           -- Create collision on space
   o.pos = stage.pos(o.space)      -- Find the actual coords for drawing

   -- Temporary hack to make drawing work. Everyone is Ben!
   o.img = love.graphics.newImage("img/ben.png")
   o.frames = sheet.generate({x=50, y=60}, {x=1, y=5}, o.img:getDimensions())
   o.origin = {x=25, y=57}

   -- Require an idle state
   o.state = o.idle_init
   o.state_timer = 0

   if(o.init) then o.init() end -- do anything in the module
end

-- A hopefully clean way to run an actor state machine
local function update(o)
   o.state()
   o.state_timer = o.state_timer + o.speed
end

-- Generic draw function, will be replaced
local function draw(o)
   love.graphics.draw(o.img, o.frame, o.pos.x, o.pos.y,
		      0, 1, 1, o.origin.x, o.origin.y)
end

-- Everything doers for namespace management, etc.
function stage_actor.init()
   for o,_ in ipairs(actors) do init(actors[o]) end
end

function stage_actor.update()
   for o,_ in ipairs(actors) do update(actors[o]) end
end

function stage_actor.draw()
   for o,_ in ipairs(actors) do draw(actors[o]) end
end

return stage_actor
