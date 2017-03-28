local ents = require "battle/ents"
local stage = require "battle/stage"

local set
local ai = {}

ai.start = function (_set) set = _set end

ai.is_panel_free = function (x, y, side)
   local panel = stage.getpanel(x,y)
   if not panel then return false end
   if (side=="left" and x > set.stage.turf[y]) then return false end
   if (side=="right" and x <= set.stage.turf[y]) then return false end
   if panel.tenant then return false, panel.tenant end
   return true
end

ai.see_enemy = function (x, y, side)
   local opp_side = side=="left" and "right" or "left"
   local panel = stage.getpanel(x, y)
   if panel and
      panel.tenant and
      panel.tenant.tangible and
      panel.tenant.side == opp_side
   then
      return panel.tenant
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
