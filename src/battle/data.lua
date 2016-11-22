--[[
   All data for a given battle. NOT to be used by any actor.
--]]

local stage = {
   numx=6, numy=3, -- number of platforms
   x=-24, y=74, -- -24 = -32 + 8 (dist from screen edge)
   w=64, h=40, -- size of each platform
   -- stored by loadset: 2d array stage[x][y] such that x and y
   -- are the position of a given platform
}

local actors = {}

return {
   loadset = function (set)
      actors = {}

      -- Stage panels
      local turf = set.stage.turf
      local panel = require "battle/actors/panel"
      for x = 1,stage.numx do
         stage[x] = {}
         for y = 1,stage.numy do
            local newpanel = {
               class=panel,
               x=x, y=y, z=-8,
               side = (x <= turf[y]) and "left" or "right"
            }
            stage[x][y] = newpanel
            battle.addactor(newpanel)
         end
      end

      -- Player
      local player = {
         class=require "battle/actors/player",
         x=set.stage.spawn.x, y=set.stage.spawn.y, side="left"
      }
      battle.addactor(player)

      -- Any actors specified for level; enemies
      for _,v in ipairs(set.actors) do battle.addactor(v) end
   end,

   stage = stage,
   actors = actors,
}
