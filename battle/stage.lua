local oop = require 'src/oop'
local img = (require 'src/image').new'panels'

local stage = {
   panel_width = 32,
   panel_height = 32,
   width = 6,
   height = 3,
}

function stage.new ()
   local self = oop.instance(stage, {})
   self.panels = {}
   for x = 1,self.width do
      self.panels[x] = {}
      for y = 1,self.height do
         self.panels[x][y] = {}
      end
   end
   img:set_sheet('base')
   return self
end

function stage:getpanel (x,y)
   assert(self.panels[1][1])
   x,y = math.floor(x+0.5), math.floor(y+0.5)
   return self.panels[x] and self.panels[x][y]
end

function stage:update (ents)
   for x = 1,self.width do
      for y = 1,self.height do
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
   for x = 1,self.width do
      for y = 1,self.height do
         local x0, y0 = self:to_screen_pos(x-1, y-1)
         local x1, y1 = self:to_screen_pos(x, y)
         if x <= turf[y] then
            love.graphics.setColor(224/256.0, 208/256.0, 240/256.0)
         else
            love.graphics.setColor(248/256.0, 128/256.0, 136/256.0)
         end
         local w, h = self.panel_width, self.panel_height
         love.graphics.rectangle('fill', x0, y0, w, h, 5.0)
         love.graphics.setColor(32/256.0, 40/256.0, 56/256.0)
         love.graphics.rectangle('line', x0, y0, w, h, 5.0)
         if self.panels[x][y].stat == 'poison' then
            local x, y = self:to_screen_pos(x - 0.5, y - 0.5)
            love.graphics.setColor(108/256.0, 63/256.0, 255/256.0)
            love.graphics.circle('fill', x, y, 10)
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
-- 0,0                           is the upper left corner.
-- stage.width, stage.height     is the lower right.
function stage:to_screen_pos (x, y)
   -- Calculate total size of stage
   local xsize = self.panel_width * self.width
   local ysize = self.panel_height * self.height
   -- Place panels with centered geometry
   local ox = x * xsize / self.width  + 0.5 * (GAME.width - xsize)
   local oy = y * ysize / self.height + 0.5 * (GAME.height - ysize)
   return ox, oy
end

return stage
