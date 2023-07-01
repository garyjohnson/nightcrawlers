import "CoreLibs/object"
import "CoreLibs/graphics"
import "global_vars"
import "math_utils"
import "entity"
import "lib/bayer"
import "explosion"

local gfx <const> = playdate.graphics

class('Terrain').extends(Entity)

function Terrain:init(world)
  Terrain.super.init(self)

  self.world = world

  self:setImage(self:generateImage())
  self:setCenter(0, 0)
  self:moveTo(0, 0)
end

function Terrain:generateImage()
  local image = gfx.image.new(WIDTH, HEIGHT)

  gfx.pushContext(image)
  gfx.clear(gfx.kColorClear)

  local maxDrift = 5
  local y = HEIGHT - (math.random() * (HEIGHT / 3)) - (HEIGHT / 6)

  for x = 0, WIDTH, 2 do
    gfx.setColor(gfx.kColorBlack)
    gfx.fillRect(x, y, 2, y+2)
    gfx.setPattern(bayer.getFill(10))
    gfx.fillRect(x, y+2, 2, HEIGHT - y)
    y = y + ((math.random() * (maxDrift*2)) - maxDrift)
  end
  gfx.popContext()

  return image
end

function Terrain:getEmptyYPosAbove(x, y, width)
  x = math.floor(x)
  y = math.floor(y)
  width = math.floor(width)

  if x < 0 or (x + width) >= WIDTH then
    --print("x: " .. x)
    return nil
  end

  if y < 0 or y >= HEIGHT then
    --print("y: " .. y)
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

      if self:getImage():sample(xPos, yPos) ~= gfx.kColorClear then
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
      if self:getImage():sample(xPos, yPos) ~= gfx.kColorClear then
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
    print("x nopes")
    return nil
  end

  if y < 0 or (y + height) >= HEIGHT then
    print("y nopes")
    return nil
  end

  local rowEmpty = true
  for yPos = y+height, y, -1 do
    for xPos = x, (x+width) do
      if self:getImage():sample(xPos, yPos) ~= gfx.kColorClear then
        rowEmpty = false
      end
    end

    if rowEmpty then
      return yPos
    end
  end

  return nil
end

function Terrain:hit(x, y, angle, direction, radius)
  print("Terrain:hit: x:" .. x .. ", y:" .. y)
  x = math.floor(x)
  y = math.floor(y)
  radius = math.floor(radius)

  function handleExplosionComplete(explosion)
    explosion:remove()
  end

  local howMuchDirt = self:howMuchDirt(x, y, radius)
  playdate.graphics.sprite.setAlwaysRedraw(true)
  local explosion = Explosion(
    self.world,
    x,
    y,
    radius,
    angle,
    howMuchDirt,
    handleExplosionComplete
  )
  explosion:add()

  gfx.pushContext(self:getImage())
  gfx.setColor(gfx.kColorClear)
  gfx.fillCircleAtPoint(x, y, radius)
  gfx.popContext()

  gfx.sprite.addDirtyRect(x-radius, y-radius, x+radius, y+radius)
end

function Terrain:howMuchDirt(x,y,radius)
  local x = math.floor(x)
  local y = math.floor(y)
  local radius = math.floor(radius)
  local radiusSquared = radius * radius
  local image = self:getImage()

  local topY = math.max(0, y-radius)
  local bottomY = math.min(HEIGHT, y+radius)

  local leftX = math.max(0, x-radius)
  local rightX = math.min(WIDTH, x+radius)

  local dirtCount = 0
  for yPos = topY, bottomY, 1 do
    for xPos = leftX, rightX, 1 do
      local dx = xPos - x
      local dy = yPos - y
      local distanceSquared = dx * dx + dy * dy
      if distanceSquared <= radiusSquared and 
        image:sample(xPos, yPos) ~= gfx.kColorClear then
          dirtCount = dirtCount+1
      end
    end
  end

  return dirtCount
end
