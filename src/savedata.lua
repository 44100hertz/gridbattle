local serialize = require "src/serialize"

return {
   load_folder = function (name, data)
      local out = love.filesystem.getWorkingDirectory() .. "/folders/" .. name
      data = data or {}
      serialize.from_config(out, data)
      return data
   end,

   save_folder = function (name, data)
      local outdir = love.filesystem.getWorkingDirectory() .. "/folders/"
      love.filesystem.createDirectory(outdir)
      serialize.to_config(outdir .. name, data)
   end,
}
