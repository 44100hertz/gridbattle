--[[
   The main loop of a battle
   Should be required as module when loading a new state
--]]

local state = require "src/state"
local input = require "src/input"
local bg = require "src/bg"

local depthdraw = require "src/depthdraw"
local actors = require "src/battle/actors"
local stage = require "src/battle/stage"

local fonts = require "res/fonts"

-- Some global vars used throughout battle
_G.STAGE = {
   numx = 6, numy = 3,
   xoff = -24, yoff = 74,
   w = 64, h = 40,
}

return {
   start = function (_, set)
      stage.start(set.stage.turf)
      actors.start(set.actors)
      bg.start(set.bg)
   end,

   update = function ()
      if input.st == 1 then
         state.push(require "res/menu/pause")
         return
      end
      actors.update()
   end,

   draw = function ()
      bg.draw()
      actors.draw()
      stage.draw()

      depthdraw.draw()
   end,
}
