-- Center the stage unless specified
local scene = require "src/scene"
local Folder = require "src/Folder"
local depthdraw = require "src/depthdraw"
local resources = require "src/resources"

local ents = require "battle/ents"
local stage = require "battle/stage"
local set = require "battle/set"

local savedata = require(_G.RES_PATH .. "savedata")
local customize = require(_G.PATHS.battle .. "customize")
local ui =  require(_G.PATHS.battle .. "ui")

local folder_left, folder_right

local bg
local cust_frames
local cust_time = 4*60

local selectchips = function ()
   scene.push(customize, folder_left, folder_right)
   cust_frames = 0
end

local clear = function ()
   resources.cleartag"battle"
   for k,_ in pairs(set) do set[k] = nil end
   folder_left = Folder.new{}
   folder_right = Folder.new{}
   customize.clear()
   ents.exit()
end

clear()

return {
   exit = clear,
   start = function (set_name)
      local tform = depthdraw.tform
      tform.xscale = _G.BATTLE.xscale
      tform.yscale = _G.BATTLE.yscale
      tform.xoff = _G.BATTLE.xoff
      tform.yoff = _G.BATTLE.yoff

      local new_set = dofile(_G.PATHS.sets .. set_name .. ".lua")
      for k,v in pairs(new_set) do set[k] = v end

      if set.left_kind == "player" then
         set.left.queue = {}
         folder_left:load(savedata.player.folder)
      end
      if set.right_kind == "player" then
         set.right.queue = {}
         folder_right:load(savedata.player.folder)
      end

      stage.start()
      ents.start()

      bg = require(_G.PATHS.bg .. set.bg)
      set.bg_args = set.bg_args or {}
      bg.start(unpack(set.bg_args))

      selectchips()
   end,

   update = function (_, input)
      if input then
	 local ending = ents.get_ending()
	 if ending then
	    scene.push(require "battle/results", ending)
	    return
	 end

	 if input[1].st == 1 or input[2].st == 1 then
	    scene.push((require "src/Menu"):new("pause"))
	    return
	 elseif cust_frames >= cust_time and
            (set.left.selectchips or set.right.selectchips)
         then
            set.left.selectchips = false
            set.right.selectchips = false
	    selectchips()
	    return
	 end
	 cust_frames = cust_frames + 1
      end

      stage.update(ents.ents())
      ents.update(input)
   end,

   draw = function ()
      bg.draw()
      ents.draw() -- calls depthdraw
      stage.draw() -- calls depthdraw

      local cust_amount = cust_frames / cust_time
      depthdraw.draw()
      ui.draw(set, cust_amount)
   end,
}
