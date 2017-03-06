--[[ Runs game actors and their state machines. It should make sense
   for most actors to use states, unless they're extremely simple.
--]]

local actors
local player = {}
local anim = require "src/anim"
local depthdraw = require "src/depthdraw"
local text = require "src/text"
local stage = require "src/battle/stage"
local images

-- In the future, this will use elements and such to calculate damage.
local damage = function (actor, amount)
   if actor.hp then actor.hp = actor.hp - amount end
end

-- Resource management for images
local getimage = function (img)
   if not images[img] then
      local imgpath = "res/battle/actors/" .. img .. ".png"
      images[img] = love.graphics.newImage(imgpath)
   end
   return images[img]
end

-- Put a stateful entity into a state by name
local enter_state = function (actor, state)
   if actor.states and actor.states[state] then
      actor.state = actor.states[state]
      actor.time = 0
   end
end

-- Prepare and add a new game entity
local add = function (actor, class, variant)
   -- Load the class and variant --
   if type(class)=="string" then
      class = require ("res/battle/actors/" .. class)
   end

   if variant then
      if type(variant)=="string" then
         variant = class.variants[variant]
      end

      -- Variant and class metatables --
      class.ent.__index = class.ent
      variant.__index = variant
      setmetatable(variant, class.ent)
      setmetatable(actor, variant)
   else
      class.__index = class
      setmetatable(actor, class)
   end

   -- Load the actor --
   local img
   if actor.img then
      img = getimage(actor.img)
      actor.image = img
   end
   if actor.sheet then
      -- apparently luaJIT (maybe even vanilla) unpack is weird.
      -- this is arguably the best way to stuff all the arguments in.
      actor.sheet[7] = img:getWidth()
      actor.sheet[8] = img:getHeight()
      actor.anim = anim.sheet(unpack(actor.sheet))
   end

   -- Actor state --
   enter_state(actor, "idle")
   if actor.start then actor:start() end
   actor.time = 0
   actor.z = actor.z or 0
   if actor.tangible then
      stage.occupy(actor)
   end
   if actor.max_hp then actor.hp = actor.max_hp end

   table.insert(actors, actor)
end

return {
   start = function (set)
      actors = {}
      images = {}
      for i = 1,#set.actors,2 do
         local dup = {}
         for k,v in pairs(set.actors[i]) do dup[k] = v end
         add(dup, set.actors[i+1])
      end
      player.side = "left"
      player.x=set.playerpos.x
      player.y=set.playerpos.y
      add(player, "navi", "player")
   end,

   update = function ()
      for _,v in ipairs(actors) do
         -- Handle stateful actors' states
         if v.states then
            if v.enter_state then
               enter_state(v, v.enter_state)
               v.enter_state = nil
            end
            if v.state.act then v.state.act(v) end

            if v.state.iasa and
               v.time >= v.state.iasa * v.state.speed
            then
               v:act()
            end
            if v.state.length and
               v.time >= v.state.length * v.state.speed
            then
               enter_state(v, (v.state.finish or "idle"))
            end
         end

         if v.update then v:update() end
         -- Death
         if v.hp and v.hp <= 0 then
            if v.die then v:die() end
            if v.states and v.states.die then
               v.state = v.states.die
            else
               v.despawn = true
            end
         end
         if v.lifespan and v.time >= v.lifespan then v.despawn=true end

         if v.dx then v.x = v.x + v.dx end
         if v.dy then v.y = v.y + v.dy end
         if v.dz then v.z = v.z + v.dz end

         v.time = v.time + 1
      end

      -- Despawn before collisions to reduce errors --
      for k,v in ipairs(actors) do
         if v.despawn then
            if v.tangible then stage.free(v.x, v.y) end
            table.remove(actors, k)
         end
      end

      -- Run this in both directions
      local collide = function (a, b)
         if a.collide then a:collide(b) end
         if a.damage and b.hp then
            damage(b, a.damage, a.element)
         end
         if a.collide_die and b.tangible then
            a.despawn = true;
         end
      end

      for i = 1, #actors do
         -- Triangle-shaped iteration
         for j = i+1, #actors do
            local a = actors[i]
            local b = actors[j]
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
      for _,v in ipairs(actors) do
         -- Calculate frame based on state
         if v.state then
            local frameindex =
               math.floor(v.time / v.state.speed) % #v.state.anim
            v.frame = v.state.anim[frameindex + 1]
         end

         depthdraw.add(v)

         if v.hp and not v.hide_hp then
            depthdraw.add({
                  x=v.x, y=v.y, z=v.z+50,
                  draw = function (_, x, y)
                     local hpstr = tostring(math.floor(v.hp))
                     x = x-(#hpstr*4)
                     text.draw("hpnum", hpstr , x, y)
                  end
            })
         end
      end
   end,

   player = player,
   add = add,
   damage = damage,
}
