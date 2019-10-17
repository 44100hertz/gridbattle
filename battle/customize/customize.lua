local lg = love.graphics

local oop = require 'src/oop'
local scene = require 'src/scene'

local side = require 'battle/customize/side'

local customize = {
   transparent = true,
}

function customize.new (bstate, left_deck, right_deck)
   local self = oop.instance(customize, {})
   two_player = (left_deck.data and right_deck.data)
   if left_deck.data then
      self.left = side.new(bstate.left.queue, left_deck, false, two_player)
   end
   if right_deck.data then
      self.right = side.new(bstate.right.queue, right_deck, true, two_player)
   end
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
