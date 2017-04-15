local imgdb = require(PATHS.imgdb)
local imgpath = _G.RES_PATH .. "/img/"

Image = {}
function Image:draw(x, y, _, _, flip)
   x = flip and x - self.iw or x
   sx = flip and -1 or 1
   love.graphics.draw(self.img, x, y, 0, sx, 1)
end
Image.__index = Image

SheetImage = {}
function SheetImage:draw(x, y, index, _, flip)
   x = flip and x - self.iw or x
   sx = flip and -1 or 1
   love.graphics.draw(self.img, self.quads[1], x-self.ox, y-self.oy, 0, sx, 1)
end
SheetImage.__index = SheetImage

MultiSheetImage = {}
function MultiSheetImage:draw(x, y, index, anim_name, flip)
   x = flip and x - self.iw or x
   sx = flip and -1 or 1
   love.graphics.draw(self.img, self.quads[anim_name][index], x-anim.ox, y-anim.oy)
end
MultiSheetImage.__index = MultiSheetImage

-- Read animation data and generate quads
local function make_quads(root_x, y, w, h, numx, numy, iw, ih)
   if anim_name == "base" then return end -- Hack: name "base" is for defaults
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
   sheet_name = sheet_name or path
   self.sheet = imgdb[sheet_name]
   self.img = love.graphics.newImage(imgpath .. sheet_name .. ".png")
   self.iw, self.ih = self.img:getDimensions()

   if not self.sheet then
      setmetatable(self, Image)
      return selfp
   end

   if not self.sheet.base then
      setmetatable(self, SheetImage)
      self.quads = make_quads(
         self.sheet.x or 0, self.sheet.y or 0,
         self.sheet.w, self.sheet.h,
         self.sheet.numx or 1, self.sheet.numy or 1,
         self.iw, self.ih
      )
      self.ox = self.ox or 0
      self.oy = self.oy or 0
      return self
   end

   setmetatable(self, MultiSheetImage)

   self.quads = {}
   local base = self.sheet.base
   for k,v in pairs(self.sheet) do
      if k~= "base" then
         local x = v.x or base.x or 0
         local y = v.y or base.y or 0
         local w = v.w or base.w or error("No width for animation ", anim_name)
         local h = v.h or base.h or error("No height for animation ", anim_name)
         local numx = v.numx or base.numx or 1
         local numy = v.numy or base.numy or 1
         self.quads[k] = make_quads(x, y, w, h, numx, numy, self.iw, self.ih)
         self.quads[k].ox = v.ox or base.ox or 0
         self.quads[k].oy = v.oy or base.oy or 0
      end
   end
   return self
end

return Image
