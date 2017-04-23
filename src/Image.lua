local imgdb = require(PATHS.imgdb)
local imgpath = _G.RES_PATH .. "/img/"

Image = {}
Image.__index = Image

function Image:draw(x, y, flip, frame)
   if not frame then
      local dt = love.timer.getTime() - self.start_time
      local frames_passed = dt * ((self.current.fps-1) % #self.current.anim)+1
      frame = self.current.anim[frames_passed]
   end
   x = flip and x - self.iw or x
   sx = flip and -1 or 1
   local quad = self.current.quads[frame]
   love.graphics.draw(self.img, quad, x-self.current.ox, y-self.current.oy)
end

function Image:set_sheet(name)
   self.current = self.sheets[name]
   self.start_time = love.timer.getTime()
end

function Image:get_interruptible()
   if not self.current.fps then return true end
end

function Image:get_over()
   if not self.current.fps then return false end
end

-- Read animation data and generate quads
local function make_quads(root_x, y, w, h, numx, numy, iw, ih)
   root_x = root_x or 0
   y = y or 0
   w = w or iw
   h = h or ih
   numx = numx or 1
   numy = numy or 1

   local quads = {}
   local index = 1
   for _ = 1,numx do
      local x = root_x
      for _ = 1,numy do
         quads[index] = love.graphics.newQuad(x, y, w, h, iw, ih)
         x = x + w
         index = index + 1
      end
      y = y + h
      index = index + 1
   end
   return quads
end

-- path is not optional, sheet_name is just for when many images share a sheet
function Image.new(path, sheet_name)
   self = {}
   setmetatable(self, Image)

   sheet_name = sheet_name or path
   self.img = love.graphics.newImage(imgpath .. sheet_name .. ".png")
   self.iw, self.ih = self.img:getDimensions()

   assert(imgdb[sheet_name], "That's the wrong sheet: " .. sheet_name)

   self.sheets = {}
   for k,v in pairs(imgdb[sheet_name]) do
      self.sheets[k] = v
      local sheet = self.sheets[k]
      sheet.quads = make_quads(v.x, v.y, w, h, numx, numy, self.iw, self.ih)
      sheet.ox = sheet.ox or 0
      sheet.oy = sheet.oy or 0
      sheet.fps = sheet.fps or 0
      sheet.anim = sheet.anim or {1}
   end

   if self.sheets.base then self:set_sheet("base") end

   return self
end

return Image
