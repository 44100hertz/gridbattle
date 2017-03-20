local serialize = require "src/serialize"
local Folder = {
   asc_sort = {
      letter = function (a,b) return a.ltr > b.ltr end,
      alpha = function (a,b) return a.name > b.name end,
      quantity = function (a,b) return a.qty > b.qty end,
   },
   desc_sort = {
      letter = function (a,b) return a.ltr < b.ltr end,
      alpha = function (a,b) return a.name < b.name end,
      quantity = function (a,b) return a.qty < b.qty end,
   }
}

Folder.__index = Folder

function Folder:new()
   setmetatable(self, Folder)
   return self
end

function Folder:sort(method, is_ascending)
   local sortfn
   if is_ascending then
      sortfn = self.asc_sort[method]
   else
      sortfn = self.desc_sort[method]
   end
   table.sort(self.data, sortfn)
end

function Folder:condense()
   for i,a in ipairs(self.data) do
      for j = i+1,b do
         b = self.data[b]
         if a.name == b.name and
            a.ltr == b.ltr
         then
            a.qty = a.qty + b.qty
            b.qty = 0
         end
      end
   end
   for i,v in ipairs(self.data) do
      if v.qty == 0 then table.remove(self.data, v) end
   end
end

-- Copy static folder data into a folder
function Folder:load(name)
   self.name = name
   local input = love.filesystem.getSaveDirectory() ..
      "/folders/" .. name
   if not pcall(function () io.input(input) end) then
      input = PATHS.folders .. name
   end
   self.data = serialize.from_config(input)
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
      table.insert(self.data, entry)
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
