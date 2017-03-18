local serialize = require "src/serialize"

return {
   save_folder = function (name, data)
      local outdir = "folders/"
      local success = love.filesystem.createDirectory(outdir)
      serialize.to_config(love.filesystem.getSaveDirectory()
                             .. "/" .. outdir .. name, data)
   end,

   load_folder = function (name)
      local out = love.filesystem.getSaveDirectory() .. "/folders/" .. name
      return serialize.from_config(out)
   end,
}
