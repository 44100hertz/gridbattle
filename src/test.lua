function test_print_table(tab)
   local function table_recurse (key, value, indent)
      if type(value)=="table" then
	 if key then io.write(indent, tostring(key) , " = {\n") end
	 for k,v in pairs(value) do
	    table_recurse(k, v, indent .. "   ")
	 end
	 io.write(indent , "},\n")
      else
	 if type(key)=="number" then key="[" .. tostring(key) .. "]" end
	 io.write(indent, tostring(key), " = ", tostring(value), ",\n")
      end
   end

   print("table = {")
   table_recurse(_, tab, "")
end
