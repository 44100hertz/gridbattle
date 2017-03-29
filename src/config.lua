--local lfs = require "lfs"

--local path = love.filesystem.getSaveDirectory() .. "/settings.conf"
local SDL = require "SDL"
local path = "savedata/settings.conf"

local config = {
   gamescale = 3,
   polldelay = 0,
}

local set_gamescale = function (scale)
   if not scale then scale = config.gamescale end
   config.gamescale = scale
   local w,h = GAME.width * scale, GAME.height * scale
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

if not pcall(function () io.input(path) end) then save() end

return {
   c = config,
   set_path = function (new_path) path = new_path end,
   set_gamescale = set_gamescale,
   load = load,
   save = save,
}
