import "CoreLibs/object"
import "CoreLibs/graphics"

import "global_vars"
import "entity"
import "terrain"
import "background"
import "person"
import "water"
import "camera"

local gfx <const> = playdate.graphics

class('World').extends(Object)

function World:init()
  World.super.init(self)

  self.camera = Camera()
  self.background = Background()
  gfx.sprite.setBackgroundDrawingCallback(
    function(x, y, width, height)
      self.background:draw(x, y, width, height)
    end
  )

  self.terrain = Terrain(self)
  self.terrain:setZIndex(1000)

  self.person = Person(self)
  self.person:setZIndex(5000)

  self.water = Water()
  self.water:setZIndex(9000)

  self.terrain:add()
  self.person:add()
  self.water:add()
end

function World:update()
  self.camera:update()
end
