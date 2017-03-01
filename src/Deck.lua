local Deck = {}

Deck.__index = Deck

-- Copy static deck data into a deck
function Deck:new(new_Deck)
   self = self or {cards={}, index=1}
   setmetatable(self, Deck)
   for k,v in ipairs(new_Deck) do self.cards[k] = v end
   return self
end

function Deck:shuffle()
   local shuffled = {}
   local len = #self.cards
   for i=1,len do
      -- Find a random place to put the next card
      index = love.math.random(len)
      -- Move up until a free slot is found
      while(shuffled[index]) do
         index = (index % len) + 1
      end
      -- Place the card there
      shuffled[index] = self.cards[i]
   end
   self.cards = shuffled
end

-- Draw a deck, optionally fill a palette
function Deck:draw(num, palette)
   palette = palette or {}
   for i=1,num do
      if not palette[i] then
         draw[i] = self.cards[index]
         self.index = self.index + 1
      end
   end
   return palette
end

return Deck
