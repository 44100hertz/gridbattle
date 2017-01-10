local test = require "res/battle/actors/testenemy"
local player = require "res/battle/actors/player"

return {
   stage = {
      turf = {3,3,3},
   },
   actors = {
      {x=2, y=2}, player,
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
