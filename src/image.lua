local imgdb = require(PATHS.imgdb)
local imgpath = _G.RES_PATH .. '/img/'

image = {}
image.__index = image

function image:draw(x, y, flip, frame)
   local xscale = (self.xscale or 1) * (self.scale or 1)
   local yscale = (self.yscale or 1) * (self.scale or 1)

   if not frame then
      local dt = love.timer.getTime() - self.start_time
      local elapsed = 1 + math.ceil(dt * (self.current.fps) - 1) % #self.current.anim
      frame = self.current.anim[elapsed]
   end

   local ox = self.current.ox * (xscale or 1)
   local oy = self.current.oy * (yscale or 1)
   x = flip and x + ox or x - ox
   y = y - oy
   local sx = flip and -xscale or xscale
   local quad = self.current.quads[frame]
   love.graphics.draw(self.img, quad, x, y, 0, sx, yscale)
end

function image:set_sheet(name)
   self.current = self.sheets[name]
   self.start_time = love.timer.getTime()
end

function image:get_interruptible()
   if self.current.fps==0 then return true end

   local dt = love.timer.getTime() - self.start_time
   return math.floor(dt * self.current.fps) >= self.current.iasa
end

function image:get_over()
   if self.current.fps==0 then return false end

   local dt = love.timer.getTime() - self.start_time
   return math.floor(dt * self.current.fps) >= self.current.len
end

-- Read animation data and generate quads
function image.make_quads(root_x, y, w, h, numx, numy, iw, ih)
   root_x = root_x or 0
   y = y or 0
   w = w or iw
   h = h or ih
   numx = numx or 1
   numy = numy or 1

   local quads = {}
   local index = 1
   for _ = 1,numy do
      local x = root_x
      for _ = 1,numx do
         quads[index] = love.graphics.newQuad(x, y, w, h, iw, ih)
         x = x + w
         index = index + 1
      end
      y = y + h
   end
   return quads
end

-- path is not optional, sheet_name is just for when many images share a sheet
function image.new(path, sheet_name)
   local self = {}
   setmetatable(self, image)

   sheet_name = sheet_name or path
   self.img = love.graphics.newImage(imgpath .. sheet_name .. '.png')
   self.iw, self.ih = self.img:getDimensions()

   local sheetdata = imgdb[sheet_name]
   if not sheetdata then
      print('warning: sheet not found: ', sheet_name)
      sheetdata = {base={}}
   end

   self.name = sheet_name
   self.sheets = {}
   for k,v in pairs(sheetdata) do
      self.sheets[k] = v
      local sheet = self.sheets[k]
      sheet.quads = image.make_quads(
         v.x, v.y, v.w, v.h,
         v.numx, v.numy, self.iw, self.ih
      )
      sheet.ox = sheet.ox or 0
      sheet.oy = sheet.oy or 0
      sheet.fps = sheet.fps or 0
      sheet.anim = sheet.anim or {1}
      sheet.len = sheet.len or #sheet.anim
      sheet.iasa = sheet.iasa or sheet.len
      sheet.name = k
   end

   if self.sheets.base then self:set_sheet('base') end

   return self
end

return image
