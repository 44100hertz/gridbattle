local image = require "SDL.image"
local rdr = _G.RDR
local images = {}

local sheet = {
   icon = {x=0, y=0, w=16, h=16},
   art = {x=0, y=16, w=64, h=72},
}

local getimage = function (name)
   if not images[name] then
      local imgpath = PATHS.chips .. name .. ".png"
      images[name] = rdr:createTextureFromSurface(image.load(imgpath))
   end
   return images[name]
end

local clear = function ()
   images = {}
end

local draw_icon = function (name, x, y)
   local img = getimage(name)
   rdr:copy(img, sheet.icon, {x=x, y=y, w=sheet.icon.w, h=sheet.icon.h})
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
   local img = getimage(name)
   rdr:copy(img, sheet.art, {x=x, y=y, w=sheet.art.w, h=sheet.art.h})
end

return {
   clear = clear,
   draw_icon = draw_icon,
   draw_icon_queue = draw_icon_queue,
   draw_art = draw_art,
}
