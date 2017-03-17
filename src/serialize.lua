return {
   -- Turn a shallow table into a config file
   to_config = function (filename, tab)
      local o = io.output(filename)
      o:write("# This file has been automatically generated\n")
      for k,v in pairs(tab) do
         o:write(k," = ",v,"\n")
      end
      io.close(o)
   end,

   from_config = function (filename, tab)
      tab = tab or {}
      local i = io.input(filename)
      for line in i:lines() do
         if line:sub(1,1) == "#" then goto continue end
         local k,v = line:match("(%w+)[ ]?=[ ]?(%w+)")
         if not v:match("%a") then v = tonumber(v) end
         tab[k] = v
         ::continue::
      end
      io.close(i)
      return tab
   end,
}
