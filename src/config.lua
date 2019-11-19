local oop = require 'src/oop'
local serialize = require 'src/serialize'

local config = {}

function config.new ()
   local self = oop.instance(config, {})
   -- Set up and create save path
   local savedir = love.filesystem.getSaveDirectory()
   self.path = savedir .. '/settings.conf'
   -- Setup and Load configuration
   self.default_settings = {
      game_scale = 3,
      poll_delay = 0,
   }
   print('loading config:', self.path)
   local settings = serialize.from_config(self.path)
   self.settings = oop.instance(self.default_settings, settings)
   self:set_window_scale()
   -- Write config if it does not exist
   if not love.filesystem.getInfo(self.path) then
      self:save()
   end
   return self
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
   serialize.to_config(self.path, self.settings)
end

function config:set_path (path)
   self.path = path
end

return config
