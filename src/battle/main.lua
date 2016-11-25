--[[
   The main loop of a battle
   Should be required as module when loading a new state
--]]

local state = require "src/state"
local input = require "src/input"
local test = require "src/test"

local battle = require "src/battle/battle"
local data = require "src/battle/data"

local fonts = require "res/fonts/fonts"

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

local bg, bgquad

return {
   start = function (_, set)
      data.actors = {}

      bg = set.bg
      bg:setWrap("repeat", "repeat")
      bgquad = love.graphics.newQuad(0, 0, 432, 272, 32, 32)

      -- Stage panels
      local turf = set.stage.turf
      local panel = require "res/battle/actors/panel"
      for x = 1,data.stage.numx do
         data.stage[x] = {}
         for y = 1,data.stage.numy do
            local newpanel = {
               class=panel,
               x=x, y=y,
               side = (x <= turf[y]) and "left" or "right"
            }
            data.stage[x][y] = newpanel
            battle.addactor(newpanel)
         end
      end

      -- Any actors specified for level; enemies
      for _,v in ipairs(set.actors) do battle.addactor(v) end
   end,

   update = function ()
      if input.st == 1 then
         state.push(require "res/menu/pause")
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
   end,

   draw = function ()
      local bgoff = love.timer.getTime() * 30 % 32 - 32
      love.graphics.draw(bg, bgquad, math.floor(bgoff-0.5), math.floor(bgoff))

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
