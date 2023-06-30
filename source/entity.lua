import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "camera_utils"

local gfx <const> = playdate.graphics
local geom <const> = playdate.geometry

class('Entity').extends(gfx.sprite)

function Entity:init(...)
  Entity.super.init(self, ...)

  self.originalImage = nil
  self.logicalX = 0
  self.logicalY = 0
  self:updateTransformedImage()
end

function Entity:getLogicalPos()
  return self.logicalX, self.logicalY
end

function Entity:setLogicalPos(x, y)
  self.logicalX = x
  self.logicalY = y

  self:moveTo(cameraTransformXY(self.logicalX, self.logicalY))
end

function Entity:updateTransformedImage()
  if self.originalImage ~= nil then
    self:setImage(self.originalImage:transformedImage(getCameraTransform()))
  end
end

function Entity:getOriginalImage()
  return self.originalImage
end

function Entity:setOriginalImage(image)
  self.originalImage = image
  self:updateTransformedImage()
end
