stage = {}
player = {}

function love.load()
   stage.img = love.graphics.newImage('stage.png')
   player.img = love.graphics.newImage('ben.png')

   benWidth = player.img:getWidth()
   benHeight = player.img:getHeight()
   frame = love.graphics.newQuad(0, 0, 50, 62, benWidth, benHeight)
end

function love.draw()
   love.graphics.draw(stage.img, 0, 100, 0, 1, 1, 0, 0)
   love.graphics.draw(player.img, frame, 0, 0)
end
