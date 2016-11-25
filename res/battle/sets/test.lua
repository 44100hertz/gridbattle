local test = require "res/battle/actors/testenemy"

return {
   stage = {
      turf = {3,3,3},
      spawn = {x=2, y=2},
   },
   actors = {
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
