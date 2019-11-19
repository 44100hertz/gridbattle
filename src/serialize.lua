local serialize = {}

function serialize.write (filename, data)
   local output = {
      '--[==[ this file was generated ]==]--',
      'return {',
   }
   for k,v in pairs(data) do
      local vstr = type(v) == 'string' and "'" .. v .. "'" or v
      output[#output+1] = '    ' .. k .. ' = ' .. vstr .. ','
   end
   output[#output+1] = '}'
   output[#output+1] = ''
   local out_str = table.concat(output, '\n')
   local outfile = love.filesystem.newFile(filename, 'w')
   outfile:write(out_str)
   outfile:close()
end

function serialize.read (path)
   return love.filesystem.load(path)()
end

return serialize
