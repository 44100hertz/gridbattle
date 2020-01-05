local oop = require 'src/oop'
local aloader = require 'src/actor_loader'

local base_actor = require 'battle/base_actor'
local elements = require 'battle/elements'

local actors = oop.class()

function actors:init (battle, actors_path)
   self.battle = battle
   self.actors_path = actors_path

   self.actors = {}
   self.aloader = aloader(base_actor(battle), actors_path)
   for i = 1,2 do
     for _,actor in ipairs(battle.state.sides[i]) do
       actor.side = i
       if actor[1] == 'player' then
          actor.queue = battle.state.sides[i].queue
       end
       self:add(actor)
     end
   end
end

function actors:add (actor, pos)
   actor.pos = pos or point(actor[2], actor[3])
   self.aloader:load(actor, actor[1])
   actor.components = {}
   actor:init()
   table.insert(self.actors, actor)
   return actor
end

function actors:apply_damage (send, recv, amount)
   amount = amount or send.damage
   local recv_elem
   local panel = self.battle.stage:get_panel(recv.pos)
   if panel and panel.stat and elements.by_name[panel.stat] then
      recv_elem = panel.stat
   else
      recv_elem = recv.elem
   end
   elements.interact(send.elem, recv_elem, amount, recv)
end

-- Figure out if the battle has ended yet
-- Endings in order: win, lose, p1win, p2win
function actors:get_ending ()
   local sides = self.battle.state.sides
   local two_player = sides[1].is_player and sides[2].is_player

   for i = 1,2 do
      sides[i].alive = false
      for _,actor in ipairs(sides[i]) do
         if not actor.despawn then
            sides[i].alive = true
            break
         end
      end
   end

   for i = 1,2 do
      if not sides[i].alive then
         local loser = i == 1 and 2 or 1
         return two_player and 2+loser or loser
      end
   end
end

function actors:update (input)
   for _,ent in ipairs(self.actors) do
      ent:_update(input)
   end
   for i,actor in ipairs(self.actors) do
      if actor.despawn then
         actor:free_panel()
         table.remove(self.actors, i)
      end
   end

   -- Collisions
   for _,actor in ipairs(self.actors) do
      local enemy = actor:locate_enemy()
      if enemy then
         actor:collide(enemy)
         enemy:collide(actor)
      end
   end
end

function actors:draw ()
   for _,ent in ipairs(self.actors) do
      for _,component in ipairs(ent.components) do
         component:draw(ent)
      end
      ent:_draw(false)
   end
end

return actors
