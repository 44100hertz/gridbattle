stage = {}

function love.load()
   stage.img = love.graphics.newImage('stage.png')
   
end

function love.draw()
   love.graphics.draw(stage.img, 0, 100, 0, 1, 1, 0, 0)
end
