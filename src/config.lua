local path = love.filesystem.getSaveDirectory() .. "/settings.conf"

local config = {
   gamescale = 3
}

set_gamescale = function (scale)
   if not scale then scale = config.gamescale end
   config.gamescale = scale
   love.window.setMode(GAME.width * scale,
                       GAME.height * scale)
end

local serialize = require "src/serialize"
load = function ()
   serialize.from_config(path, config)
   set_gamescale()
end

save = function ()
   serialize.to_config(path, config)
end

return {
   c = config,
   set_path = function (new_path) path = new_path end,
   set_gamescale = set_gamescale,
   load = load,
   save = save,
}
