import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/crank"

local gfx <const> = playdate.graphics
local geom <const> = playdate.geometry

class('Camera').extends(Object)

function Camera:init()
  Camera.super.init(self)

  self.panX = 0
  self.panY = 0
  self.enableInput = false
end

function Camera:setEnableInput(enableInput)
  self.enableInput = enableInput
end

function Camera:panStep(xStep, yStep)
  self:setPan(self.panX + xStep, self.panY + yStep)
end

function Camera:setPan(panX, panY)
  print("setPan x:" .. panX .. ", y:" .. panY)
  self.panX = panX
  self.panY = panY
  playdate.graphics.setDrawOffset(panX, panY)
end

function Camera:reset()
  self:setPan(0, 0)
end

function Camera:update()
  self:processInput()
end

function Camera:processInput()
  if not self.enableInput then
    return
  end

  if playdate.buttonIsPressed(playdate.kButtonB) then
    endMoveCamera()
  end

  local panStep = 1
  local panX = 0
  local panY = 0

  if playdate.buttonIsPressed(playdate.kButtonLeft) then
    panX -= panStep
  elseif playdate.buttonIsPressed(playdate.kButtonRight) then
    panX += panStep
  end

  if playdate.buttonIsPressed(playdate.kButtonUp) then
    panY -= panStep
  elseif playdate.buttonIsPressed(playdate.kButtonDown) then
    panY += panStep
  end

  self:panStep(panX, panY)
end
