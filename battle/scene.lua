local scene = require "src/scene"
local bg = require "src/bg"
local Folder = require "src/Folder"

local depthdraw = require "src/depthdraw"
local actors = require "battle/actors"
local stage = require "battle/stage"
local folder = Folder:new{}

local ui =  require(PATHS.battle .. "ui")

local cust_frames
local cust_time = 4*60

local selectchips = function ()
   scene.push(require "battle/chips", folder, actors.player.queue)
   cust_frames = 0
end

return {
   start = function (set, folder_name)
      set = require(PATHS.sets .. set)
      folder = folder:new(require(PATHS.folders .. folder_name))

      stage.start(set.stage.turf)
      actors.start(set)
      bg.start(set.bg)

      selectchips()
   end,

   update = function (_, input)
      if input then
	 local ending = actors.ending()
	 if ending then
	    scene.push(require "battle/results", ending)
	    return
	 end

	 if input.st == 1 then
	    scene.push((require "src/Menu"):new("pause"))
	    return
	 elseif cust_frames >= cust_time and (input.l==1 or input.r==1) then
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

      local cust_amount = cust_frames / cust_time
      ui.draw_under(actors.player, cust_amount, actors.names())
      depthdraw.draw()
      ui.draw_over(actors.player)
   end,
}
