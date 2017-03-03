--[[
   A data and helper for panels and such.

   Intended both to clean out the battle main loop, and so it doesn't
   have any functions other files would call.
--]]

local anim = require "src/anim"
local depthdraw = require "src/depthdraw"

local image = love.graphics.newImage("res/battle/panel.png")
local sheet = anim.sheet(0, 0, 40, 40, 2, 2,
                         image:getWidth(), image:getHeight())

local turf, panels

return {
   start = function (new_turf)
      turf = new_turf
      panels = {}
      for x = 1,STAGE.numx do
         panels[x] = {}
         for y = 1,STAGE.numy do
            panels[x][y] = {}
         end
      end
   end,

   update = function ()
      -- Stat/poison counters
      for x = 1,STAGE.numx do
         for y = 1,STAGE.numy do
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
      for x = 1,STAGE.numx do
         for y = 1,STAGE.numy do
            local frame = 1
            if panels[x][y].stat == "poison" then frame=2 end
            depthdraw.add{
               image = image,
               x=x, y=y, z = -20,
               ox = 20, oy = 30,
               anim = sheet,
               row = x > turf[y] and 1 or 2,
               frame = frame,
            }
         end
      end
   end,

   isfree = function (x, y, side)
      local panel = panels[x] and panels[x][y] or nil
      if (not panel) or panel.tenant then return end

      local is_left = x <= turf[y]
      local off_side =
         side=="left" and not is_left or
         side=="right" and is_left

      return not off_side
   end,

   occupy = function (actor, x, y)
      x = x or actor.x
      y = y or actor.y
      local new_x, new_y = math.floor(x+0.5), math.floor(y+0.5)
      local panel = panels[new_x] and panels[new_x][new_y] or nil

      assert(panel, "attempt to occupy nonexistant panel")
      assert(not panel.tenant, "attempt to occupy occupied space")

      panel.tenant = actor
      actor.on_panel = {x=new_x, y=new_y}
   end,

   free = function (x, y)
      x,y = math.floor(x+0.5), math.floor(y+0.5)
      panels[x][y].tenant = nil
   end,

   apply_stat = function (kind, counter, mask, xoff, yoff)
      -- xoff = xoff or 0
      -- yoff = yoff or 0
      -- for x = 1,STAGE.numx do
      --    for y = 1,STAGE.numy do
      --       if mask[x] and mask[x][y] then
      --       end
      --    end
      -- end

      panels[xoff][yoff].stat = kind
      panels[xoff][yoff].stat_time = counter
   end,
}
