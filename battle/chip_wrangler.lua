local ents = require "battle/ents"
local chipdb = require(PATHS.root .. "chipdb")

local use = function (actor, chip_name)
   local chip = chipdb[chip_name]
   local added = ents.add(
      chip.class, chip.variant,
      {x=actor.x, y=actor.y, parent=actor})
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
