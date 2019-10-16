local chipdb = require(PATHS.chipdb)

local use = function (actor, chip_name)
   local chip = chipdb[chip_name]
   local added = actor:spawn(
      chip.class, chip.variant, {parent=actor, delay=8})
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
