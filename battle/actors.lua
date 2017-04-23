-- Put a stateful entity into a state by name
local enter_state = function (actor, state)
   if actor.states and actor.states[state] then
      actor.state = actor.states[state]
      actor.image.set_sheet(state)
      actor.time = 0
   end
end

return {
   start = function (actor)
      enter_state(actor, "base")
   end,

   update = function (actor, input)
      if actor.enter_state then
         enter_state(actor, actor.enter_state)
         actor.enter_state = nil
      end
      if actor.state then
         if actor.state.act then actor.state.act(actor) end

         if actor.state.iasa and
            actor.time >= actor.state.iasa * actor.state.speed
         then
            actor:act(input)
         end
         if actor.state.length and
            actor.time >= actor.state.length * actor.state.speed
         then
            enter_state(actor, (actor.state.finish or "idle"))
         end
      end
   end,

   kill = function (actor)
      enter_state(actor, "die")
   end,
}
