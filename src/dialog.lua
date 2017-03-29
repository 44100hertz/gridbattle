local rdr = _G.RDR

local src_text = require "src/text"
local scene = require "src/scene"

local w,h
local draw_box = function (font, text, x, y, color, border)
   color = color or 0
   border = border or 4
   rdr:setDrawColor(color)
   rdr:fillRect{x=x-border, y=y-border, w=w+2*border, h=h+2*border}
   src_text.draw(font, text, x, y)
end

local text, x, y
local font = "flavor"
return {
   draw_box = draw_box,
   popup = {
      transparent = true,
      start = function (new_text, new_x, new_y)
         text, x, y = new_text, new_x, new_y
         w,h = src_text.getsize(font, text)
      end,
      update = function (_, input_list)
         local input = input_list[1]
         if input.a == 1 or input.b == 1 then
            scene.pop()
         end
      end,
      draw = function ()
         draw_box(font, text, x, y)
      end,
   }
}
