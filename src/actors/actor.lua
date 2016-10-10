--[[
### actor ###
A set of extensible, common actor functions
to be included LOCALLY in actor/ classes

### functionality ##
init():
   initialize ALL module state
   do instead of just putting things in the package header

update():
   calls a module function, so should not be extended
   ideally is a clean state machine

draw():
   draw.
   TODO: make draw return a canvas or custom type, for z-buffer
--]]

o = {}

-- Start or re-start an actor without reloading its module
function o.init()
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
end

-- A hopefully clean way to run an actor state machine
function o.update()
   o.state()
   o.state_timer = o.state_timer + o.speed
end

-- Generic draw function, will be replaced
function o.draw()
   love.graphics.draw(o.img, o.frame, o.pos.x, o.pos.y,
		      0, 1, 1, o.origin.x, o.origin.y)
end

function o.cooldown()
   if o.state_timer > 10 then
      return o.idle_init()
   end      
end

return o
