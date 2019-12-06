local oop = require 'src/oop'

local bg = oop.class()

function bg:init (kind, bgimage)
   assert(kind == 'scroll')
   self.start_time = love.timer.getTime()
   self.image = love.graphics.newImage(PATHS.bg .. bgimage .. '.png')
   self.image:setWrap('repeat', 'repeat')
   self.bg_size = self.image:getDimensions()
   self.bg_quad = love.graphics.newQuad(
      0, 0, GAME.size.x+self.bg_size, GAME.size.y+self.bg_size,
      self.bg_size, self.bg_size
   )
end

function bg:draw ()
   local offset = love.timer.getTime() - self.start_time
   local bgoff_y = offset*30 % self.bg_size - self.bg_size
   local bgoff_x = (offset + math.sin(offset))*30 % self.bg_size - self.bg_size
   love.graphics.draw(self.image, self.bg_quad, bgoff_x, bgoff_y)
end

return bg
