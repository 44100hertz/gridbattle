local rdr = _G.RDR

local depthdraw = require "src/depthdraw"
local resources = require "src/resources"
local set = require "battle/set"

local panel_w, panel_h = 40,40

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

   update = function ()
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
      local img = resources.getimage(_G.PATHS.battle .. "panels.png", "battle")
      for x = 1,numx do
         for y = 1,numy do
            local row = x > set.stage.turf[y] and 0 or 1
            local col = panels[x][y].stat == "poison" and 1 or 0
            local draw = function (x, y)
               rdr:copy(img,
                        {x=col*panel_w, y=row*panel_h, w=panel_w, h=panel_h},
                        {x=x-20, y=y-30, w=panel_w, h=panel_h})
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
