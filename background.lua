require "global_vars"

Object = require "classic"
Background = Object:extend()

function Background:new()
  self.canvas = love.graphics.newCanvas(WIDTH, HEIGHT)

  self.step = 1
  self.startValue = 0.10
  self.endValue = 0
  self.startY = 0
  self.endY = HEIGHT/2.5

  self:generate()
end

function Background:generate()
  self.canvas:renderTo(function() 
    love.graphics.clear({ 0,0,0,0 })

    local range = self.endValue - self.startValue
    local heightRange = self.endY - self.startY
    local stepValue = range / (heightRange / self.step)
    local colorValue = 0

    love.graphics.setColor({ self.startValue, self.startValue, self.startValue })
    love.graphics.rectangle('fill', 0, 0, WIDTH, 0 + self.startY)

    love.graphics.setColor({ self.endValue, self.endValue, self.endValue })
    love.graphics.rectangle('fill', 0, self.endY, WIDTH, HEIGHT - self.endY)

    for y = self.startY, heightRange, self.step do
      colorValue = self.startValue + (stepValue * (y/self.step))
      love.graphics.setColor({ colorValue, colorValue, colorValue })
      love.graphics.rectangle('fill', 0, y, WIDTH, y + self.step)
    end
  end);
end
