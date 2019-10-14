local stage = require 'battle/stage'
local proto_ent = require 'battle/proto/ent'
local depthdraw = require 'src/depthdraw'
local image = require 'src/image'

local enemydb = require(PATHS.enemydb)
local elements = require(PATHS.battle .. 'elements')

local entity_list, images = {}, {}

local ents = {}

function ents.exit ()
   entity_list = {}
   images = {}
end

function ents.add (class_name, variant_name, ent)
   ent = ent or {}
   local class = require (PATHS.battle .. 'ents/' .. class_name)
   setmetatable(class.class, {__index = proto_ent})

   -- Chain metatables for variants
   class.class.__index = class.class
   if variant_name then
      local variant = class.variants[variant_name]
      if not variant then
         print('variant not found:', variant)
         return
      end
      variant.__index = variant
      setmetatable(variant, class.class)
      setmetatable(ent, variant)
   else
      setmetatable(ent, class.class)
   end

   if ent.img then
      ent.image = (require 'src/image').new(ent.img)
      ent.img = nil
   end

   ent.time = 0
   ent.z = ent.z or 0
   if ent.max_hp then ent.hp = ent.max_hp end
   ent:start()

   table.insert(entity_list, ent)
   return ent
end

ents.apply_damage = function (send, recv, amount)
   amount = amount or send.damage
   local recv_elem
   local panel = stage.getpanel(recv.x, recv.y)
   if panel and panel.stat and elements.by_name[panel.stat] then
      recv_elem = panel.stat
   else
      recv_elem = recv.elem
   end
   elements.interact(send.elem, recv_elem, amount, recv)
end

-- Figure out if the battle has ended yet
ents.get_ending = function (bstate)
   local results = {
      'p1win', 'win', 'lose', 'p2win',
   }
   local side_alive = function (tab, kind)
      if kind == 'player' then
         return not tab.despawn
      else
         for _,v in ipairs(tab) do
            if not v.despawn then return true end
         end
      end
   end
   local index = 1 +
      (bstate.left_kind=='player' and 2 or 0) +
      (bstate.right_kind=='player' and 1 or 0)
   if not side_alive(bstate.right, bstate.right_kind) then
      return results[5-index]
   elseif not side_alive(bstate.left, bstate.left_kind) then
      return results[index]
   end
end

function ents.ents () return entity_list end

function ents.start (bstate)
   local init_player = function (data, side)
      data.side = side
      ents.add('navi', 'player', data)
      return data
   end
   local init_enemies = function (data, side)
      for _,enemy in ipairs(data) do
         enemy.side = side
         local db_enemy = enemydb[enemy.name]
         ents.add(db_enemy.class, db_enemy.variant, enemy)
      end
      return data
   end

   if bstate.left_kind == 'player' then
      init_player(bstate.left, 'left')
   elseif bstate.left_kind == 'enemy' then
      init_enemies(bstate.left, 'left')
   end
   if bstate.right_kind == 'player' then
      init_player(bstate.right, 'right')
   elseif bstate.right_kind == 'enemy' then
      init_enemies(bstate.right, 'right')
   end
end

function ents.update (input)
   for i,ent in ipairs(entity_list) do
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
   for i,ent in ipairs(entity_list) do
      if ent.despawn then
         table.remove(entity_list, i)
      end
   end

   local collide = function (a, b)
      if a.collide_die and b.tangible then a:die() end
      if b.collide_die and a.tangible then b:die() end
      if a.collide then a:collide(b) end
      if b.collide then b:collide(a) end
   end
   stage.clear()
   for _,ent in ipairs(entity_list) do
      local panel = stage.getpanel(ent.x, ent.y)
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

function ents.draw ()
   for _,ent in ipairs(entity_list) do
      depthdraw.add(
         function (x,y)
            ent:draw(x, y)
            ent:draw_info(x, y)
         end,
         ent.x, ent.y, ent.z)
   end
end

return ents
