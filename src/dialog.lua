local src_text = require "src/text"
local input = require "src/input"
local state = require "src/state"

local draw_box = function (font, text, x, y, color, border)
   color = color or {0,0,0}
   border = border or 4

   love.graphics.setColor(unpack(color))
   local w,h = src_text.get_size(font, text)
   love.graphics.rectangle("fill", x-border, y-border, w+2*border, h+2*border)
   love.graphics.setColor(255, 255, 255)
   src_text.draw(font, text, x, y)
end

local lastmod, text, x, y
return {
   draw_box = draw_box,

   popup = {
      start = function (new_lastmod, new_text, new_x, new_y)
         lastmod, text, x, y = new_lastmod, new_text, new_x, new_y
      end,
      update = function ()
         if input.b == 1 then
            state.pop()
         end
      end,
      draw = function ()
         lastmod.draw()
         draw_box("flavor", text, x, y)
      end,
   }
}
