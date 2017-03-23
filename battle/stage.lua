--[[
   A data and helper for panels and such.

   Intended both to clean out the battle main loop, and so it doesn't
   have any functions other files would call.
--]]

local lg = love.graphics
local anim = require "src/anim"
local depthdraw = require "src/depthdraw"

local image = love.graphics.newImage(PATHS.battle .. "panel.png")
local sheet = anim.sheet(0, 0, 40, 40, 2, 2,
                         image:getWidth(), image:getHeight())

local turf, panels
local numx, numy = 6, 3

local getpanel = function (x,y)
   x,y = math.floor(x+0.5), math.floor(y+0.5)
   if panels[x] then return panels[x][y] end
end

return {
   start = function (new_turf)
      turf = new_turf
      panels = {}
      for x = 1,numx do
         panels[x] = {}
         for y = 1,numy do
            panels[x][y] = {}
         end
      end
   end,

   update = function ()
      -- Stat/poison counters
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
            local row = x > turf[y] and 1 or 2
            local col = panels[x][y].stat == "poison" and 2 or 1
            local draw = function (x, y)
               lg.draw(image, sheet[row][col], x-BATTLE.xscale/2, y-30)
            end
            depthdraw.add(draw, x, y, -20)
         end
      end
   end,

   isfree = function (x, y, side)
      local panel = getpanel(x,y)
      if (not panel) then return end
      if panel.tenant then return false, panel.tenant end

      local is_left = x <= turf[y]
      local off_side =
         side=="left" and not is_left or
         side=="right" and is_left

      return not off_side
   end,

   occupy = function (actor, x, y)
      x = x or actor.x
      y = y or actor.y
      local panel = getpanel(x,y)

      assert(panel, "attempt to occupy nonexistant panel")
      assert(not panel.tenant, "attempt to occupy occupied space")

      panel.tenant = actor
      actor.on_panel = {x=x, y=y}
   end,

   free = function (x, y)
      local panel = getpanel(x, y)
      if panel then panel.tenant = nil end
   end,

   apply_stat = function (kind, counter, x, y)
      local panel = getpanel(x, y)
      if panel then
         panel.stat = kind
         panel.stat_time = counter
      end
   end,
}
