local oop = require 'src/oop'
local serialize = require 'src/serialize'

local config = oop.class()

function config:init ()
   -- Set up and create save path
   self.path = 'settings.lua'
   -- Setup and Load configuration
   self.default_settings = {
      game_scale = 3,
      poll_delay = 0,
   }
   -- Write config if it does not exist
   if not love.filesystem.getInfo(self.path) then
      serialize.write(self.path, self.default_settings)
  end
   print('loading config:', self.path)
   local settings = serialize.read(self.path)
   self.settings = setmetatable(settings, {__index = self.default_settings})
   self:set_window_scale()
end

function config:set_window_scale ()
   love.window.setMode(GAME.width * self.settings.game_scale,
                       GAME.height * self.settings.game_scale)
end

function config:adjust_game_scale (delta)
   self.settings.game_scale = self.settings.game_scale + delta
   self:set_window_scale()
end

function config:save ()
   print('saving config:', self.path)
   serialize.write(self.path, self.settings)
end

function config:set_path (path)
   self.path = path
end

return config
