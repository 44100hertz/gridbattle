local oop = require 'src/oop'
local image = require 'src/image'

local proto_ent = require 'battle/proto_ent'

local elements = require(PATHS.battle .. 'elements')

local entities = {}

function entities.new (battle)
   local self = oop.instance(entities, {})

   assert(battle.stage, 'must initialize battle stage first')
   self.battle = battle
   self.proto_ent = proto_ent.new(battle)

   self.entities = {}
   for i = 1,2 do
     for _,entity in ipairs(battle.state.sides[i]) do
       entity.side = i
       if entity.name == 'player' then
          entity.queue = battle.state.sides[i].queue
       end
       self:add(entity)
     end
   end

   return self
end

function entities:add (ent)
   -- Class heirachy
   -- Object -> Class -> [Parent -> [Parent -> ...]] -> Entity
   local class = require (PATHS.battle .. 'ents/' .. ent.name)
   local head = class
   setmetatable(ent, {__index = head})
   while head.extends do
      local extended = require(PATHS.battle .. 'ents/' .. head.extends)
      setmetatable(head, {__index = extended})
      head = extended
   end
   setmetatable(head, {__index = self.proto_ent})

   if ent.start then ent:start() end

   ent.time = 0
   ent.z = ent.z or 0
   if ent.max_hp then ent.hp = ent.max_hp end

   if ent.img then
      ent.image = image.new(ent.img)
      ent.img = nil
   end

   if ent.after_image_load then ent:after_image_load() end -- HACK

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
function entities:get_ending ()
   local sides = self.battle.state.sides
   local two_player = sides[1].is_player and sides[2].is_player
   local endings = two_player and {'p2win', 'p1win'} or {'lose', 'win'}

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
         return endings[i]
      end
   end
end

function entities:update (input)
   for i,ent in ipairs(self.entities) do
      if ent.time then
         ent.time = ent.time + 1
      end
      ent:update(input)
      if ent.hp and ent.hp <= 0 or
         ent.lifespan and ent.time == ent.lifespan
      then
         ent:die()
      end
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
      local x, y = self.battle.stage:to_screen_pos(ent.x - 0.5, ent.y - 0.5)
      ent:draw(x, y)
      ent:draw_info(x, y)
   end
end

return entities
