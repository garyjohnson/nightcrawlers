import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "camera_utils"

local gfx <const> = playdate.graphics
local geom <const> = playdate.geometry

class('Entity').extends()

function Entity:init(...)
  Entity.super.init(self, ...)

  self.originalImage = nil
  self.logicalX = 0
  self.logicalY = 0
  self.transform = geom.affineTransform.new()
  --self.scale = 1.0
  if world ~= nil and world.camera ~= nil then
    self.transform = world.camera:getTransform()
    self:updateTransformedImage()
  end
end

function Entity:getLogicalPos()
  return self.logicalX, self.logicalY
end

function Entity:setLogicalPos(x, y)
  self.logicalX = x
  self.logicalY = y

  local transformedX, transformedY = self.transform:transformXY(self.logicalX, self.logicalY)
  --self:moveTo(transformedX, transformedY)
end

function Entity:updateTransformedImage()
  if self.originalImage ~= nil then
    self:setImage(self.originalImage:transformedImage(self.transform))
    --self:setImage(self.originalImage)
  end
end

function Entity:getOriginalImage()
  return self.originalImage
end

function Entity:setOriginalImage(image)
  self.originalImage = image
  self:updateTransformedImage()
end
