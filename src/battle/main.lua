--[[
   The main loop of a battle
   Should be required as module when loading a new state
--]]

local state = require "src/state"
local input = require "src/input"
local bg = require "src/bg"

local battle = require "src/battle/battle"
local data = require "src/battle/data"

local fonts = require "res/fonts"

local collide = function ()
   for i = 1, #data.actors do
      for j = i+1, #data.actors do -- start at i+1 to only check unique collisions
         local o1 = data.actors[i]
         local o2 = data.actors[j]
         if o1.group ~= o2.group and
         (o1.recv and o2.send) or -- if either can collide
            (o2.recv and o1.send)
         then
            local size = o1.size + o2.size
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

return {
   start = function (_, set)
      data.actors = {}

      -- Stage panels
      local turf = set.stage.turf
      for x = 1,data.stage.numx do
         data.stage[x] = {}
         for y = 1,data.stage.numy do
            local newpanel = {
               x=x, y=y,
               side = (x <= turf[y]) and "left" or "right"
            }
            data.stage[x][y] = newpanel
            battle.addactor(newpanel, require "res/battle/actors/panel")
         end
      end

      -- Any actors specified for level; enemies
      for i = 1,#set.actors,2 do
         local dup = {}
         for k,v in pairs(set.actors[i]) do dup[k] = v end
         battle.addactor(dup, set.actors[i+1])
      end

      bg.start(set.bg)
   end,

   update = function ()
      if input.st == 1 then
         state.push(require "res/menu/pause")
         return
      end

      for _,v in ipairs(data.actors) do
         if v.update then v:update() end
         if v.stand then v.z = battle.getpanel(v.x, v.y).z + v.height end
      end

      for k,v in ipairs(data.actors) do
         if v.despawn then table.remove(data.actors, k) end
      end

      collide()
   end,

   draw = function ()
      bg.draw()

      local depth = function (o) return o.y+(o.z/40) end
      local depths = {}
      local depth_step = 0.5
      local min_depth = -100
      local max_depth = 100
      for _,v in ipairs(data.actors) do
         local d = depth(v)
         min_depth = math.min(min_depth, d)
         max_depth = math.max(max_depth, d)
         local index = math.floor(d / depth_step)
         if not depths[index] then depths[index] = {} end
         table.insert(depths[index], v)
      end

      for i = min_depth,max_depth do
         if depths[i] then
            for _,v in ipairs(depths[i]) do
               local x = data.stage.x + data.stage.w * v.x
               local y = data.stage.y + data.stage.h * v.y - v.z
               v:draw(x, y)
               if v.hp then
                  love.graphics.setFont(fonts.tinyhp)
                  love.graphics.print(v.hp, x-15, y-30)
               end
            end
         end
      end
   end,
}
