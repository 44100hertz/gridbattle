local images = {}
local lg = love.graphics

-- Chip graphics are fixed size at 256x256
-- this enables quads to be computed once only
local icon, art
do
   local w,h = 256,256
   icon = lg.newQuad(0,0,16,16,w,h)
   art = lg.newQuad(0,16,64,72,w,h)
end

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
   lg.draw(img, art, x, y)
end

return {
   clear = clear,
   draw_icon = draw_icon,
   draw_icon_queue = draw_icon_queue,
   draw_art = draw_art,
}
