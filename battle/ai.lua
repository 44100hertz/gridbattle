local ai = {}

local stage, turf

ai.start = function (proto_ent, _stage, _turf)
   stage, turf = _stage, _turf
   proto_ent.query_panel = ai.query_panel
   proto_ent.locate_enemy_ahead = ai.locate_enemy_ahead
   proto_ent.is_panel_free = ai.is_panel_free
end

function ai:query_panel (x, y)
   x = x or self.x
   y = y or self.y
   local panel = stage.getpanel(x,y)
   if not panel then
      return {}
   end
   local out = {}
   out.same_side = (not self.side) or
      (self.side == 'left' and x <= turf[y]) or
      (self.side == 'right' and x > turf[y])
   ;
   out.tenant = panel.tenant
   local opp_side = side=='left' and 'right' or 'left'
   out.enemy =
      panel.tenant and
      panel.tenant.tangible and
      panel.tenant.side == opp_side and panel.tenant
   ;
   out.free = out.same_side and not out.tenant
   return out
end

function ai:is_panel_free (x, y)
   return self:query_panel(x, y).free
end

function ai:locate_enemy_ahead (x, y)
   x = x or self.x
   y = y or self.y
   local inc = self.side=='left' and 1 or -1
   repeat
      x = x + inc
      local data = self:query_panel(x, y)
      if data.enemy then
         return data.enemy
      end
   until x < 0 or x > stage.width
   return nil
end

return ai
