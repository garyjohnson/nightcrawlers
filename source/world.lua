import "CoreLibs/object"
import "CoreLibs/graphics"

import "global_vars"
import "entity"
import "terrain"
import "background"
import "person"
import "water"

local gfx <const> = playdate.graphics

class('World').extends(Entity)

function World:init()
  World.super.init(self)

  self.terrain = Terrain()
  self.person = Person(self)
  self.water = Water()

  self:addEntity(Background(), 1)
  self:addEntity(self.terrain, 2)
  self:addEntity(self.person, 3)
  self:addEntity(self.water, 4)
end
