local test = require "res/battle/actors/testenemy"
local player = require "res/battle/actors/player"

return {
   stage = {
      turf = {3,3,3},
   },
   actors = {
      {class=player, x=2, y=2},
      {class=test, x=4, y=1},
      {class=test, x=4, y=2},
      {class=test, x=4, y=3},
      {class=test, x=5, y=1},
      {class=test, x=5, y=2},
      {class=test, x=5, y=3},
      {class=test, x=6, y=1},
      {class=test, x=6, y=2},
      {class=test, x=6, y=3},
   },
   bg=love.graphics.newImage("res/bg/test.png")
}
