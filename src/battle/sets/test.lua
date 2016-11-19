local test = require "battle/actors/test"

local stage = {
   turf = {3,3,3},
   spawn = {x=2, y=2},
}

local actors = {
   {class=test, x=5, y=2, z=1},
}

return {stage=stage, actors=actors}
