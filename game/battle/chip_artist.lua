local oop = require 'src/oop'

local chip_artist = oop.class()

function chip_artist:init ()
   -- Chip graphics are fixed size at 256x256
   -- this enables quads to be computed once only
   local w,h = 256,256
   self.icon_quad = love.graphics.newQuad(0,0,16,16,w,h)
   self.art_quad = love.graphics.newQuad(0,16,64,72,w,h)
   self.images = {}
end

function chip_artist:get_image (name)
   if not self.images[name] then
      local imgpath = 'chips/' .. name .. '.png'
      self.images[name] = love.graphics.newImage(imgpath)
   end
   return self.images[name]
end

function chip_artist:draw_icon (name, pos)
   local img = self:get_image(name)
   love.graphics.draw(img, self.icon_quad, pos:unpack())
end

function chip_artist:draw_icon_queue (queue, pos)
   pos = pos - #queue - 8
   for i=#queue,1,-1 do
      self:draw_icon(queue[i].name, pos)
      pos = pos + 2
   end
end

function chip_artist:draw_art (name, pos)
   local img = self:get_image(name)
   love.graphics.draw(img, self.art_quad, pos:unpack())
end

return chip_artist
