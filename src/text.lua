-- Functions for drawing ascii-grid fonts

local resources = require "src/resources"
local rdr = _G.RDR
local fonts = {}

local getfont = function (font)
   if not fonts[font] then
      local img = resources.getimage(PATHS.fonts .. font .. ".png", "font")
      local _,_,w,h = img:query()
      fonts[font] = {
         img = img,
         char_w = w / 16,
         char_h = h / 8,
      }
   end
   return fonts[font]
end

local getletter = function (f, char)
   local c = string.byte(char)
   return {w=f.char_w, h=f.char_h, x=c%16*f.char_w, y=math.floor(c/16)*f.char_h}
end

local getsize = function (font, lines)
   if type(lines) == "string" then lines = {lines} end

   local maxw = 0
   for _,line in ipairs(lines) do
      maxw = math.max(maxw, line:len())
   end

   local f = getfont(font)
   return maxw*f.char_w, #lines*f.char_h
end

local draw = function (font, lines, ox, oy, layout, color)
   color = color or 0xFFFFFF
   if type(lines) == "string" then lines = {lines} end

   local f = getfont(font)
   f.img:setColorMod(color)
   local x,y = ox,oy
   for _,line in ipairs(lines) do
      if layout=="right" then x = ox - getsize(font, line) end
      if layout=="center" then x = ox - getsize(font, line)/2 end
      for char in line:gmatch(".") do
--         rdr:copy(f.img)
         rdr:copy(f.img, getletter(f, char),
                  {w = f.char_w, h = f.char_h, x=x, y=y})
         x = x+f.char_w
      end
      x,y = ox, y+f.char_h
   end
end

return {
   getsize = getsize,
   draw = draw,
}
