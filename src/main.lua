local game_state = require "battle/battle"

function love.load()
   game_state.load()
end

function love.draw()
   game_state.draw()
end

function love.update(dt)
   game_state.update(dt)
end
