-- Functions for drawing ascii-grid fonts

local fonts = {}

return {
   draw = function (font, text, x, y)
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
      local f = fonts[font]
      f.sb:clear()
      for char in text:gmatch(".") do
         -- Make letter quads as needed
         c = string.byte(char)
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
      love.graphics.draw(f.sb)
   end,

   wrap = function (text, width)
      local word_iter = text:gmatch("%g+")
      local pieces = {} -- Processed parts of words
      local line_left = width

      for word in word_iter do
         local i = 1
         -- Try to split out long words
         local is_split
         -- Hyphenate parts that don't fit
         while(i+width-1 < word:len()) do
            table.insert(pieces, "\n" .. word:sub(i, i+width-2) .. "-")
            i=i+width-1
            is_split = true
         end
         last = word:sub(i)
         if is_split or last:len() >= line_left then
            table.insert(pieces, "\n" .. last)
            line_left = width - last:len()
         else
            if line_left < width then table.insert(pieces, " ") end
            table.insert(pieces, last)
            line_left = line_left - last:len()
         end
      end
      return table.concat(pieces)
   end
}
