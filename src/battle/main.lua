--[[
   The main loop of a battle
   Should be required as module when loading a new state
--]]

local main = require "main"
local input = require "input"
local fonts = require "fonts"
local test = require "test"

local battle = require "battle/battle"
local data = require "battle/data"

local collide = function ()
   for i = 1, #data.actors do
      for j = i+1, #data.actors do -- start at i+1 to only check unique collisions
         local o1 = data.actors[i]
         local o2 = data.actors[j]
         if o1.class.group ~= o2.class.group and
         (o1.class.recv and o2.class.send) or -- if either can collide
            (o2.class.recv and o1.class.send)
         then
            local size = o1.class.size + o2.class.size
            if math.abs(o1.x - o2.x) < size and -- square collisions
               math.abs(o1.y - o2.y) < size
            then
               battle.signal(o1, o2, "recv")
               battle.signal(o2, o1, "recv")
            end
         end
      end
   end
end

local time
local bg, bgquad

return {
   start = function (_, set)
      time = 0
      data.loadset(set)

      bg = set.bg
      bg:setWrap("repeat", "repeat")
      bgquad = love.graphics.newQuad(0, 0, 432, 272, 32, 32)
   end,

   update = function ()
      if input.start == 1 then
         main.pushstate(require "battle/pause")
         return
      end

      for _,v in ipairs(data.actors) do
         if v.class.update then v.class.update(v) end
         if v.stand then v.z = battle.getpanel(v.x, v.y).z + v.class.height end
      end

      for k,v in ipairs(data.actors) do
         if v.despawn then table.remove(data.actors, k) end
      end

      collide()

      time = time + 1
   end,

   draw = function ()
      love.graphics.draw(bg, bgquad, -- background
                         math.floor((time/2)%32-31.5), math.floor((time/2)%32-32)
      )

      table.sort(data.actors, function(o1, o2) -- depth ordering
                    return (o1.y+(o1.z/40) < o2.y+(o2.z/40))
      end)

      for _,v in ipairs(data.actors) do
         if v.class.draw then
            local x = data.stage.x + data.stage.w * v.x
            local y = data.stage.y + data.stage.h * v.y - v.z
            v.class.draw(v, x, y)
            if v.hp then
               love.graphics.setFont(fonts.tinyhp)
               love.graphics.print(v.hp, x-15, y-30)
            end
         end
      end
   end,
}
