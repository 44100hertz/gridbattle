local oop = require 'src/oop'
local folder = require 'src/folder'
local menu = require 'src/menu'
local actor_loader = require 'src/actor_loader'

local base_actor = require 'battle/base_actor'
local results = require 'battle/results'
local chip_artist = require 'battle/chip_artist'
local customize = require 'battle/customize/customize'
local ui = require 'battle/ui'

local savedata = require 'savedata'
local bg = require 'bg/bg'

local cust_length = 4*60

local battle = oop.class()

-- Return the panel at this x and y position
function battle:get_panel (pos)
   pos = pos:round()
   return self.stage[pos.x] and self.stage[pos.x][pos.y]
end

function battle:locate_actor (pos)
   for _,actor in ipairs(self.actors) do
      if actor.occupy_space and actor.pos:round() == pos:round() then
         return actor
      end
   end
   return nil
end

function battle:is_panel_free (pos)
   return not self:locate_actor(pos)
end

function battle:locate_enemy (pos, side)
   local tenant = self:locate_actor(pos)
   if tenant and tenant.side ~= side then
      return tenant
   else
      return nil
   end
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
   if pos.x > self.num_panels.x or pos.x < 1 or
      pos.y > self.num_panels.y or pos.y < 1
   then
      return nil
   else
      return pos.x > self.turf[pos.y] and 2 or 1
   end
end

function battle:add_actor (actor)
   actor = actor or {}
   actor.components = {}
   self.actor_loader:load(actor, actor.class)
   actor:init()
   table.insert(self.actors, actor)
   return actor
end

function battle:apply_damage (send, recv, amount)
   amount = amount or send.damage
   if recv.hp then
      recv.hp:adjust(-amount)
   end
end

function battle:request_select_chips()
   if self.cust_timer >= cust_length then
      self.will_select_chips = true
   end
end

-- Figure out if the battle has ended yet
-- Endings in order: win, lose, p1win, p2win
function battle:get_ending ()
   local sides = {{}, {}}
   for _,actor in ipairs(self.actors) do
      if actor.class == 'player' then
         sides[actor.side].has_player = true
      end
      if actor.is_fighter and not actor.despawn then
         sides[actor.side].alive = true
      end
   end

   local two_player = sides[1].has_player and sides[2].has_player
   local winner = nil
   if not sides[1].alive then winner = 2 end
   if not sides[2].alive then winner = 1 end
   if winner then
      return two_player and 2 + winner or winner
   else
      return nil
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
   self.actors = {}
   self.actor_loader = actor_loader(base_actor(self), 'battle/actors/')
   self.chip_artist = chip_artist()

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


   self.folders = {folder(savedata.player.folder)} -- HACK: just load this folder

   for _,actor in ipairs(battle_config.actors) do
      actor.side = self:get_side(actor.pos)
      self:add_actor(actor)
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
      local queues = {}
      GAME.scene:push(customize(self, self.folders, queues))
      for _,actor in pairs(self.actors) do
         if actor.class == 'player' then
            actor.queue:set_queue(queues[actor.side])
         end
      end
      self.cust_timer = 0
      self.will_select_chips = false
      return
   end
   local ending = self:get_ending(self.state)
   if ending then
      GAME.scene:push(results(ending))
      return
   end
   if input[1].st == 1 or input[2].st == 1 then
      GAME.scene:push(menu('pause'))
      return
   end

   self.cust_timer = self.cust_timer + 1
   for _,actor in ipairs(self.actors) do
      actor:update(input)
      actor.time = actor.time + 1

      if actor.hp and actor.hp:is_zero() or
         (actor.lifespan and actor.time >= actor.lifespan)
      then
         actor:die()
      end
   end
   for i,actor in ipairs(self.actors) do
      if actor.despawn then
         table.remove(self.actors, i)
      end
   end
   for _,actor in ipairs(self.actors) do
      local enemy = self:locate_enemy(actor.pos, actor.side)
      if enemy then
         actor:collide(enemy)
         enemy:collide(actor)
      end
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
   for _,ent in ipairs(self.actors) do
      for _,component in ipairs(ent.components) do
         component:draw()
      end
      ent:_draw(false)
   end

   local cust_amount = self.cust_timer / cust_length
   self.ui:draw(self.state, cust_amount)
end

return battle
