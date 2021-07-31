require "global_vars"

Object = require "classic"
Terrain = Object:extend()

function Terrain:new()
  self.canvas = love.graphics.newCanvas(WIDTH, HEIGHT)
end

function Terrain:generate()
  self.canvas:renderTo(function() 
    love.graphics.clear({ 0,0,0,0 })

    local maxDrift = 5
    local y = HEIGHT - (love.math.random() * (HEIGHT / 3)) - (HEIGHT / 6)

    for x = 0, WIDTH, 2 do
      love.graphics.setColor(WHITE)
      love.graphics.rectangle('fill', x, y, 2, y+2)
      love.graphics.setColor(OFF_WHITE)
      love.graphics.rectangle('fill', x, y+2, 2, HEIGHT - y)
      y = y + ((love.math.random() * (maxDrift*2)) - maxDrift)
    end
  end);
end
