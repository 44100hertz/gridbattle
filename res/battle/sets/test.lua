local test = require "res/battle/actors/testenemy"

return {
   stage = {
      turf = {3,3,3},
   },
   playerpos = {x=2, y=2},
   actors = {
      {x=4, y=1}, test,
      {x=4, y=2}, test,
      {x=4, y=3}, test,
      {x=5, y=1}, test,
      {x=5, y=2}, test,
      {x=5, y=3}, test,
      {x=6, y=1}, test,
      {x=6, y=2}, test,
      {x=6, y=3}, test,
   },
   bg=love.graphics.newImage("res/bg/test.png")
}
