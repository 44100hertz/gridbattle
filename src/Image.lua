local imgdb = require(PATHS.imgdb)
local imgpath = _G.RES_PATH .. "/img/"

Image = {}
function Image:draw(x,y)
   love.graphics.draw(self.img, x,y)
end
Image.__index = Image

SheetImage = {}
function SheetImage:draw(x, y, index)
   love.graphics.draw(self.img, self.quads[index], x-anim.ox, y-anim.oy)
end
SheetImage.__index = SheetImage

MultiSheetImage = {}
function MultiSheetImage:draw(x, y, index, anim_name)
   love.graphics.draw(self.img, self.quads[anim_name][index], x-anim.ox, y-anim.oy)
end
MultiSheetImage.__index = MultiSheetImage

-- Read animation data and generate quads
local function read_anim(sheet, iw, ih, anim_name)
   if anim_name == "base" then return end -- Hack: name "base" is for defaults
   local quads = {}

   local anim = sheet[anim_name] or {}
   local base = sheet.base
   local root_x = anim.x or base.x or 0
   local y      = anim.y or base.y or 0
   local numx = anim.numx or base.numx or 1
   local numy = anim.numy or base.numy or 1
   local w = anim.w or base.w or error("No width for animation ", anim_name)
   local h = anim.h or base.h or error("No height for animation ", anim_name)

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
   quads.ox = anim.ox or base.ox or 0
   quads.oy = anim.oy or base.oy or 0
   return quads
end

-- path is not optional, sheet_name is just for when many images share a sheet
function Image.new(path, sheet_name)
   self = {}
   sheet_name = sheet_name or path
   self.sheet = imgdb[sheet_name]
   self.img = love.graphics.newImage(imgpath .. sheet_name .. ".png")
   local iw, ih = self.img:getDimensions()

   if not self.sheet then
      setmetatable(self, Image)
      return self
   end

   setmetatable(self, SheetImage)
   self.quads = {}
   for k,v in pairs(self.sheet) do
      self.quads[k] = read_anim(self.sheet, iw, ih, k)
   end
   return self
end

return Image
