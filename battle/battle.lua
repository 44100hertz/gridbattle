local oop = require 'src/oop'
local scene = require 'src/scene'
local folder = require 'src/folder'
local depthdraw = require 'src/depthdraw'

local entities = require 'battle/entities'
local stage = require 'battle/stage'
local customize = require 'battle/customize/customize'

local savedata = require(RES_PATH .. 'savedata')
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

   if self.state.left_kind == 'player' then
      self.state.left.queue = {}
      self.folders[1]:load(savedata.player.folder)
   end
   if self.state.right_kind == 'player' then
      self.state.right.queue = {}
      self.folders[2]:load(savedata.player.folder)
   end

   self.bg = require(PATHS.bg .. self.state.bg)
   self.state.bg_args = self.state.bg_args or {}
   self.bg.start(unpack(self.state.bg_args))

   self.stage = stage.new()
   self.entities = entities.new(self)

   self.initial_select_chips = true
   self.cust_timer = 0

   return self
end

function battle:selectchips ()
   self.state.left.queue = {}
   self.state.right.queue = {}
   scene.push(customize.new(self.state, self.folders[1], self.folders[2]))
   self.cust_timer = 0
   self.initial_select_chips = false
end

function battle:update (input)
   if self.initial_select_chips then
      self:selectchips()
   end
   if input then
      local ending = self.entities:get_ending(self.state)
      if ending then
         scene.push(require 'battle/results', ending)
         return
      end

      if input[1].st == 1 or input[2].st == 1 then
         scene.push((require 'src/menu').new('pause'))
         return
      elseif self.cust_timer >= cust_length and
         (self.state.left.selectchips or self.state.right.selectchips)
      then
         self.state.left.selectchips = false
         self.state.right.selectchips = false
         self:selectchips()
         return
      end
      self.cust_timer = self.cust_timer + 1
   end
   self.stage:update(self.entities.entities)
   self.entities:update(input)
end

function battle:draw ()
   self.bg.draw()
   self.entities:draw() -- calls depthdraw
   self.stage:draw(self.state.stage.turf) -- calls depthdraw

   local cust_amount = self.cust_timer / cust_length
   depthdraw.draw()
   ui.draw(self.state, cust_amount)
end

return battle
