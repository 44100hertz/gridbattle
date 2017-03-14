local chips = {}

local ents = require "battle/ents"
local anim = require "src/anim"
-- Chip graphics are fixed size at 256x256
-- this enables quads to be computed once only
local w,h = 256,256
local icon = anim.sheet(0,0,16,16,1,1,w,h)[1][1]
local art = anim.sheet(0,16,64,72,4,1,w,h)[1]

local getchip = function (name)
   if not chips[name] then
      local imgpath = PATHS.chips .. name .. ".png"
      local srcpath = PATHS.chips .. name

      chips[name] = {
         img = love.graphics.newImage(imgpath),
         src = require(srcpath),
      }
   end
   return chips[name]
end

local use = function (actor, chip, variant)
   local data = getchip(chip)
   local added = ents.add(
      {x=actor.x, y=actor.y, parent=actor},
      data.src, variant)
   added.group = added.group or actor.group
   added.side = added.side or actor.side
end

local draw_icon = function (name, x, y)
   local chip = getchip(name)
   love.graphics.draw(chip.img, icon, x, y)
end

return {
   use = use,
   draw_icon = draw_icon,

   clear = function ()
      chips = {}
   end,

   draw_art = function (name, x, y, index)
      index = index or 1
      local chip = getchip(name)
      love.graphics.draw(chip.img, art[index], x, y)
   end,

   queue_draw = function (queue, x, y)
      x = x - #queue - 8
      y = y - #queue - 8
      for i=#queue,1,-1 do
         draw_icon(queue[i].name, x, y)
         x=x+2
         y=y+2
      end
   end,

   queue_use = function (actor)
      if #actor.queue>0 then
         local removed = table.remove(actor.queue, 1)
         use(actor, removed.name, removed.variant)
      end
   end,

   letter2num = {a=1,b=2,c=3,d=4,e=5},
   getchip = getchip,
}
