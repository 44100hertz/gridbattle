local scene = require 'src/scene'
local folder = require 'src/folder'
local depthdraw = require 'src/depthdraw'

local ents = require 'battle/ents'
local stage = require 'battle/stage'
local customize = require 'battle/customize/customize'
local proto_ent = require 'battle/proto/ent'

local savedata = require(RES_PATH .. 'savedata')
local ui =  require(PATHS.battle .. 'ui')

local folder_left, folder_right

local bg
local cust_frames
local cust_time = 4*60

local bstate = {}

local selectchips = function ()
   bstate.left.queue = {}
   bstate.right.queue = {}
   scene.push(customize, bstate, folder_left, folder_right)
   cust_frames = 0
end

local clear = function ()
   for k,_ in pairs(bstate) do bstate[k] = nil end
   folder_left = folder.new{}
   folder_right = folder.new{}
   ents.exit()
end

clear()

return {
   exit = clear,
   start = function (set_name)
      local tform = depthdraw.tform
      tform.xscale = BATTLE.xscale
      tform.yscale = BATTLE.yscale
      tform.xoff = BATTLE.xoff
      tform.yoff = BATTLE.yoff

      local new_set = dofile(PATHS.sets .. set_name .. '.lua')
      for k,v in pairs(new_set) do bstate[k] = v end

      if bstate.left_kind == 'player' then
         bstate.left.queue = {}
         folder_left:load(savedata.player.folder)
      end
      if bstate.right_kind == 'player' then
         bstate.right.queue = {}
         folder_right:load(savedata.player.folder)
      end

      stage.start()
      ents.start(bstate, stage)

      bg = require(PATHS.bg .. bstate.bg)
      bstate.bg_args = bstate.bg_args or {}
      bg.start(unpack(bstate.bg_args))

      proto_ent:initialize(bstate, stage)

      selectchips()
   end,

   update = function (_, input)
      if input then
	 local ending = ents.get_ending(bstate)
	 if ending then
	    scene.push(require 'battle/results', ending)
	    return
	 end

	 if input[1].st == 1 or input[2].st == 1 then
	    scene.push((require 'src/menu').new('pause'))
	    return
	 elseif cust_frames >= cust_time and
            (bstate.left.selectchips or bstate.right.selectchips)
         then
            bstate.left.selectchips = false
            bstate.right.selectchips = false
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
      stage.draw(bstate.stage.turf) -- calls depthdraw

      local cust_amount = cust_frames / cust_time
      depthdraw.draw()
      ui.draw(bstate, cust_amount)
   end,
}
