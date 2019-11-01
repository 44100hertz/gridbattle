local lg = love.graphics

local oop = require 'src/oop'
local scene = require 'src/scene'

local side = require 'battle/customize/side'

local customize = {
   transparent = true,
}

function customize.new (battle)
   local self = oop.instance(customize, {})
--   local two_player = (left_deck.data and right_deck.data)
   self.sides = {}
   for i = 1,2 do
      self.sides[i] = side.new(battle, i)
   end
   return self
end

function customize:update (input)
   for i = 1,2 do
      if self.sides[i] then
         self.sides[i]:update(input)
      end
   end
   -- Exit customize? Check that both sides are ready
   local exit_scene = true
   for i = 1,2 do
      if self.sides[i] and not self.sides[i].ready then
         exit_scene = false
      end
   end
   if exit_scene then
      scene.pop()
      scene.push(require(PATHS.battle .. 'go_screen'))
   end
end

function customize:draw ()
   for i = 1,2 do
      if self.sides[i] then
         self.sides[i]:draw()
      end
   end
end

return customize
