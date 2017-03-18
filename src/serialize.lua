return {
   -- Writes things to a config file. These files are limited in that
   -- you cannot have string keys or values that consist entirely of
   -- numbers, and line breaks are required (no commas or semicolons).
   -- For syntax, look at program output, or look over this file.
   to_config = function (filename, tab)
      local o = io.output(filename)
      o:write([[
# This file has been automatically generated
# If you edit it, know what you're doing.
]])
      local print_table
      local indentstr = "    " -- indent with 4 spaces
      print_table = function (table, indent)
         for k,v in pairs(table) do
            o:write(indentstr:rep(indent)) -- apply indent
            if type(v) == "table" then
               o:write(k," = {\n") -- open scope k = {
               print_table(v, indent+1) -- re-iterate over things
               o:write(indentstr:rep(indent), "}\n") -- Close scope }
            else
               o:write(k," = ",v,"\n") -- For plain entries, just k = v
            end
         end
      end

      print_table(tab, 0) -- Start with indent level 0
      o:close()
   end,

   from_config = function (filename, tab)
      tab = tab or {}

      local scope = tab
      local upper_scope

      local i = io.input(filename)
      for line in i:lines() do
         -- %s* means any amount of whitespace (indents)
         if line:match("%s*#") then -- # comments
            goto continue
         end
         if line:match("%s*}") then -- } closing scope
            scope = upper_scope
            goto continue
         end
         -- [^ =]+ means "1 or more of anything but space or ="
         -- " ?= ?" means spaces between = are optional
         local k,v = line:match("%s*([^ =]+) ?= ?([^ =]+)")
         -- [^.%d] means anything not a digit or decimal place, so not
         -- matching it implies that there's only digits.
         if not k:match("[^.%d]") then k = tonumber(k) end
         if not v:match("[^.%d]") then v = tonumber(v) end
         if v=="{" then -- opening scope using "k = {"
            upper_scope = scope
            scope[k] = scope[k] or {} -- append entries if possible
            scope = scope[k]
            goto continue
         end
         scope[k] = v
         ::continue::
      end
      i:close()
      return tab
   end,
}
