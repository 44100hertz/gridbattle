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

function Folder:find()
   for i=1,#list do
      if list[i].name == entry.name and
         list[i].ltr == entry.ltr
      then
         return i
      end
   end
end

function Folder:insert(entry)
   local i = self:find()
   if i then
      self[i].qty = self[i].qty + 1
   else
      table.insert(self, entry)
   end
end

function Folder:remove(index)
   if #self==0 then return end
   index = index or love.math.random(#self)
   local entry = self[index]
   entry.qty = entry.qty - 1
   if entry.qty==0 then table.remove(self, index) end
   return {[1] = entry.name, ltr = entry.ltr}
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
