local lg = love.graphics

local oop = require 'src/oop'

local go_screen = require 'battle/go_screen'
local side = require 'battle/customize/side'

local customize = oop.class {
   transparent = true,
}

function customize:init (battle)
--   local two_player = (left_deck.data and right_deck.data)
   self.sides = {}
   for i = 1,2 do
      if battle.folders[i] then
         self.sides[i] = side(battle, i)
      end
   end
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
      GAME.scene:pop()
      GAME.scene:push(go_screen())
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
