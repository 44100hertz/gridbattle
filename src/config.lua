local serialize = (require "src/serialize")

local config = {
   gamescale = 3
}

reload = function (path)
   if love.filesystem.exists(path) then
      serialize.from_config(path, config)
   else
      print("Creating default settings: " ..
               love.filesystem.getWorkingDirectory() .. path)
      serialize.to_config(path, config)
   end
end

return {
   c = config,
   reload = reload,
}
