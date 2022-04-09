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
  self.transform = geom.affineTransform.new()
end

function Entity:getLogicalPos()
end

function Entity:setLogicalPos(x, y)
  self.logicalX = x
  self.logicalY = y

  local transformedPoint =  self.transform:transformedPoint(geom.point.new(self.logicalX, self.logicalY))
  self:moveTo(transformedPoint.x, transformedPoint.y)
end

function Entity:updateTransformedImage()
  if self.originalImage ~= nil then
    self:setImage(self.originalImage:transformedImage(self.transform))
  end
end

function Entity:getOriginalImage()
  return self.originalImage
end

function Entity:setOriginalImage(image)
  self.originalImage = image
  self:updateTransformedImage()
end
