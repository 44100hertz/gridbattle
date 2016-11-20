local main = require "main"
local battle = require "battle/battle"
local input = require "input"
local test = require "test"

local time
local bg, bgquad

return {
   start = function (_, set)
      time = 0

      bg = set.bg
      bg:setWrap("repeat", "repeat")
      bgquad = love.graphics.newQuad(0, 0, 432, 272, 32, 32)

      battle.loadset(set)
   end,

   update = function ()
      if input.start == 1 then
	 main.pushstate(require "battle/pause")
	 return
      end
      battle.collide()
      battle.update()
      time = time + 1
   end,

   draw = function ()
      love.graphics.clear(100, 200, 150, 255)
      love.graphics.draw(bg, bgquad,
			 math.floor((time/2)%32-31.5), math.floor((time/2)%32-32))
      battle.draw()
   end,
}
