local test = require "battle/actors/test"

return {
   stage = {
      turf = {3,3,3},
      spawn = {x=2, y=2},
   },
   actors = {
      {class=test, x=5, y=2, z=1},
   },
   bg=love.graphics.newImage("img/battle/bg/test.png")
}
