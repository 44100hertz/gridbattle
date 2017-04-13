local images = {}
local lg = love.graphics

local getimage = function (name)
   if not images[name] then
      local imgpath = PATHS.chips .. name .. ".png"
      images[name] = lg.newImage(imgpath)
   end
   return images[name]
end

local clear = function ()
   images = {}
end

local draw_icon = function (name, x, y)
   local img = getimage(name)
   lg.draw(img, icon, x, y)
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
   lg.draw(img, art[index], x, y)
end

return {
   clear = clear,
   draw_icon = draw_icon,
   draw_icon_queue = draw_icon_queue,
   draw_art = draw_art,
}
