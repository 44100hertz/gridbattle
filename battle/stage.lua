local depthdraw = require "src/depthdraw"
local set = require "battle/set"

local img = (require "src/Image"):new("panels")

-- load stage.png
local panels
local numx, numy = 6, 3

local getpanel = function (x,y)
   x,y = math.floor(x+0.5), math.floor(y+0.5)
   if panels[x] then return panels[x][y] end
end

return {
   getpanel = getpanel,

   clear = function ()
      for x = 1,numx do
         for y = 1,numy do
            panels[x][y].tenant = nil
         end
      end
   end,

   start = function ()
      panels = {}
      for x = 1,numx do
         panels[x] = {}
         for y = 1,numy do
            panels[x][y] = {}
         end
      end
   end,

   update = function (ents)
      for x = 1,numx do
         for y = 1,numy do
            local panel = panels[x][y]
            if panel.stat then
               panel.stat_time = panel.stat_time-1
               if panel.stat_time==0 then panel.stat=nil end
            end
            if panel.stat=="poison" and
               panel.tenant and panel.tenant.hp
            then
               panel.tenant.hp = panel.tenant.hp-(1/8)
            end
         end
      end
   end,

   draw = function ()
      for x = 1,numx do
         for y = 1,numy do
            local row = x > set.stage.turf[y] and 1 or 2
            local col = panels[x][y].stat == "poison" and 2 or 1
            local index = (col-1)*numy + numx
            local draw = function (x, y)
               img:draw(x, y, index)
            end
            depthdraw.add(draw, x, y, -20)
         end
      end
   end,

   apply_stat = function (kind, counter, x, y)
      local panel = getpanel(x, y)
      if panel then
         panel.stat = kind
         panel.stat_time = counter
      end
   end,
}
