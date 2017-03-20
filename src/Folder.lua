local serialize = require "src/serialize"
local Folder = {}

Folder.__index = Folder

function Folder:new()
   self.data = {}
   setmetatable(self, Folder)
   return self
end

-- Copy static folder data into a folder
function Folder:load(name)
   self.name = name
   local input = love.filesystem.getSaveDirectory() ..
      "/folders/" .. name
   if not pcall(function () io.input(input) end) then
      input = PATHS.folders .. name
   end
   self.data = {}
   serialize.from_config(input, self.data)
   setmetatable(self, Folder)
   return self
end

function Folder:save(name)
   if name then self.name = name end
   local outdir = "folders/"
   love.filesystem.createDirectory(outdir)
   serialize.to_config(
      love.filesystem.getSaveDirectory()
         .. "/" .. outdir .. self.name, self.data)
end

function Folder:find(entry)
   for i=1,#self.data do
      if self.data[i].name == entry.name and
         self.data[i].ltr == entry.ltr
      then
         return i
      end
   end
end

function Folder:insert(entry)
   local i = self:find(entry)
   if i then
      self.data[i].qty = self.data[i].qty + 1
   else
      entry.qty = 1
      table.insert(self, entry)
   end
end

function Folder:remove(index)
   index = index or love.math.random(#self.data)
   local entry = self.data[index]
   if not entry then
      print("tried to remove nonexistant index:", index)
      return
   end
   entry.qty = entry.qty - 1
   if entry.qty==0 then table.remove(self.data, index) end
   return {name = entry.name, ltr = entry.ltr}
end

function Folder:count()
   local count = 0
   for _,v in ipairs(self.data) do
      count = count + v.qty
   end
   return count
end

-- Draw a folder, optionally fill a palette
function Folder:draw(num, pal)
   pal = pal or {}
   for i=1,num do
      if not pal[i] then
         pal[i] = self:remove()
      end
   end
   return pal
end

return Folder
