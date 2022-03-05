require "global_vars"
require "math_utils"
require "entity"

Terrain = Entity:extend()

function Terrain:new()
  Terrain.super.new(self)

  self.canvas = love.graphics.newCanvas(WIDTH, HEIGHT)
  self:generate()
end

function Terrain:draw()
  Terrain.super.draw(self)

  love.graphics.setColor(WHITE)
  love.graphics.draw(self.canvas)
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

  self.imageData = self.canvas:newImageData()
end

function Terrain:getEmptyYPosAbove(x, y, width)
  x = math.floor(x)
  y = math.floor(y)
  width = math.floor(width)

  if x < 0 or (x + width) >= WIDTH then
    print("x: " .. x)
    return nil
  end

  if y < 0 or y >= HEIGHT then
    print("y: " .. y)
    return nil
  end

  local yPos = y

  local anyFound = false

  while yPos > 0 do
    anyFound = false

    for xPos = x, (x + width) do
      if xPos < 0 or xPos >= WIDTH or yPos < 0 or yPos >= HEIGHT then
        print("bad position! xPos: " .. xPos .. " yPos: " .. yPos)
      end

      _,_,_,a = self.imageData:getPixel(xPos, yPos)
      if a > 0 then
        anyFound = true
        break
      end
    end

    if anyFound == false then
      return yPos
    end

    yPos = yPos - 1
  end

  return yPos
end

function Terrain:isColliding(x, y, width, height)
  x = math.floor(x)
  y = math.floor(y)
  width = math.floor(width)
  height = math.floor(height)

  if x < 0 or (x + width) >= WIDTH then
    return true
  end

  if y < 0 or (y + height) >= HEIGHT then
    return true
  end

  for yPos = (y+height), y, -1 do
    for xPos = x, (x+width) do
      _,_,_,a = self.imageData:getPixel(xPos, yPos)
      if a > 0 then
        return true
      end
    end
  end

  return false
end

function Terrain:findHighestYPoint(x, y, width, height)
  x = math.floor(x)
  y = math.floor(y)
  width = math.floor(width)
  height = math.floor(height)

  if x < 0 or (x + width) >= WIDTH then
    return nil
  end

  if y < 0 or y + height >= HEIGHT then
    return nil
  end

  local rowEmpty = true
  for yPos = (y+height), y, -1 do
    for xPos = x, (x+width) do
      _,_,_,a = self.imageData:getPixel(xPos, yPos)
      if a > 0 then
        rowEmpty = false
      end
    end

    if rowEmpty then
      return yPos
    end
  end

  return nil
end

function Terrain:hit(x, y, radius)
  x = math.floor(x)
  y = math.floor(y)
  radius = math.floor(radius)

  self.canvas:renderTo(function() 
    love.graphics.setBlendMode('replace')
    love.graphics.setColor({ 0, 0, 0, 0 })
    love.graphics.circle('fill', x, y, radius)
    love.graphics.setBlendMode('alpha')
  end);

  self.imageData = self.canvas:newImageData()
end
