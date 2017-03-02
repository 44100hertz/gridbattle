local chips = {}

local anim = require "src/anim"
-- Chip graphics are fixed size at 256x256
-- this enables quads to be computed once only
local w,h = 256,256
local icon = anim.sheet(0,0,16,16,1,1,w,h)[1][1]
local art = anim.sheet(0,16,64,72,4,1,w,h)[1]

local getchip = function (name)
   if not chips[name] then
      local imgpath = "res/chips/" .. name .. ".png"
      local srcpath = "res/chips/" .. name .. ".lua"

      chips[name] = {
         img = love.graphics.newImage(imgpath),
         src = require srcpath,
      }
   end
   return chips[name]
end

return {
   clear = function ()
      chips = {}
   end,

   draw_art = function (name, x, y, index)
      index = index or 1
      local chip = getchip(name)
      love.graphics.draw(chip, art[index], x, y)
   end,

   draw_icon = function (name, x, y)
      local chip = getchip(name)
      love.graphics.draw(chip, icon, x, y)
   end,
}
