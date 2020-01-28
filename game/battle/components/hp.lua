local hp = {
   max_width = 50,
}

function hp:init (actor, max_hp, props)
   self.actor = actor
   self.value = max_hp
   self.max = max_hp
   props = props or {}
   if props.ui then
      local element = {}
      element.column = self.actor.side
      element.align = 1
      element.size = point(self.max_width + 5, 20)
      function element.draw (_, pos)
         love.graphics.setColor(0,0,0)
         love.graphics.rectangle('fill', pos.x, pos.y, element.size:unpack())
         love.graphics.setColor(1,1,1)
         local hpstr = tostring(math.floor(self.value))
         love.graphics.printf(hpstr, pos.x, pos.y, self.max_width, 'center')
      end
      self.actor:add_ui_element(element)
   end
   if not props.hidden then
      self.draw = function ()
         local pos = self.actor:screen_pos()
         local panel_height = self.actor.battle.panel_size.y
         pos = pos - point(self.max_width/2, panel_height/2)
         local hpstr = tostring(math.floor(self.value))
         love.graphics.printf(hpstr, pos.x, pos.y, self.max_width, 'center')
      end
   end
end

function hp:set (value)
   self.value = math.max(math.min(value, self.max), 0)
end

function hp:adjust (value)
   self:set(self.value + value)
end

function hp:get ()
   return self.value
end

function hp:is_zero ()
   return self.value == 0
end

return hp
