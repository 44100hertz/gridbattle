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
   self.left = side.new(battle, 1)
   self.right = side.new(battle, 2)
   return self
end

function customize:update (input)
   if self.left then self.left:update(input) end
   if self.right then self.right:update(input) end
   if (not self.left or self.left.ready) and
      (not self.right or self.right.ready)
   then
      scene.pop()
      scene.push(require(PATHS.battle .. 'go_screen'))
   end
end

function customize:draw ()
   if self.left then self.left:draw() end
   if self.right then self.right:draw() end
end

return customize
