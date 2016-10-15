require "test"
local game_state
local battle = require "battle/battle"

local game_size = {x=240, y=160}
canvas_scale = 4

function love.load()
   love.window.setMode(game_size.x * canvas_scale,
		       game_size.y * canvas_scale)

   game_state = battle
   battle.load()
end

function love.draw()
   game_state.draw()
end

function love.update(dt)
   game_state.update(dt)
end
