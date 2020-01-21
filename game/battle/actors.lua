local oop = require 'src/oop'
local aloader = require 'src/actor_loader'

local base_actor = require 'battle/base_actor'

local actors = oop.class()

function actors:init (battle)
   self.battle = battle

   self.actors = {}
   self.aloader = aloader(base_actor(battle), 'battle/actors/')
end

function actors:add (actor)
   actor = actor or {}
   actor.components = {}
   self.aloader:load(actor, actor.class)
   actor:init()
   table.insert(self.actors, actor)
   return actor
end

function actors:apply_damage (send, recv, amount)
   amount = amount or send.damage
   if recv.hp then
      recv.hp:adjust(-amount)
   end
end

-- Figure out if the battle has ended yet
-- Endings in order: win, lose, p1win, p2win
function actors:get_ending ()
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
   local loser = nil
   for i = 1,2 do
      if not sides[i].alive then
         loser = 3 - i
         break
      end
   end
   if loser then
      return two_player and 2 + loser or loser
   else
      return nil
   end
end

function actors:update (input)
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

   -- Collisions
   for _,actor in ipairs(self.actors) do
      local enemy = self.battle:locate_enemy(actor.pos, actor.side)
      if enemy then
         actor:collide(enemy)
         enemy:collide(actor)
      end
   end
end

function actors:draw ()
   for _,ent in ipairs(self.actors) do
      for _,component in ipairs(ent.components) do
         component:draw()
      end
      ent:_draw(false)
   end
end

return actors
