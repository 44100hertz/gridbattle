local scene = require "src/scene"
local bg = require "src/bg"

local depthdraw = require "src/depthdraw"
local actors = require "src/battle/actors"
local stage = require "src/battle/stage"
local Folder = require "src/Folder"
local folder

local ui =  require "res/battle/ui"

local cust_frames

-- Some global vars used throughout battle
_G.STAGE = {
   numx = 6,   numy = 3,
   xoff = -20, yoff = 62,
   w = 40,     h = 24,
}
_G.CUST_TIME = 4*60

selectchips = function ()
   scene.push(require "res/menu/chips", folder, actors.player.queue)
   cust_frames = 0
end

return {
   start = function (set)
      local Folder = require "src/Folder"
      folder = Folder:new(require "res/folders/test")
      folder:shuffle()

      stage.start(set.stage.turf)
      actors.start(set)
      bg.start(set.bg)
   end,

   update = function (_, input)
      if input then
	 local ending = actors.ending()
	 if ending then
	    scene.push(require "res/menu/results", ending)
	    return
	 end

	 if input.st == 1 then
	    scene.push((require "src/Menu"):new(require "res/menu/pause"))
	    return
	 elseif cust_frames >= CUST_TIME and (input.l==1 or input.r==1) then
	    selectchips()
	    return
	 end
	 cust_frames = cust_frames + 1
      end

      actors.update(input)
      stage.update()
   end,

   draw = function ()
      -- All of these call depthdraw
      bg.draw()
      actors.draw()
      stage.draw()

      ui.draw_under(actors.player, cust_frames, actors.enemy)
      depthdraw.draw()
      ui.draw_over(actors.player)
   end,

   selectchips = selectchips,
}
