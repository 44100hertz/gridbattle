local src_image = require 'src/image'

local image = {}

function image:init (path, disable_flip)
   self.image = src_image('battle/actors/' .. path)
   self.disable_flip = disable_flip
end

function image:draw (actor)
   local x, y = actor:screen_pos():unpack()
   local flip = (actor.side==2 and not self.disable_flip)
--   local scale_mult = draw_shadow and 0.3 or 0.2
   local scale_mult = 0.2
   self.image.scale = point(1,1) * (1.0 + scale_mult * actor.z)
   self.image:draw(x, y, flip)
end

return image
