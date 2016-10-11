--[[ Actor
A set of extensible, common Actor functions
to be included LOCALLY in Actor/ classes
--]]

Actor = {}

-- Start or re-start an Actor without reloading its module
-- initialize ALL module state
-- do this instead of just putting things in the package header
function Actor:new(space, side, speed)
   -- Make this a class
   o = {}
   setmetatable(o, self)
   self.__index = self
   
   -- init values
   self.space = space or {x=2,y=2} -- Actor starting position
   self.side  = side  or "left"    -- Actor starting stage side
   self.speed = speed or 1         -- State speed
   
   -- init actions
   stage.occupy(self.space)         -- Create collision on space
   self.pos = stage.pos(self.space) -- Find the actual coords for drawing

   -- Temporary hack to make drawing work. Everyone is Ben!
   self.img = love.graphics.newImage("img/ben.png")
   self.frames = sheet.generate({x=50, y=60}, {x=1, y=5}, self.img:getDimensions())
   self.origin = {x=25, y=57}

   -- Init state machine
   self.state = self.init
   self.state_timer = 0

   return o
end

-- Assumed that this is done before each draw
function Actor:update(dt)
   self:state()
   self.state_timer = self.state_timer + self.speed*60*dt
end

-- Generic draw function, will be replaced
function Actor:draw()
   love.graphics.draw(self.img, self.frame, self.pos.x, self.pos.y,
		      0, 1, 1, self.origin.x, self.origin.y)
end

-- For the end of animations; will be replaced
function Actor:cooldown()
   if self.state_timer > 10 then
      return self:init()
   end
end

-- Placeholder function; do nothing!
function Actor:init() end

return Actor
