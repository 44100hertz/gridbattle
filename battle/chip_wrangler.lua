local chipdb = require(PATHS.chipdb)

local use = function (actor, chip_name)
   local added = actor:spawn {name = chip_name, parent=actor, delay=8}
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
