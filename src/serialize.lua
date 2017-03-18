return {
   -- Turn a shallow table into a config file
   to_config = function (filename, tab)
      local o = io.output(filename)
      o:write([[
# This file has been automatically generated
# If you edit it, know what you're doing.
]])
      local print_table
      local indentstr = "    "
      print_table = function (table, indent)
         for k,v in pairs(table) do
            o:write(indentstr:rep(indent))
            if type(v) == "table" then
               o:write(k," = {\n")
               print_table(v, indent+1)
               o:write(indentstr:rep(indent), "}\n")
            else
               o:write(k," = ",v,"\n")
            end
         end
      end

      print_table(tab, 0)
      o:close()
   end,

   from_config = function (filename, tab)
      tab = tab or {}

      local scope = tab
      local upper_scope

      local i = io.input(filename)
      for line in i:lines() do
         if line:match("%s*#") then
            goto continue
         end
         if line:match("%s*}") then
            scope = upper_scope
            goto continue
         end
         local k,v = line:match("%s*([^ =]+)[ ]?=[ ]?([^ =]+)")
         if not k:match("%a") then k = tonumber(k) end
         if not v:match("%a") then v = tonumber(v) end
         if v=="{" then
            upper_scope = scope
            scope = scope[k]
            scope = {}
            goto continue
         end
         scope[k] = v
         ::continue::
      end
      i:close()
      return tab
   end,
}
