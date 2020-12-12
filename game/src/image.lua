--[[
   image: A convenient object wrapper around love2d images.
   Generates quads for sprite and tile sheets, performs flipping and animation.
--]]

local oop = require 'src/oop'

local image = oop.class()

-- Static cache of loaded images.
local image_cache

-- Load an image
-- path: where to load the image from, in images/
-- sheets: all relevant sprite sheets for the image
--[[
   Sheet format:
       rect: {x,y,w,h} rectangle use from image (default whole image)
             for sprite/tile sheets, this is the upper-left corner.
       origin: {x, y} center of image; how far to offset when drawing
       count: {columns, rows} how many frames in a sprite/tile sheet
       anim: Animation. These fields are needed:
           fps: <number> framerate of animation
           order: <list> Frame order. 1 is the first frame

   -- The sheet named 'base' will be used by default --
--]]
function image:init (path)
   -- Load sheet data from imgdb into 'point' data types
   self.image = self:get_image(path)
   self.sheets = {}
   sheets = dofile(path .. '.lua')

   for name,data in pairs(sheets) do
      self.sheets[name] = {}
      local sheet = self.sheets[name]
      sheet.origin = data.origin and point(unpack(data.origin)) or point(0,0)
      sheet.scale = data.scale and point(unpack(data.scale)) or point(1,1)
      sheet.anim = data.anim

      local x,y,w,h = unpack(data.rect)
      local count = data.count and point(unpack(data.count)) or point(1,1)
      local image_size = point(self.image:getDimensions())
      sheet.quads = self.make_quads(point(x,y), point(w,h), count, image_size)
   end

   self.scale = point(1,1)

   if self.sheets.base then
      self:set_sheet('base')
   end
end

-- Uses a local/static image cache instead of loading a next texture every time
function image:get_image (path)
   if not image_cache then
      image_cache = {}
      -- Ephemeron table: delete from cache when no other references point to it
      setmetatable(image_cache, {__mode = 'k'})
   end
   if not image_cache[path] then
      image_cache[path] = love.graphics.newImage(path)
   end
   return image_cache[path]
end

-- Sets the current sheet, reset to beginning of animation.
function image:set_sheet (name)
   self.sheet = name
   if not self.sheets[self.sheet] then
      error('sheet ' .. name .. ' not found for ' .. self.name)
   end
   self.animation_start_time = love.timer.getTime()
end

-- Gets the current sheet data, as loaded
function image:sheet_data ()
   if not self.sheet then
      error('forgot to set sheet on image ' .. self.name)
   end
   return self.sheets[self.sheet]
end

-- Draw the current frame of the current sheet. Or, use frame_number to
-- override. flip = true will flip the image horizontally.
function image:draw(x, y, flip, frame_index)
   local data = self:sheet_data()

   if not frame_index then
      if data.anim then
         local time =  love.timer.getTime() - self.animation_start_time
         local frames_elapsed = math.floor(time * data.anim.fps)
         local frames = 1 + (frames_elapsed % #data.anim.order)
         frame_index = data.anim.order[frames]
      else
         frame_index = 1
      end
   end

   local mirror = flip and point(-1, 1) or point(1,1)
   local scale = self.scale * data.scale * mirror
   local origin = data.origin * scale
   local pos = point(x,y) - origin
   local quad = data.quads[frame_index]
   love.graphics.draw(self.image, quad, pos.x, pos.y, 0, scale:unpack())
end

-- Read animation data and generate quads
function image.make_quads(pos, size, count, image_size)
   local quads = {}
   for iy = 1,count.y do
      for ix = 1,count.x do
         local offset = pos + point(ix-1, iy-1) * size
         quads[#quads+1] = love.graphics.newQuad(
            offset.x, offset.y, size.x, size.y, image_size:unpack())
      end
   end
   return quads
end

return image
