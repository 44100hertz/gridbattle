--[[
   The main loop of a battle
   Should be required as module when loading a new state
--]]

local state = require "src/state"
local input = require "src/input"
local bg = require "src/bg"

local battle = require "src/battle/battle"
local data = require "src/battle/data"

local fonts = require "res/fonts"

-- Collision function, assumed to be ran in both directions
local collide = function (o1, o2)
   if o1.damage and o2.hp then
      o2.hp = o2.hp - o1.damage
   end
   if o1.collide_die and o2.tangible then
      o1.despawn = true;
   end
end

-- Check all collisions.
local collide_check = function ()
   for i = 1, #data.actors do
      for j = i+1, #data.actors do -- triangle iteration
         local o1 = data.actors[i]
         local o2 = data.actors[j]
         if o1.group ~= o2.group and
            o1.size and o2.size
         then
            local size = o1.size + o2.size
            if math.abs(o1.x - o2.x) < size and -- square collisions
               math.abs(o1.y - o2.y) < size
            then
               collide(o1, o2)
               collide(o2, o1)
            end
         end
      end
   end
end

return {
   start = function (_, set)
      data.actors = {}

      -- Stage panels
      local turf = set.stage.turf
      for x = 1,data.stage.numx do
         data.stage[x] = {}
         for y = 1,data.stage.numy do
            local newpanel = {
               x=x, y=y,
               side = (x <= turf[y]) and "left" or "right"
            }
            data.stage[x][y] = newpanel
            battle.addactor(newpanel, require "res/battle/actors/panel")
         end
      end

      -- Any actors specified for level; enemies
      for i = 1,#set.actors,2 do
         local dup = {}
         for k,v in pairs(set.actors[i]) do dup[k] = v end
         battle.addactor(dup, set.actors[i+1])
      end

      bg.start(set.bg)
   end,

   update = function ()
      if input.st == 1 then
         state.push(require "res/menu/pause")
         return
      end

      for _,v in ipairs(data.actors) do
         -- Handle stateful actors' states
         if v.states then
            v.time = v.time + 1

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
         if v.stand then v.z = battle.getpanel(v.x, v.y).z + v.height end

         if v.dx then v.x = v.x + v.dx end
         if v.dy then v.y = v.y + v.dy end
         if v.dz then v.z = v.z + v.dz end
      end

      for k,v in ipairs(data.actors) do
         if v.despawn then table.remove(data.actors, k) end
      end

      collide_check()
   end,

   draw = function ()
      bg.draw()

      local depths = {}
      local depth_step = 0.5
      local min_depth = -100
      local max_depth = 100
      for _,v in ipairs(data.actors) do
         -- Calculate frame based on state
         if v.state then
            local frameindex =
               math.floor(v.time / v.state.speed) % #v.state.anim
            v.frame = v.state.anim[frameindex + 1]
         end

         -- Calculate depth based on position
         local depth = v.y+(v.z/40)
         min_depth = math.min(min_depth, depth)
         max_depth = math.max(max_depth, depth)
         local index = math.floor(depth / depth_step)
         if not depths[index] then depths[index] = {} end
         table.insert(depths[index], v)
      end

      for i = min_depth,max_depth do
         if depths[i] then
            for _,v in ipairs(depths[i]) do
               local x = data.stage.x + data.stage.w * v.x
               local y = data.stage.y + data.stage.h * v.y - v.z
               if v.draw then v:draw(x, y) end
               if v.frame then
                  love.graphics.draw(v.image, v.anim[v.frame], x, y)
               elseif v.image then
                  love.graphics.draw(v.image, x, y)
               end
               if v.hp then
                  love.graphics.setFont(fonts.tinyhp)
                  love.graphics.print(v.hp, x-15, y-30)
               end
            end
         end
      end
   end,
}
