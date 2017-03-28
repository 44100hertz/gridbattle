local ents = require "battle/ents"
local stage = require "battle/stage"

local set
local ai = {}

ai.start = function (_set) set = _set end

ai.is_panel_free = function (x, y, side)
   x,y = math.floor(x+0.5), math.floor(y+0.5)
   if side=="left" and x > set.stage.turf[y] then return false end
   if side=="right" and x <= set.stage.turf[y] then return false end
   for _,ent in ipairs(ents) do
      if ent.tangible and ent.x == x and ent.y == y then
         return false, ent
      end
   end
   return true
end

ai.see_enemy = function (x, y, side)
   local opp_side = side=="left" and "right" or "left"
   for _,ent in ipairs(ents.ents()) do
      if ent.tangible and
         ent.side == opp_side and
         math.abs(x - ent.x) < 1 and
         math.abs(y - ent.y) < 1
      then
         return ent
      end
   end
   return false
end

ai.see_line = function (x, y, side)
   local opp_side = side=="left" and "right" or "left"
   local inc = side=="left" and 1 or -1
   repeat
      x = x + inc
      local see = ai.see_enemy(x, y, side)
      if see then return see end
   until x <= -1
   return false
end

return ai
