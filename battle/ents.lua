local lg = love.graphics

local anim = require "src/anim"
local depthdraw = require "src/depthdraw"
local text = require "src/text"
local stage = require "battle/stage"
local actors = require "battle/actors"

local enemydb = require(PATHS.enemydb)

local ents, images
local clear = function ()
   ents = {}
   images = {}
end
clear()

local player = {}
local enemies = {}

local getimage = function (img)
   if not images[img] then
      local imgpath = PATHS.battle .. "ents/" .. img .. ".png"
      images[img] = love.graphics.newImage(imgpath)
   end
   return images[img]
end

local add = function (class_name, variant_name, ent)
   ent = ent or {}
   local class = require (PATHS.battle .. "ents/" .. class_name)

   -- Chain metatables for variants
   class.class.__index = class.class
   if variant_name then
      local variant = class.variants[variant_name]
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
   for _,v in ipairs(enemies) do
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
   if ent.tangible then stage.free(ent.x, ent.y) end
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
   exit = clear,
   kill = kill,
   apply_damage = apply_damage,
   get_enemy_names = get_enemy_names,
   get_ending = get_ending,

   start = function (set)
      for k,_ in pairs(player) do player[k] = nil end
      if set.player then
         player.x, player.y = set.player.x, set.player.y
      else
         player.x, player.y = 2,2
      end
      player.side = "left"
      add("navi", "player", player)

      for k,_ in ipairs(enemies) do enemies[k] = nil end
      for _,set_enemy in ipairs(set.enemy) do
	 local newenemy = {
            name = set_enemy.name,
            x = set_enemy.x,
            y = set_enemy.y,
            side = "right",
         }
         local db_enemy = enemydb[set_enemy.name]
         add(db_enemy.class, db_enemy.variant, newenemy)
	 table.insert(enemies, newenemy)
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
      for _,ent in ipairs(ents) do
         if ent.states then actors.update_draw(ent) end
         local draw = function (raw_x, raw_y)
            local x = raw_x - (ent.ox or 0)
            local y = raw_y - (ent.oy or 0)
            local flip = ent.side=="right" and -1 or 1
            if ent.frame then
               local row = ent.state and ent.state.row or ent.row or 1
               lg.draw(ent.image, ent.anim[row][ent.frame], x, y, 0, flip, 1)
            elseif ent.image then
               lg.draw(ent.image, x, y)
            end
            if ent.draw then ent:draw(x, y) end
            if ent.hp and not ent.hide_hp then
               local hpstr = tostring(math.floor(ent.hp))
               text.draw("hpnum", hpstr, raw_x, y-10, "center")
            end
         end
         depthdraw.add(draw, ent.x, ent.y, ent.z)
      end
   end,
}
