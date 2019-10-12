local stage = require 'battle/stage'
local set = require 'battle/set'
local proto_ent = require 'battle/proto/ent'
local depthdraw = require 'src/depthdraw'
local image = require 'src/image'

local enemydb = require(PATHS.enemydb)
local elements = require(PATHS.battle .. 'elements')

local ents, images
local clear = function ()
   ents = {}
   images = {}
end
clear()

local add = function (class_name, variant_name, ent)
   ent = ent or {}
   local class = require (PATHS.battle .. 'ents/' .. class_name)

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

   proto_ent.start(ent)
   if ent.start then ent:start() end

   table.insert(ents, ent)
   return ent
end

local apply_damage = function (send, recv, amount)
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

local results = {
   'p1win', 'win', 'lose', 'p2win',
}
local get_ending = function ()
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
      (set.left_kind=='player' and 2 or 0) +
      (set.right_kind=='player' and 1 or 0)
   if not side_alive(set.right, set.right_kind) then
      return results[5-index]
   elseif not side_alive(set.left, set.left_kind) then
      return results[index]
   end
end

return {
   add = add,
   exit = clear,
   apply_damage = apply_damage,
   get_ending = get_ending,
   ents = function () return ents end,

   start = function ()
      local init_player = function (data, side)
         data.side = side
         add('navi', 'player', data)
         return data
      end
      local init_enemies = function (data, side)
         for _,enemy in ipairs(data) do
            enemy.side = side
            local db_enemy = enemydb[enemy.name]
            add(db_enemy.class, db_enemy.variant, enemy)
         end
         return data
      end

      if set.left_kind == 'player' then
         init_player(set.left, 'left')
      elseif set.left_kind == 'enemy' then
         init_enemies(set.left, 'left')
      end
      if set.right_kind == 'player' then
         init_player(set.right, 'right')
      elseif set.right_kind == 'enemy' then
         init_enemies(set.right, 'right')
      end
   end,

   update = function (input)
      for i,ent in ipairs(ents) do
         proto_ent.update(ent, input)
      end
      for i,ent in ipairs(ents) do
         if ent.despawn then table.remove(ents, i) end
      end

      local collide = function (a, b)
         if a.damage and b.hp then apply_damage(a, b) end
         if b.damage and a.hp then apply_damage(b, a) end
         if a.collide_die and b.tangible then proto_ent.kill(a) end
         if b.collide_die and a.tangible then proto_ent.kill(b) end
         if a.collide then a:collide(b) end
         if b.collide then b:collide(a) end
      end
      stage.clear()
      for _,ent in ipairs(ents) do
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
   end,

   draw = function ()
      for _,ent in ipairs(ents) do
         depthdraw.add(function (x,y) proto_ent.draw(ent,x,y) end,
            ent.x, ent.y, ent.z)
      end
   end,
}
