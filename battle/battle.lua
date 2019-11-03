local oop = require 'src/oop'
local scene = require 'src/scene'
local folder = require 'src/folder'
local depthdraw = require 'src/depthdraw'

local entities = require 'battle/entities'
local stage = require 'battle/stage'
local chip_artist = require 'battle/chip_artist'
local customize = require 'battle/customize/customize'

local savedata = require(RES_PATH .. 'savedata')
local bg = require(PATHS.bg .. 'bg')
local ui =  require(PATHS.battle .. 'ui')

local cust_length = 4*60

local battle = {}

function battle.new (set_name)
   local self = oop.instance(battle, {})
   self.folders = {folder.new{}, folder.new{}}

   local tform = depthdraw.tform
   tform.xscale = BATTLE.xscale
   tform.yscale = BATTLE.yscale
   tform.xoff = BATTLE.xoff
   tform.yoff = BATTLE.yoff

   self.state = dofile(PATHS.sets .. set_name .. '.lua')

   for i = 1,2 do
      if self.state.sides[i].is_player then
         self.folders[i]:load(savedata.player.folder)
      end
   end

   self.bg = bg.new(unpack(self.state.bg))

   self.stage = stage.new()
   self.entities = entities.new(self)
   self.chip_artist = chip_artist.new()

   self.will_select_chips = true
   self.cust_timer = 0

   return self
end

function battle:request_select_chips()
   if self.cust_timer >= cust_length then
      self.will_select_chips = true
   end
end

function battle:update (input)
   if self.will_select_chips then
      for i = 1,2 do
         if self.state.sides[i].is_player then
            self.state.sides[i][1].queue = {}
         end
      end
      scene.push(customize.new(self))
      self.cust_timer = 0
      self.will_select_chips = false
   elseif input then
      local ending = self.entities:get_ending(self.state)
      if ending then
         scene.push(require 'battle/results', ending)
         return
      end

      if input[1].st == 1 or input[2].st == 1 then
         scene.push((require 'src/menu').new('pause'))
         return
      end
      self.cust_timer = self.cust_timer + 1
      self.stage:update(self.entities.entities)
      self.entities:update(input)
   end
end

function battle:draw ()
   self.bg:draw()
   self.entities:draw() -- calls depthdraw
   self.stage:draw(self.state.stage.turf) -- calls depthdraw

   local cust_amount = self.cust_timer / cust_length
   depthdraw.draw()
   ui.draw(self.state, cust_amount)
end

return battle
