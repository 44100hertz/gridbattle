local oop = require 'src/oop'
local folder = require 'src/folder'
local menu = require 'src/menu'

local actors = require 'battle/actors'
local stage = require 'battle/stage'
local results = require 'battle/results'
local chip_artist = require 'battle/chip_artist'
local customize = require 'battle/customize/customize'

local savedata = require(PATHS.savedata)
local bg = require(PATHS.bg .. 'bg')
local ui =  require(PATHS.battle .. 'ui')

local cust_length = 4*60

local battle = oop.class()

function battle:init (set_name)
   self.state = dofile(PATHS.sets .. set_name .. '.lua')

   self.folders = {}
   for i = 1,2 do
      if self.state.sides[i].is_player then
         self.folders[i] = folder(savedata.player.folder)
      end
   end

   self.bg = bg(unpack(self.state.bg))
   self.ui = ui()

   self.stage = stage()
   self.actors = actors(self, 'battle/actors/')
   self.chip_artist = chip_artist()

   self.will_select_chips = true
   self.cust_timer = 0
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
            local q = {}
            self.state.sides[i].queue = q
            self.state.sides[i][1].queue = q
         end
      end
      GAME.scene:push(customize(self))
      self.cust_timer = 0
      self.will_select_chips = false
   elseif input then
      local ending = self.actors:get_ending(self.state)
      if ending then
         GAME.scene:push(results(ending))
         return
      end

      if input[1].st == 1 or input[2].st == 1 then
         GAME.scene:push(menu('pause'))
         return
      end
      self.cust_timer = self.cust_timer + 1
      self.stage:update(self.actors.actors)
      self.actors:update(input)
   end
end

function battle:draw ()
   self.bg:draw()
   self.stage:draw(self.state.stage.turf)
   self.actors:draw()

   local cust_amount = self.cust_timer / cust_length
   self.ui:draw(self.state, cust_amount)
end

return battle
