import "CoreLibs/object"
import "CoreLibs/crank"
import "camera_utils"

local geom <const> = playdate.geometry

class('Camera').extends(Object)

function Camera:init()
  Camera.super.init(self)

  self.transform = geom.affineTransform.new()
  -- test camera translation
  --self.transform:translate(WIDTH/2,HEIGHT/2)
  --self:setScale(0.5)
end

function Camera:setScale(scale)
  self.scale = scale
  self.transform:scale(scale)
end

function Camera:getTransform()
  return self.transform
end

function Camera:update()
end
