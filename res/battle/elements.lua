local elems = {
   [1] = "wood",
   [2] = "fire",
   [3] = "water",
   [4] = "elec",
   [5] = "sword",
   [6] = "wind",
   [7] = "cursor",
   [8] = "breaker",
   [9] = "heal",
   [10] = "blocker",
}

local by_name = {}
for k,v in ipairs(elems) do
   by_name[v] = k
end

return {
   by_index = elems,
   by_name = by_name,

   interact = function (send_elem, recv_elem, amount, ent)
      ent.hp = ent.hp - amount
   end
}
