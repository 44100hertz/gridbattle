-- Put a stateful entity into a state by name
local enter_state = function (actor, state)
   actor.state = actor.states[state]
   actor.image:set_sheet(state)
   actor.time = 0
end

return {
   start = function (actor)
      enter_state(actor, 'base')
   end,

   update = function (actor, input)
      if actor.enter_state then
         enter_state(actor, actor.enter_state)
         actor.enter_state = nil
      end
      if actor.state then actor:state(actor) end

      if actor.image:get_interruptible() then
         actor:act(input)
      end
      if actor.image:get_over() then
         enter_state(actor, 'base')
      end
   end,

   kill = function (actor)
      enter_state(actor, 'die')
   end,
}
