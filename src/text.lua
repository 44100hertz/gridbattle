-- Functions for drawing ascii-grid fonts

local fonts = {}

local getfont = function (font)
   if not fonts[font] then
      img = love.graphics.newImage("res/fonts/" .. font .. ".png")
      fonts[font] = {
         img=img,
         quads = {},
         char_w = img:getWidth() / 16,
         char_h = img:getHeight() / 8,
         sb = love.graphics.newSpriteBatch(img, 256, "stream"),
      }
   end
   return fonts[font]
end

local getletter = function (f, char)
   c = string.byte(char)
   if not f.quads[c] then
      f.quads[c] = love.graphics.newQuad(
         c%16*f.char_w, math.floor(c/16)*f.char_h,
         f.char_w, f.char_h,
         f.img:getWidth(), f.img:getHeight()
      )
   end
   return f.quads[c]
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

local draw = function (font, lines, ox, oy, layout)
   if type(lines) == "string" then lines = {lines} end

   local f = getfont(font)
   f.sb:clear()
   local x,y = ox,oy
   for _,line in ipairs(lines) do
      if layout=="right" then x = ox - getsize(font, line) end
      if layout=="center" then x = ox - getsize(font, line)/2 end
      for char in line:gmatch(".") do
         f.sb:add(getletter(f, char), x, y)
         x = x+f.char_w
      end
      x,y = ox, y+f.char_h
   end
   love.graphics.draw(f.sb)
end

return {
   getsize = getsize,
   draw = draw,
}
