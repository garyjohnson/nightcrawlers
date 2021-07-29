require "global_vars"

Object = require "classic"
Terrain = Object:extend()

function Terrain:new()
  self.canvas = love.graphics.newCanvas(WIDTH, HEIGHT)
end

function Terrain:generate()
  self.canvas:renderTo(function() 
    love.graphics.clear(BACKGROUND)
    love.graphics.setColor(FOREGROUND)

    local maxDrift = 5
    local y = HEIGHT - (love.math.random() * (HEIGHT / 3)) - (HEIGHT / 6)

    for x = 0, WIDTH, 2 do
      love.graphics.rectangle('fill', x, y, 2, HEIGHT - y)
      y = y + ((love.math.random() * (maxDrift*2)) - maxDrift)
    end
  end);
end
