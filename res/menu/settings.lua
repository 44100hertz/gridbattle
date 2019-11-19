local oop = require 'src/oop'
local scene = require 'src/scene'

local menu = {
   y = 60, spacing = 16,
   font = 'title',
   [1] = {},
   [2] = {'save', a = oop.bind_by_name(GAME.config, 'save')},
   [3] = {'exit', a = scene.pop},
}

local game_scale = menu[1]

-- function menu.new()
--    local self = oop.instance(menu)
--    menu:update_text()
--    return self
-- end

function game_scale:update_text()
   self[1] = 'game_scale: ' .. GAME.config.settings.game_scale
end

function game_scale:dl ()
   GAME.config:adjust_game_scale(-1)
   self:update_text()
end

function game_scale:dr ()
   GAME.config:adjust_game_scale(1)
   self:update_text()
end

game_scale:update_text()

return menu
