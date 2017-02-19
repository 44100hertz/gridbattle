local serialize = require "src/serialize"

local conf = {
   hello = "world",
   [4] = 5,
   sub = {
      table = 0,
   }
}

return {
   dumpconf = function ()
      local strings = serialize.serialize(conf, "conf")
      for _,v in ipairs(strings) do
         print(v)
      end
   end,
}
