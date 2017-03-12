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

local getsize = function (font, text)
   local f = getfont(font)
   local w, maxw = 0,0
   local h = 0
   for char in text:gmatch(".") do
      if char=="\n" then
         w = 0
         h = h + 1
      else
         w = w + 1
         maxw = math.max(w, maxw)
      end
   end
   return maxw*f.char_w, math.max(1,h)*f.char_h
end

local draw = function (font, text, ox, oy, layout)
   if layout=="right" then
      ox = ox - getsize(font, text)
   elseif layout=="center" then
      ox = ox - getsize(font, text) / 2
   end

   local f = getfont(font)
   f.sb:clear()
   local x,y = ox,oy
   for char in text:gmatch(".") do
      if char=="\n" then
         x,y = ox, y+f.char_h
      else
         f.sb:add(getletter(f, char), x, y)
         x = x+f.char_w
      end
   end
   love.graphics.draw(f.sb)
end

return {
   getsize = getsize,
   draw = draw,
}
