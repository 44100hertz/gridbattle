--[[ Runs game actors and their state machines. It should make sense
   for most actors to use states, unless they're extremely simple.
--]]

local actors, player
local anim = require "src/anim"
local depthdraw = require "src/depthdraw"
local text = require "src/text"
local stage = require "src/battle/stage"
local images

local getimage = function (actor)
   if not images[actor.img] then
      local imgpath = "res/battle/actors/" .. actor.img .. ".png"
      images[actor.img] = love.graphics.newImage(imgpath)
   end
   actor.image = images[actor.img]
   return actor.image
end

local add = function (actor, class)
   if type(class)=="string" then
      class = require ("res/battle/actors/" .. class)
   end
   -- the two lines that enable OOP for game actors
   if not class.__index then class.__index = class end
   setmetatable(actor, class)

   table.insert(actors, actor)

   if actor.start then actor:start() end
   if actor.sheet then
      -- apparently luaJIT (maybe even vanilla) unpack is weird.
      -- this is arguably the best way to stuff all the arguments in.
      local img = getimage(actor)
      actor.sheet[7] = img:getWidth()
      actor.sheet[8] = img:getHeight()
      actor.anim = anim.sheet(unpack(actor.sheet))
   end
   if actor.states and actor.states.idle then
      actor.state = actor.states.idle
   end
   actor.time = 0
   actor.z = actor.z or 0
   if actor.tangible then
      stage.occupy(actor)
   end

   if actor.max_hp then actor.hp = actor.max_hp end
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
      player = {x=set.playerpos.x,
                y=set.playerpos.y,}
      add(player, "player")
   end,

   update = function ()
      for _,v in ipairs(actors) do
         -- Handle stateful actors' states
         if v.states then
            if v.enter_state then
               v.state = v.enter_state
               v.enter_state = nil
               v.time = 0
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
               v.state = v.state.finish
               v.time = 0
            end
         end

         if v.update then v:update() end
         -- Death
         if v.hp and v.hp <= 0 then
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

      for k,v in ipairs(actors) do
         if v.despawn then
            if v.tangible then stage.free(v.x, v.y) end
            table.remove(actors, k)
         end
      end

      -- Collision function, to be run in both directions
      local collide = function (o1, o2)
         if o1.damage and o2.hp then
            o2.hp = o2.hp - o1.damage
         end
         if o1.collide_die and o2.tangible then
            o1.despawn = true;
         end
      end

      for i = 1, #actors do
         -- Triangle-shaped iteration
         for j = i+1, #actors do
            local o1 = actors[i]
            local o2 = actors[j]
            if o1.group ~= o2.group and
               o1.size and o2.size
            then
               local size = o1.size + o2.size
               -- square collisions
               if math.abs(o1.x - o2.x) < size and
                  math.abs(o1.y - o2.y) < size
               then
                  collide(o1, o2)
                  collide(o2, o1)
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
                     local hpstr = tostring(v.hp)
                     x = x-(#hpstr*4)
                     text.draw("hpnum", hpstr , x, y)
                  end
            })
         end
      end
   end,

   player = function () return player end,
   add = add,
}
