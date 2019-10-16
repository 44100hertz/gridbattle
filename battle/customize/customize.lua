local lg = love.graphics

local oop = require 'src/oop'
local scene = require 'src/scene'

local side = require 'battle/customize/side'

local two_player
local left,  right

return {
   transparent = true,
   queue = queue,

   start = function (bstate, left_deck, right_deck)
      left, right = nil, nil
      if left_deck.data then
         left = side.new(bstate.left.queue, left_deck, false)
      end
      if right_deck.data then
         right = side.new(bstate.right.queue, right_deck, true)
      end
      two_player = (left_deck.data and right_deck.data)
   end,

   update = function (_, input)
      if left then left:update(input) end
      if right then right:update(input) end
      if (not left or left.ready) and
         (not right or right.ready)
      then
         scene.pop()
         scene.push(require(PATHS.battle .. 'go_screen'))
      end
   end,

   draw = function ()
      if left then left:draw() end
      if right then right:draw() end
   end,
}
