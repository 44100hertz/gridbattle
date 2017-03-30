local SDL = require "SDL"
local path = _G.PATHS.savedata .. "settings.conf"

local config = {}

local set_gamescale = function (scale)
   if not scale then scale = config.gamescale end
   config.gamescale = scale
   local w,h = _G.GAME.width * scale, _G.GAME.height * scale
   local bounds = SDL.getDisplayBounds(0)
   _G.WIN:setSize(w,h)
   _G.WIN:setPosition(bounds.w/2 - w/2, bounds.h/2 - h/2)
end

local serialize = require "src/serialize"
local load = function ()
   print("loading config:", path)
   serialize.from_config(path, config)
   set_gamescale()
end

local save = function ()
   print("saving config:", path)
   serialize.to_config(path, config)
end

return {
   c = config,
   set_path = function (new_path) path = new_path end,
   set_gamescale = set_gamescale,
   load = load,
   save = save,
}
