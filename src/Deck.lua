local Deck = {}

Deck.__index = Deck

-- Copy static deck data into a deck
function Deck:new(new_Deck)
   self = {chips={}, index=1}
   setmetatable(self, Deck)
   for k,v in ipairs(new_Deck) do self.chips[k] = v end
   return self
end

function Deck:shuffle()
   local shuffled = {}
   local len = #self.chips
   for i=1,len do
      -- Find a random place to put the next card
      local index = love.math.random(len)
      -- Move up until a free slot is found
      while(shuffled[index]) do
         index = (index % len) + 1
      end
      -- Place the card there
      shuffled[index] = self.chips[i]
   end
   self.chips = shuffled
end

-- Draw a deck, optionally fill a palette
function Deck:draw(num, palette)
   pal = palette or {}
   for i=1,num do
      if not pal[i] then
         pal[i] = self.chips[self.index]
         self.index = self.index + 1
      end
   end
   return pal
end

return Deck
