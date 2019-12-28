local oop = require 'src/oop'

local menu = {
   y = 60,
   spacing = 16,
   font = 'title',
   {},
   {
      text = 'save',
      a = oop.bind_by_name(GAME.config, 'save')
   },
   {
      text = 'exit',
      a = oop.bind_by_name(GAME.scene, 'pop')
   },
}

local game_scale = menu[1]

function menu:init()
   self[1]:update_text()
end

function game_scale:update_text()
   self.text = 'game_scale: ' .. GAME.config.settings.game_scale
end

function game_scale:dl ()
   GAME.config:adjust_game_scale(-1)
   self:update_text()
end

function game_scale:dr ()
   GAME.config:adjust_game_scale(1)
   self:update_text()
end

return menu
