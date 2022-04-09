import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "camera_utils"

local gfx <const> = playdate.graphics

class('Entity').extends(gfx.sprite)

function Entity:init(...)
  Entity.super.init(self, ...)
end

function Entity:draw(x, y, width, height)
  print(self.className .. ' draw at ' .. self.x .. ", " .. self.y)
  gfx.pushContext()
  --gfx.setClipRect( cameraTransformRect(x, y, width, height ))
  local drawOffset = cameraTransformPoint(self.x, self.y)
  gfx.setDrawOffset(drawOffset.x, drawOffset.y)

  local imageWidth, imageHeight = self.originalImage:getSize()
  local centerXPercent, centerYPercent = self:getCenter()

  --self.originalImage:drawAnchored(0, 0, centerXPercent, centerYPercent)
  local point = cameraTransformPoint((imageWidth * centerXPercent) + (imageWidth/2), (imageHeight * centerYPercent) + (imageHeight/2))
  self.originalImage:drawWithTransform(getCameraTransform(), point.x, point.y)

  gfx.setDrawOffset(0, 0)
  --gfx.clearClipRect()
  gfx.popContext()
end

function Entity:setImage(image)
  self.originalImage = image

  local width, height = image:getSize()
  self:updateBounds()
end

function Entity:updateBounds()
  if self.originalImage ~= nil then
    local width, height = self.originalImage:getSize()
    --self:setBounds(cameraTransformRect(self.x, self.y, width+1, height+1))
    self:setBounds(self.x, self.y, width+1, height+1)
  end
end

function Entity:getImage()
  return self.originalImage
end
