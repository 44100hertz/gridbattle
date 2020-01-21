local oop = require 'src/oop'
local folder = require 'src/folder'
local menu = require 'src/menu'

local actors = require 'battle/actors'
local results = require 'battle/results'
local chip_artist = require 'battle/chip_artist'
local customize = require 'battle/customize/customize'
local ui = require 'battle/ui'

local savedata = require 'savedata'
local bg = require 'bg/bg'

local cust_length = 4*60

local battle = oop.class()

function battle:get_panel (pos)
   -- Return the panel at this x and y position
   pos = (pos + 0.5):floor()
   return self.stage[pos.x] and self.stage[pos.x][pos.y]
end

function battle:is_panel_free (pos)
   local panel = self:get_panel(pos)
   return panel and not panel.tenant
end

function battle:locate_enemy (pos, side)
   local panel = self:get_panel(pos)
   return
      panel and
      panel.tenant and
      panel.tenant.side ~= side and panel.tenant
end

function battle:locate_enemy_ahead (pos, side)
   local inc = side==1 and 1 or -1
   repeat
      pos = pos + point(inc, 0)
      local enemy = self:locate_enemy(pos, side)
      if enemy then return enemy end
   until pos.x < 0 or pos.x > self.num_panels.x
end

function battle:get_side (pos)
   return pos.x > self.turf[pos.y] and 2 or 1
end

function battle:request_select_chips()
   if self.cust_timer >= cust_length then
      self.will_select_chips = true
   end
end

-- Transform:
-- 0,0                                        is the upper left corner.
-- stage.num_panels.x, stage.num_panels.y     is the lower right.
function battle:stage_pos_to_screen (pos)
   return pos * self.panel_size + (GAME.size - self.stage_size) * 0.5
end


function battle:init (set_name)
   local path = 'battle/battles/' .. set_name .. '.lua'

   -- general
   local battle_config = love.filesystem.load(path)()
   self.components = {}
   self.bg = bg(unpack(battle_config.bg))
   self.ui = ui()

   -- stage
   self.panel_size = point(48, 48)
   self.num_panels = point(6, 3)
   self.stage_size = self.panel_size * self.num_panels
   self.turf = battle_config.stage.turf
   self.stage = {}
   for x = 1,self.num_panels.x do
      self.stage[x] = {}
      for y = 1,self.num_panels.y do
         self.stage[x][y] = {}
      end
   end

   -- actors
   self.actors = actors(self, 'battle/actors/')
   self.chip_artist = chip_artist()

   self.folders = {folder(savedata.player.folder)} -- HACK: just load this folder

   for _,actor in ipairs(battle_config.actors) do
      actor.side = self:get_side(actor.pos)
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
   else
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

      -- Clear out panel tenants
      for x = 1,self.num_panels.x do
         for y = 1,self.num_panels.y do
            self.stage[x][y].tenant = nil
         end
      end
      for _,actor in ipairs(self.actors.actors) do
         if actor.occupy_space then
            local panel = self:get_panel(actor.pos)
            if panel then
               panel.tenant = actor
            end
         end
      end
      self.actors:update(input)
   end
end

function battle:draw ()
   self.bg:draw()

   -- draw stage
   for x = 1,self.num_panels.x do
      for y = 1,self.num_panels.y do
         local screen_pos = self:stage_pos_to_screen(point(x,y)-1)
         if x <= self.turf[y] then
            love.graphics.setColor(1, 0, 1, 0.5)
         else
            love.graphics.setColor(0, 0, 1, 128/256.0, 136/256.0, 0.5)
         end
         local w, h = self.panel_size:unpack()
         love.graphics.rectangle('fill', screen_pos.x, screen_pos.y, w, h, 5.0)
         love.graphics.setColor(32/256.0, 40/256.0, 56/256.0)
         love.graphics.rectangle('line', screen_pos.x, screen_pos.y, w, h, 5.0)
         love.graphics.setColor(1,1,1)
      end
   end
   self.actors:draw()

   local cust_amount = self.cust_timer / cust_length
   self.ui:draw(self.state, cust_amount)
end

return battle
