local oop = require 'src/oop'
local aloader = require 'src/actor_loader'

local base_actor = require 'battle/base_actor'

local elements = require(PATHS.battle .. 'elements')

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

function actors:add (actor)
   self.aloader:load(actor, actor[1])
   actor:_load()
   table.insert(self.actors, actor)
   return actor
end

function actors:apply_damage (send, recv, amount)
   amount = amount or send.damage
   local recv_elem
   local panel = self.battle.stage:getpanel(recv.x, recv.y)
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
   for i,ent in ipairs(self.actors) do
      ent:_update(input)
   end
   for i,ent in ipairs(self.actors) do
      if ent.despawn then
         ent:free_space()
         table.remove(self.actors, i)
      end
   end

   local function collide (a, b)
      if a.collide_die and b.tangible then a:die() end
      if b.collide_die and a.tangible then b:die() end
      if a.collide then a:collide(b) end
      if b.collide then b:collide(a) end
   end
   for _,ent in ipairs(self.actors) do
      local panel = self.battle.stage:getpanel(ent.x, ent.y)
      if panel and panel.tenant and
         panel.tenant.tangible and
         panel.tenant.side ~= ent.side
      then
         collide(ent, panel.tenant)
      elseif panel and ent.tangible then
         panel.tenant = ent
      end
   end
end

function actors:draw ()
   for _,ent in ipairs(self.actors) do
      ent:_draw()
   end
end

return actors
