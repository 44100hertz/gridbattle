local ents = require "battle/ents"

local use = function (actor, chip, variant)
   local added = ents.add(
      {x=actor.x, y=actor.y, parent=actor}, chip, variant)
   added.group = added.group or actor.group
   added.side = added.side or actor.side
end

local queue_use = function (actor)
   if #actor.queue>0 then
      local removed = table.remove(actor.queue, 1)
      use(actor, removed.name, removed.variant)
   end
end

return {
   use = use,
   queue_use = queue_use,
}
