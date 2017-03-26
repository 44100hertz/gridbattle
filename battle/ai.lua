local stage = require "battle/stage"

local ai = {}

ai.see_enemy = function (x, y, opp_side)
   panel = stage.getpanel(x,y)
   if panel and panel.tenant and panel.tenant.side==opp_side then
      return panel.tenant
   end
end

ai.see_line = function (x, y, side)
   local opp_side = side=="left" and "right" or "left"
   repeat
      x = x + (side=="left" and 1 or -1)
      local see = ai.see_enemy(x, y, opp_side)
      if see then return see end
   until not panel
   return false
end

return ai
