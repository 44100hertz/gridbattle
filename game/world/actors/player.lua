local player = {}

function player:update (input)
   input = input[1]
   local longest_held = math.max(math.max(input.du, input.dd), math.max(input.dl, input.dr))
   local autofire = input.b > 0 and 5 or 15
   local delay = input.b > 0 and 2 or 5
   if longest_held % autofire == delay then
      local p = self.pos:copy()
      if input.du > 0 then p.y = p.y - 16 end
      if input.dd > 0 then p.y = p.y + 16 end
      if input.dl > 0 then p.x = p.x - 16 end
      if input.dr > 0 then p.x = p.x + 16 end
      if self:is_walkable(p) then
         self.pos = p
      end
   end
end

return player
