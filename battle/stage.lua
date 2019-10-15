local oop = require 'src/oop'
local depthdraw = require 'src/depthdraw'

local img = (require 'src/image').new'panels'

local stage = {
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
         local row = x > turf[y] and 1 or 2
         local col = self.panels[x][y].stat == 'poison' and 2 or 1
         local index = (row-1)*2 + col
         local draw = function (x, y)
            img:draw(x, y, nil, index)
         end
         depthdraw.add(draw, x, y, -20)
      end
   end
end

function stage:apply_stat (kind, counter, x, y)
   local panel = self:getpanel(x, y)
   if panel then
      panel.stat = kind
      panel.stat_time = counter
   end
end

return stage
