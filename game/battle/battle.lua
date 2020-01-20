local oop = require 'src/oop'
local folder = require 'src/folder'
local menu = require 'src/menu'

local actors = require 'battle/actors'
local stage = require 'battle/stage'
local results = require 'battle/results'
local chip_artist = require 'battle/chip_artist'
local customize = require 'battle/customize/customize'
local ui = require 'battle/ui'

local savedata = require 'savedata'
local bg = require 'bg/bg'

local cust_length = 4*60

local battle = oop.class()

function battle:init (set_name)
   local path = 'battle/battles/' .. set_name .. '.lua'
   self.state = love.filesystem.load(path)()
   self.components = {}
   self.bg = bg(unpack(self.state.bg))
   self.ui = ui()
   self.stage = stage(self.state.stage.turf)
   self.actors = actors(self, 'battle/actors/')
   self.chip_artist = chip_artist()

   self.folders = {folder(savedata.player.folder)} -- HACK: just load this folder

   for _,actor in ipairs(self.state.actors) do
      actor.side = self.stage:get_side(actor.pos)
      self.actors:add(actor)
   end

   self.will_select_chips = true
   self.cust_timer = 0
end

function battle:get_component (name)
   if not self.components[name] then
      self.components[name] = dofile('battle/components/' .. name .. '.lua')
   end
   return self.components[name]
end

function battle:request_select_chips()
   if self.cust_timer >= cust_length then
      self.will_select_chips = true
   end
end

function battle:update (input)
   if self.will_select_chips then
      self.queues = {}
      GAME.scene:push(customize(self, self.folders, self.queues))
      for _,actor in pairs(self.actors.actors) do
         if actor.class == 'player' then
            actor.queue:set_queue(self.queues[actor.side])
         end
      end
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
--      self.stage:update(self.actors.actors)
      self.actors:update(input)
   end
end

function battle:draw ()
   self.bg:draw()
   self.stage:draw()
   self.actors:draw()

   local cust_amount = self.cust_timer / cust_length
   self.ui:draw(self.state, cust_amount)
end

return battle
