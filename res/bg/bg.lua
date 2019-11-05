local oop = require 'src/oop'

local bg = {}

function bg.new (kind, bgimage)
   assert(kind == 'scroll')
   local self = oop.instance(bg, {})
   self.start_time = love.timer.getTime()
   self.image = love.graphics.newImage(PATHS.bg .. bgimage .. '.png')
   self.image:setWrap('repeat', 'repeat')
   self.bg_size = self.image:getDimensions()
   self.bg_quad = love.graphics.newQuad(
      0, 0, GAME.width+self.bg_size, GAME.height+self.bg_size,
      self.bg_size, self.bg_size
   )
   return self
end

function bg:draw ()
   local offset = love.timer.getTime() - self.start_time
   local bgoff_y = offset*30 % self.bg_size - self.bg_size
   local bgoff_x = (offset + math.sin(offset))*30 % self.bg_size - self.bg_size
   love.graphics.draw(self.image, self.bg_quad, bgoff_x, bgoff_y)
end

return bg
