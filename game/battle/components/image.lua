local src_image = require 'src/image'

local image = {}

function image:init (actor, path, sheet)
   self.actor = actor
   self.image = src_image('battle/actors/' .. actor.class .. '/' .. path .. '.png', sheet)
   self.disable_flip = disable_flip
end

function image:draw ()
   local x, y = self.actor:screen_pos():unpack()
   local flip = (self.actor.side==2 and not self.disable_flip)
--   local scale_mult = draw_shadow and 0.3 or 0.2

   self.image.scale = point(1,1) * self.actor:depth_scale()
   love.graphics.setColor(1,1,1, math.min(1, 1.0 - self.actor.z / 4))
   self.image:draw(x, y, flip)
end

return image
