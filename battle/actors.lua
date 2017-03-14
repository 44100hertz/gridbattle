--[[ Runs game ents and their state machines. It should make sense
   for most ents to use states, unless they're extremely simple.
--]]

-- In the future, this will use elements and such to calculate damage.

-- Put a stateful entity into a state by name
local enter_state = function (actor, state)
   if actor.states and actor.states[state] then
      actor.state = actor.states[state]
      actor.time = 0
   end
end

return {
   -- data
   player = player,
   -- fns
   add = add,
   damage = damage,
   clear = clear,

   start = function (set)
      --   enter_state(actor, "idle")
   end,

   update = function (input)
      for _,v in ipairs(actors) do
         -- Handle stateful actors' states
         if v.states then
            if v.enter_state then
               enter_state(v, v.enter_state)
               v.enter_state = nil
            end
            if v.state.act then v.state.act(v) end

            if v.state.iasa and
               v.time >= v.state.iasa * v.state.speed
            then
               v:act(input)
            end
            if v.state.length and
               v.time >= v.state.length * v.state.speed
            then
               enter_state(v, (v.state.finish or "idle"))
            end
         end

      end

      -- Despawn before collisions to reduce errors --
      for k,v in ipairs(actors) do
         if v.states and v.states.die then
            v.state = v.states.die
         else
            ent.despawn = true
         end
      end
   end,

   draw = function ()
      for _,v in ipairs(actors) do
         -- Calculate frame based on state
         if v.state then
            local frameindex =
               math.floor(v.time / v.state.speed) % #v.state.anim
            v.frame = v.state.anim[frameindex + 1]
         end

      end
   end,


}
