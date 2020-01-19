local oop = require 'src/oop'
local stage = oop.class {}

-- Return the panel at this x and y position
function stage:get_panel (pos)
   pos = (pos + 0.5):floor()
   return self.panels[pos.x] and self.panels[pos.x][pos.y]
end

-- If a panel contains an enemy, return the enemy.
function stage:locate_enemy (pos, side)
   local panel = self:get_panel(pos)
   return
      panel and
      panel.tenant and
      panel.tenant.side ~= side and panel.tenant
end

-- Try to find an enemy in a horizontal line of sight
function stage:locate_enemy_ahead (pos, side)
   local inc = side==1 and 1 or -1
   repeat
      pos = pos + point(inc, 0)
      local enemy = self:locate_enemy(pos, side)
      if enemy then return enemy end
   until pos.x < 0 or pos.x > self.num_panels.x
end

function stage:get_panel_side (pos)
   return pos.x > self.turf[pos.y] and 2 or 1
end

-- Determine if a panel on the stage is free
function stage:is_panel_free (pos, side)
   local panel = self:get_panel(pos)
   return panel and not panel.tenant
end

-- Convert a position on the stage to pixels.
-- 0,0                                        is the upper left corner.
-- stage.num_panels.x, stage.num_panels.y     is the lower right.
function stage:to_screen_pos (pos)
   return pos * self.panel_size + (GAME.size - self.size) * 0.5
end

function stage:init (turf)
   self.panels = {}
   self.panel_size = point(48, 48)
   self.num_panels = point(6, 3)
   self.size = self.panel_size * self.num_panels
   self.turf = turf
   for x = 1,self.num_panels.x do
      self.panels[x] = {}
      for y = 1,self.num_panels.y do
         self.panels[x][y] = {}
      end
   end
end

function stage:draw ()
   for x = 1,self.num_panels.x do
      for y = 1,self.num_panels.y do
         local screen_pos = self:to_screen_pos(point(x,y)-1)
         if x <= self.turf[y] then
            love.graphics.setColor(1, 0, 1, 0.5)
         else
            love.graphics.setColor(0, 0, 1, 128/256.0, 136/256.0, 0.5)
         end
         local w, h = self.panel_size:unpack()
         love.graphics.rectangle('fill', screen_pos.x, screen_pos.y, w, h, 5.0)
         love.graphics.setColor(32/256.0, 40/256.0, 56/256.0)
         love.graphics.rectangle('line', screen_pos.x, screen_pos.y, w, h, 5.0)
         love.graphics.setColor(1,1,1)
      end
   end
end

return stage
