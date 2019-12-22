local oop = require 'src/oop'
local point = require 'src/point'

local stage = oop.class {}

function stage:init ()
   self.panels = {}
   self.panel_size = point(48, 48)
   self.num_panels = point(6, 3)
   self.size = self.panel_size * self.num_panels
   for x = 1,self.num_panels.x do
      self.panels[x] = {}
      for y = 1,self.num_panels.y do
         self.panels[x][y] = {}
      end
   end
end

function stage:getpanel (x,y)
   assert(self.panels[1][1])
   x,y = math.floor(x+0.5), math.floor(y+0.5)
   return self.panels[x] and self.panels[x][y]
end

function stage:update ()
   for x = 1,self.num_panels.x do
      for y = 1,self.num_panels.y do
         local panel = self.panels[x][y]
         if panel.stat then
            panel.stat_time = panel.stat_time-1
            if panel.stat_time==0 then panel.stat=nil end
         end
         if panel.stat=='poison' and
            panel.tenant and panel.tenant.hp
         then
            panel.tenant.hp = panel.tenant.hp-(1/8)
         end
      end
   end
end

function stage:draw (turf)
   for x = 1,self.num_panels.x do
      for y = 1,self.num_panels.y do
         local screen_x, screen_y = self:to_screen_pos(x-1, y-1)
         if x <= turf[y] then
            love.graphics.setColor(224/256.0, 208/256.0, 240/256.0)
         else
            love.graphics.setColor(248/256.0, 128/256.0, 136/256.0)
         end
         local w, h = self.panel_size:unpack()
         love.graphics.rectangle('fill', screen_x, screen_y, w, h, 5.0)
         love.graphics.setColor(32/256.0, 40/256.0, 56/256.0)
         love.graphics.rectangle('line', screen_x, screen_y, w, h, 5.0)
         if self.panels[x][y].stat == 'poison' then
            local center_x, center_y = self:to_screen_pos(x - 0.5, y - 0.5)
            love.graphics.setColor(108/256.0, 63/256.0, 255/256.0)
            love.graphics.circle('fill', center_x, center_y, 10)
         end
         love.graphics.setColor(1,1,1)
      end
   end
end

-- Apply a status effect to a particular panel
-- kind is handled in the update loop
function stage:apply_stat (kind, x, y)
   local panel = self:getpanel(x, y)
   if panel then
      panel.stat = kind
      panel.stat_time = 600
   else
      io.write(string.format('status effect %s misfired on %s, %s\n',
                             kind, x, y))
   end
end

-- Convert a position on the stage to pixels.
-- 0,0                                        is the upper left corner.
-- stage.num_panels.x, stage.num_panels.y     is the lower right.
function stage:to_screen_pos (x, y)
   local pos = point(x, y)
   local offset = pos * self.panel_size + (GAME.size - self.size) * 0.5
   return offset:unpack()
end

return stage
