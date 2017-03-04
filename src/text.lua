-- Functions for drawing ascii-grid fonts

local fonts = {}

return {
   draw = function (font, text, ox, oy)
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
      local x,y = ox, oy
      local f = fonts[font]
      f.sb:clear()
      for char in text:gmatch(".") do
         if char == "\n" then
            x,y = ox, y + f.char_h
         else
            c = string.byte(char)
            -- Make letter quads as needed
            if not f.quads[c] then
               f.quads[c] = love.graphics.newQuad(
                  c%16*f.char_w, math.floor(c/16)*f.char_h,
                  f.char_w, f.char_h,
                  f.img:getWidth(), f.img:getHeight()
               )
            end
            f.sb:add(f.quads[c], x, y)
            x = x+f.char_w
         end
      end
      love.graphics.draw(f.sb)
   end,
}
