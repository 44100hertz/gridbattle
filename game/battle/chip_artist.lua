local oop = require 'src/oop'
local lg = love.graphics

local chip_artist = oop.class()

-- Chip graphics are fixed size at 256x256
-- this enables quads to be computed once only
local icon_quad, art_quad
do
   local w,h = 256,256
   icon_quad = lg.newQuad(0,0,16,16,w,h)
   art_quad = lg.newQuad(0,16,64,72,w,h)
end

function chip_artist:init ()
   self.images = {}
end

function chip_artist:get_image (name)
   if not self.images[name] then
      local imgpath = 'chips/' .. name .. '.png'
      self.images[name] = lg.newImage(imgpath)
   end
   return self.images[name]
end

function chip_artist:draw_icon (name, pos)
   local img = self:get_image(name)
   lg.draw(img, icon_quad, pos:unpack())
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
   lg.draw(img, art_quad, pos:unpack())
end

return chip_artist
