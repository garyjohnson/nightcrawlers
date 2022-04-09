import "CoreLibs/object"
import "CoreLibs/crank"

local geom <const> = playdate.geometry

class('Camera').extends(Object)

function Camera:init()
  Camera.super.init(self)

  self.scale = 1.0
  self.transform = geom.affineTransform.new()
end

function Camera:getTransform()
  return self.transform
end

function Camera:update()
  if playdate.isCrankDocked() == false then
    local change, _ = playdate.getCrankChange()
    if change ~= 0 then
      local scaleChange = change * 0.001
      self.scale = self.scale + scaleChange

      self.transform = geom.affineTransform.new()
      self.transform:scale(self.scale)

      playdate.graphics.sprite.performOnAllSprites(Entity.updateBounds)
      playdate.graphics.sprite.addDirtyRect(0, 0, WIDTH, HEIGHT)
    end
  end
end
