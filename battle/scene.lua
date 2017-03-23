-- Center the stage unless specified
_G.BATTLE.xoff = BATTLE.xoff or
   math.floor(GAME.width/2 - (BATTLE.xscale * (BATTLE.numx + 1) * 0.5))

local scene = require "src/scene"
local Folder = require "src/Folder"
local bg = require "src/bg"
local depthdraw = require "src/depthdraw"
local ents = require "battle/ents"
local stage = require "battle/stage"
local folder = Folder.new{}

local savedata = require(RES_PATH .. "savedata")
local ui =  require(PATHS.battle .. "ui")

local cust_frames
local cust_time = 4*60

local selectchips = function ()
   scene.push(require(PATHS.battle .. "customize"), folder, ents.player.queue)
   cust_frames = 0
end

return {
   start = function (set)
      set = require(PATHS.sets .. set)
      folder:load(savedata.player.folder)

      stage.start(set.stage.turf)
      ents.start(set)
      bg.start(set.bg)

      selectchips()
   end,

   update = function (_, input)
      if input then
	 local ending = ents.get_ending()
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

      ents.update(input)
      stage.update()
   end,

   draw = function ()
      bg.draw()
      ents.draw() -- calls depthdraw
      stage.draw() -- calls depthdraw

      local cust_amount = cust_frames / cust_time
      ui.draw_under(ents.player, cust_amount, ents.get_enemy_names())
      depthdraw.draw()
      ui.draw_over(ents.player)
   end,

   exit = function ()
      ents.exit()
   end
}
