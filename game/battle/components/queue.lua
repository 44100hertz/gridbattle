local queue = {}

-- mode is one of:
---- 'user': will display a dialog to select chips
function queue:init (actor)
   self.actor = actor
   self:set_queue({})
end

function queue:use_chip ()
   if #self.queue>0 then
      local removed = table.remove(self.queue, 1)
      self.actor:use_chip(removed.name)
   end
end

function queue:set_queue (q)
   self.queue = q
end

function queue:draw ()
   local panel_height = self.actor.battle.stage.panel_size.y
   local queue_pos = self.actor:screen_pos() - point(0, panel_height * 0.7)
   self.actor.battle.chip_artist:draw_icon_queue(self.queue, queue_pos)
end

return queue
