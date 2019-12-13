local oop = require 'src/oop'

local proto_ent = require 'battle/proto_ent'

local elements = require(PATHS.battle .. 'elements')

local entities = oop.class()

function entities:init (battle, entities_path)
   assert(battle.stage, 'must initialize battle stage first')
   self.battle = battle
   self.entities_path = entities_path
   self.proto_ent = proto_ent(battle)

   self.entities = {}
   self.entities_cache = {}
   for i = 1,2 do
     for _,entity in ipairs(battle.state.sides[i]) do
       entity.side = i
       if entity.name == 'player' then
          entity.queue = battle.state.sides[i].queue
       end
       self:add(entity)
     end
   end
end

function entities:add (ent)
   -- Class heirachy
   -- Object -> Class -> [Parent -> [Parent -> ...]] -> Entity
   local class = require (self.entities_path .. ent.name)
   local head = class
   setmetatable(ent, {__index = head})
   while head.extends do
      local extended = require(self.entities_path .. head.extends)
      setmetatable(head, {__index = extended})
      head = extended
   end
   setmetatable(head, {__index = self.proto_ent})
   ent:_load()

   table.insert(self.entities, ent)
   return ent
end

function entities:apply_damage (send, recv, amount)
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
function entities:get_ending ()
   local sides = self.battle.state.sides
   local two_player = sides[1].is_player and sides[2].is_player

   for i = 1,2 do
      sides[i].alive = false
      for _,entity in ipairs(sides[i]) do
         if not entity.despawn then
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

function entities:update (input)
   for i,ent in ipairs(self.entities) do
      ent:_update(input)
   end
   for i,ent in ipairs(self.entities) do
      if ent.despawn then
         ent:free_space()
         table.remove(self.entities, i)
      end
   end

   local function collide (a, b)
      if a.collide_die and b.tangible then a:die() end
      if b.collide_die and a.tangible then b:die() end
      if a.collide then a:collide(b) end
      if b.collide then b:collide(a) end
   end
   for _,ent in ipairs(self.entities) do
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

function entities:draw ()
   for _,ent in ipairs(self.entities) do
      ent:_draw()
   end
end

return entities
