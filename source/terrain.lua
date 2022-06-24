import "CoreLibs/object"
import "CoreLibs/graphics"
import "global_vars"
import "math_utils"
import "entity"
import "bayer"

local gfx <const> = playdate.graphics

class('Terrain').extends(Entity)

function Terrain:init()
  Terrain.super.init(self)

  self.levelWidth = 1000
  self.levelHeight = 300

  self:setCenter(0, 0)
  self:setOriginalImage(self:generateImage())
end

function Terrain:generateImage()
  local image = gfx.image.new(self.levelWidth, self.levelHeight)

  gfx.pushContext(image)
  gfx.clear(gfx.kColorClear)

  local maxDrift = 5
  local y = self.levelHeight - (math.random() * (self.levelHeight / 3)) - (self.levelHeight / 6)

  for x = 0, self.levelWidth, 2 do
    gfx.setColor(gfx.kColorBlack)
    gfx.fillRect(x, y, 2, y+2)
    gfx.setPattern(bayer.getFill(10))
    gfx.fillRect(x, y+2, 2, self.levelHeight - y)
    y = y + ((math.random() * (maxDrift*2)) - maxDrift)
  end
  gfx.popContext()

  return image
end

function Terrain:getEmptyYPosAbove(x, y, width)
  x = math.floor(x)
  y = math.floor(y)
  width = math.floor(width)

  if x < 0 or (x + width) >= self.levelWidth then
    print("x: " .. x)
    return nil
  end

  if y < 0 or y >= self.levelHeight then
    print("y: " .. y)
    return nil
  end

  local yPos = y

  local anyFound = false

  while yPos > 0 do
    anyFound = false

    for xPos = x, (x + width) do
      if xPos < 0 or xPos >= self.levelWidth or yPos < 0 or yPos >= self.levelHeight then
        print("bad position! xPos: " .. xPos .. " yPos: " .. yPos)
      end

      if self:getOriginalImage():sample(xPos, yPos) ~= gfx.kColorClear then
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

  if x < 0 or (x + width) >= self.levelWidth then
    return true
  end

  if y < 0 or (y + height) >= self.levelHeight then
    return true
  end

  for yPos = (y+height), y, -1 do
    for xPos = x, (x+width) do
      if self:getOriginalImage():sample(xPos, yPos) ~= gfx.kColorClear then
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

  if x < 0 or (x + width) >= self.levelWidth then
    print("x nopes")
    return nil
  end

  if y < 0 or (y + height) >= self.levelHeight then
    print("y nopes")
    return nil
  end

  local rowEmpty = true
  for yPos = y+height, y, -1 do
    for xPos = x, (x+width) do
      if self:getOriginalImage():sample(xPos, yPos) ~= gfx.kColorClear then
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

  gfx.pushContext(self:getOriginalImage())
  gfx.setColor(gfx.kColorClear)
  gfx.fillCircleAtPoint(x, y, radius)
  gfx.popContext()

  gfx.sprite.addDirtyRect(x-radius, y-radius, x+radius, y+radius)

  self:updateTransformedImage()
end
