local serialize = require "src/serialize"

local Folder = {}

Folder.__index = Folder

function Folder:new()
   setmetatable(self, Folder)
   return self
end

local chipdb = require(PATHS.chipdb)
local fetch_methods = {
   ltr = function (o) return o.ltr end,
   name = function (o) return o.name end,
   qty = function (o) return -o.qty end,
   elem = function (o) return chipdb[o.name].elem end,
}
local compare_lists = {
   letter = {"ltr", "name"},
   name = {"name", "ltr"},
   quantity = {"qty", "ltr", "name"},
   element = {"elem", "ltr", "name"},
}

function Folder:sort(method, is_ascending)
   if self.lastsort == method then
      is_ascending = true
      self.lastsort = nil
   else
      self.lastsort = method
   end

   local sort_list = compare_lists[method]
   local compare = function (a,b)
      if is_ascending then a,b = b,a end
      for _,sortby in ipairs(sort_list) do
         local fetchval = fetch_methods[sortby]
         local a_val,b_val = fetchval(a), fetchval(b)
         if a_val < b_val then return true end
         if a_val > b_val then return false end
      end
      return false
   end

   table.sort(self.data, compare)
end

function Folder:condense()
   for i,a in ipairs(self.data) do
      for _ = i+1,#self.data do
         local b = self.data[b]
         if a.name == b.name and
            a.ltr == b.ltr
         then
            a.qty = a.qty + b.qty
            b.qty = 0
         end
      end
   end
   for _,v in ipairs(self.data) do
      if v.qty == 0 then table.remove(self.data, v) end
   end
end

-- Copy static folder data into a folder
function Folder:load(name)
   self.temp_count = nil
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
   self.temp_count = nil
   local i = self:find(entry)
   if i then
      self.data[i].qty = self.data[i].qty + 1
   else
      entry.qty = 1
      table.insert(self.data, entry)
   end
end

function Folder:remove(index)
   self.temp_count = nil
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
   if not self.temp_count then
      self.temp_count = 0
      for _,v in ipairs(self.data) do
         self.temp_count = self.temp_count + v.qty
      end
   end
   return self.temp_count
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
