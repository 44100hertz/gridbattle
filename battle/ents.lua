local ents, images
local clear = function ()
   ents = {}
   images = {}
end
clear()

local player = {}
local enemy = {}
local anim = require "src/anim"
local depthdraw = require "src/depthdraw"
local text = require "src/text"
local stage = require "battle/stage"
local actors = require "battle/actors"

local getimage = function (img)
   if not images[img] then
      local imgpath = PATHS.battle .. "ents/" .. img .. ".png"
      images[img] = love.graphics.newImage(imgpath)
   end
   return images[img]
end

local add = function (class_name, variant_name, ent)
   ent = ent or {}
   class = require (PATHS.battle .. "ents/" .. class_name)

   -- Chain metatables for variants
   class.class.__index = class.class
   if variant_name then
      variant = class.variants[variant_name]
      if not variant then
         print("variant not found:", variant)
         return
      end
      variant.__index = variant
      setmetatable(variant, class.class)
      setmetatable(ent, variant)
   else
      setmetatable(ent, class.class)
   end

   local img
   if type(ent.img)=="string" then
      img = getimage(ent.img)
      ent.image = img
   end
   if ent.sheet then
      ent.sheet[7] = img:getWidth()
      ent.sheet[8] = img:getHeight()
      ent.anim = anim.sheet(unpack(ent.sheet))
   end

   if ent.states then actors.start(ent) end
   if ent.start then ent:start() end
   ent.time = 0
   ent.z = ent.z or 0
   if ent.tangible then
      stage.occupy(ent)
   end
   if ent.max_hp then ent.hp = ent.max_hp end

   table.insert(ents, ent)
   return ent
end

local apply_damage = function (ent, amount, element)
   if ent.hp then ent.hp = ent.hp - amount end
end

local get_enemy_names = function ()
   local names = {}
   for k,v in ipairs(enemy) do
      if not v.despawn then table.insert(names, v.name) end
   end
   return names
end

local get_ending = function ()
   if player.despawn then return "lose" end

   local enemies_alive
   for _,v in ipairs(ents) do
      if v.name then enemies_alive = true end
   end
   if not enemies_alive then return "win" end
end

local kill = function (ent)
   if ent.states and ent.states.die then
      actors.kill(ent)
   elseif ent.die then
      ent:die()
   else
      ent.despawn = true
   end
end

return {
   -- values
   player = player,

   -- functions
   add = add,
   kill = kill,
   apply_damage = apply_damage,
   get_enemy_names = get_enemy_names,
   get_ending = get_ending,

   start = function (set)
      for k,_ in pairs(player) do player[k] = nil end
      for k,v in pairs(set.player) do player[k] = v end
      player.side = "left"
      add("navi", "player", player)

      for k,_ in ipairs(enemy) do enemy[k] = nil end
      for i = 1,#set.enemy,3 do
	 local newenemy = {}
	 for k,v in pairs(set.enemy[i]) do newenemy[k] = v end
	 newenemy.name = set.enemy[i+1] .. set.enemy[i+2]
	 newenemy.side = "right"
         add(set.enemy[i+1], set.enemy[i+2], newenemy)
	 table.insert(enemy, newenemy)
      end
   end,

   update = function (input)
      for _,ent in ipairs(ents) do
         if ent.states then actors.update(ent, input) end
         if ent.update then ent:update(input) end

         if ent.hp and ent.hp <= 0 or
            ent.lifespan and ent.time == ent.lifespan
         then
            kill(ent)
         end

         if ent.dx then
            ent.real_dx = ent.side=="right" and -ent.dx or ent.dx
            ent.x = ent.x + ent.real_dx
         end
         if ent.dy then ent.y = ent.y + ent.dy end
         if ent.dz then ent.z = ent.z + ent.dz end

         ent.time = ent.time + 1
      end

      for i,ent in ipairs(ents) do
         if ent.despawn then table.remove(ents, i) end
      end

      local collide = function (a, b)
         if a.collide then a:collide(b) end
         if a.damage and b.hp then
            apply_damage(b, a.damage, a.element)
         end
         if a.collide_die and b.tangible then
            kill(a)
         end
      end

      for i = 1, #ents do
         -- Triangle-shaped iteration
         for j = i+1, #ents do
            local a = ents[i]
            local b = ents[j]
            if a.group ~= b.group and
               a.size and b.size
            then
               local size = a.size + b.size
               -- square collisions
               if math.abs(a.x - b.x) < size and
                  math.abs(a.y - b.y) < size
               then
                  collide(a, b)
                  collide(b, a)
               end
            end
         end
      end
   end,

   draw = function ()
      for i,ent in ipairs(ents) do
         if ent.states then actors.update_draw(ent) end
         depthdraw.add(ent)

         if ent.hp and not ent.hide_hp then
            depthdraw.add{
               x=ent.x, y=ent.y, z=ent.z+50,
               draw = function (_, x, y)
                  local hpstr = tostring(math.floor(ent.hp))
                  text.draw("hpnum", hpstr , x, y, "center")
               end
            }
         end
      end
   end,
}
