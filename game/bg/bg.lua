local oop = require 'src/oop'
local point = require 'src/point'

local bg = oop.class()

function bg:init (kind, bgimage)
   assert(kind == 'scroll')
   self.start_time = love.timer.getTime()
   self.image = love.graphics.newImage(PATHS.bg .. bgimage .. '.png')
   self.shader = love.graphics.newShader(PATHS.shaders .. 'background.glsl')
   self.shader:send('texture_size', {self.image:getDimensions()})
   self.shader:send('scale', GAME.config.settings.game_scale * 2.0)
end

function bg:draw ()
   local offset = love.timer.getTime() - self.start_time
   local bgoff = point(offset + math.sin(offset), offset) * 15
   self.shader:send('offset', {bgoff.x, bgoff.y})
   love.graphics.setShader(self.shader)
   love.graphics.draw(self.image, 0,0,0, 100,100)
   love.graphics.setShader()
end

return bg
