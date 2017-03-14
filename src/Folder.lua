local Folder = {}

Folder.__index = Folder

-- Copy static folder data into a folder
function Folder:new(new_Folder)
   self = {}
   setmetatable(self, Folder)
   for i,entry in ipairs(new_Folder) do
      self[i] = {}
      for k,v in pairs(entry) do
         self[i][k] = v
      end
   end
   return self
end

function Folder:find(entry)
   for i=1,#self do
      if self[i].name == entry.name and
         self[i].ltr == entry.ltr
      then
         return i
      end
   end
end

function Folder:insert(entry)
   self.temp_count = nil
   local i = self:find(entry)
   if i then
      self[i].qty = self[i].qty + 1
   else
      entry.qty = 1
      table.insert(self, entry)
   end
end

function Folder:remove(index)
   self.temp_count = nil
   if #self==0 then return end

   index = index or love.math.random(#self)
   local entry = self[index]
   entry.qty = entry.qty - 1
   if entry.qty==0 then table.remove(self, index) end
   return {name = entry.name, ltr = entry.ltr}
end

function Folder:count()
   if not self.temp_count then
      self.temp_count = 0
      for _,v in ipairs(self) do
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
