local sanitize = function (str)
   str = string.gsub(str, '\\', '\\\\')
   str = string.gsub(str, '"', '\"')
   return '"' .. str .. '"'
end

return {
   -- Returns an array of strings representing the parts of a lua table
   --    containing anything other than functions.
   -- When printing, print a newline between each string for cleanliness,
   serialize = function (tab, name)
      local strings = {}

      local function table_recurse (key, value, indent)
         if type(value)=="table" then -- If subtable
            local str = string.format( -- Begin subtable
               "%s%s = {", indent, tostring(key)
            )
            table.insert(strings, str)

            for k,v in pairs(value) do -- Recurse over subtables
               table_recurse(k, v, indent .. "   ")
            end

            local endbrace = indent=="" and "}" or "},"
            str = string.format("%s%s", indent , endbrace) -- End subtable
            table.insert(strings, str)

         else -- If table entry
            if type(key)=="number" then -- Brackets around indices
               key="[" .. tostring(key) .. "]"
            end
            if type(value)=="string" then -- Quotes around strings
               value=sanitize(value)
            end
            local str = string.format( -- Key = Value
               "%s%s = %s,", indent, tostring(key), tostring(value)
            )
            table.insert(strings,  str)
         end
      end
      table_recurse(name, tab, "")

      return strings
   end,
}
