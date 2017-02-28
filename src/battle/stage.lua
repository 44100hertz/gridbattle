--[[
A data and helper for panels and such.

Intended both to clean out the battle main loop, and so it doesn't
have any functions other files would call.
--]]

local anim = require "src/anim"
local depthdraw = require "src/depthdraw"

local image = love.graphics.newImage("res/battle/panel.png")
local sheet = anim.sheet(0, 0, 64, 64, 2, 2,
                         image:getWidth(), image:getHeight())

local turf, panels

local getpanel = function (x, y)
   return math.floor(x+0.5), math.floor(y+0.5)
end

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

   draw = function ()
      for x = 1,STAGE.numx do
         for y = 1,STAGE.numy do
            depthdraw.add{
               image = image,
               x=x, y=y, z = -200,
               ox = 32, oy = 220,
               anim = sheet,
               row = x > turf[y] and 1 or 2,
               frame = 1,
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

   occupy = function (actor)
      local x,y = getpanel(actor.x, actor.y)
      local panel = panels[x][y]
      assert(panel, "cannot move to nonexistant panel")
      if panel then panel.tenant = actor end
      actor.on_panel = {x=x, y=y}
   end,

   free = function (x, y)
      panels[x][y].tenant = nil
   end,
}
