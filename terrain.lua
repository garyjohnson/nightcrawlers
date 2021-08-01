require "global_vars"
require "math_utils"

Object = require "classic"
Terrain = Object:extend()

function Terrain:new()
  self.canvas = love.graphics.newCanvas(WIDTH, HEIGHT)
  self:generate()

  self.cachedYPoints = {}
end

function Terrain:generate()
  self.cachedYPoints = {}

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

  self.imageData = self.canvas:newImageData()
end

function Terrain:findHighestYPoint(x, width)
  if x < 0 or (x + width) > (WIDTH - 1) then
    return HEIGHT
  end

  local cachedValue = self.cachedYPoints["" .. x .. ":" .. (x+width)]
  if cachedValue then
    return cachedValue
  end

  local min = 0
  local max = HEIGHT

  local r,g,b,a = 0
  local mid = 0
  local anyFound, anyAbove = false

  while min <= max do
    anyFound, anyAbove = false
    mid = math.floor((max+min)/2)

    if (mid - 1) < 0 or mid >= HEIGHT then
      mid = clamp(0, mid, HEIGHT)
      break
    end

    for xPos = x, (x+width) do
      _,_,_,aboveA = self.imageData:getPixel(x, mid-1)
      _,_,_,a = self.imageData:getPixel(x, mid)
      if aboveA > 0 then
        anyAbove = true
      end
      if a > 0 then
        anyFound = true
      end
    end

    if anyFound and not(anyAbove) then
      break
    end

    if anyFound then
      max = mid-1
    else
      min = mid+1
    end
  end

  self.cachedYPoints["" .. x .. ":" .. (x+width)] = mid-1
  return mid-1
end
