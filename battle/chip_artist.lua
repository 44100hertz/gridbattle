local rdr = _G.RDR
local images = {}
local resources = require "src/resources"

local draw_icon = function (name, x, y)
   local img = resources.getimage(_G.PATHS.chips .. name .. ".png", "battle")
   rdr:copy(img, {x=0, y=0, w=16, h=16}, {x=x, y=y, w=16, h=16})
end

local draw_icon_queue = function (queue, x, y)
   x = x - #queue - 8
   y = y - #queue - 8
   for i=#queue,1,-1 do
      draw_icon(queue[i].name, x, y)
      x=x+2
      y=y+2
   end
end

local draw_art = function (name, x, y, index)
   index = index or 1
   local img = resources.getimage(_G.PATHS.chips .. name .. ".png", "battle")
   rdr:copy(img, {x=index*64, y=16, w=64, h=72}, {x=x, y=y, w=64, h=72})
end

return {
   draw_icon = draw_icon,
   draw_icon_queue = draw_icon_queue,
   draw_art = draw_art,
}
