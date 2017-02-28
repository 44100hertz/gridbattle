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
               x = x,
               y = y,
               z = -160, height = 160,
               ox = 30,
               oy = 20,
               anim = sheet,
               frame = x > turf[y] and 1 or 3,
            }
         end
      end
   end,

   getpanel = function (x, y)
      x,y = math.floor(x+0.5), math.floor(y+0.5)
      if panels[x] and panels[x][y] then
         return panels[x][y]
      end
   end,

   occupy = function (actor, x, y, side)
      local panel = panels[x] and panels[x][y] or nil
      if not panel then return end

      local is_left = x <= turf[y]
      local off_side =
         side=="left" and not is_left or
         side=="right" and is_left

      if not off_side and not panel.occupant then
         panel.occupant = actor
         return true
      end
   end,

   free = function (x, y)
      panels[x][y].occupant = nil
   end,
}
