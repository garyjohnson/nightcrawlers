require "global_vars"
require "terrain"
require "background"
require "person"

Object = require "classic"
World = Object:extend()

function World:new()
  self.terrain = Terrain()
  self.person = Person(self)

  self.entities = {}

  self:addEntity(Background(), 1)
  self:addEntity(self.terrain, 2)
  self:addEntity(self.person, 3)
end

function World:update(dt)
  for _, entity in pairs(self.entities) do
    entity[2]:update(dt)
  end
end

function World:draw()
  for _, entity in pairs(self.entities) do
    entity[2]:draw()
  end
end

function World:addEntity(entity, zIndex)
  zIndex = zIndex or 0
  table.insert(self.entities, {zIndex, entity})
  table.sort(self.entities, function(a,b) return a[1] < b[1] end)
end

function World:removeEntity(entity)
  for i = #entities, 1, -1 do
    if entities[i][1] == entity then
      table.remove(entities, i)
      break
    end
  end
end

function love.keyreleased( key )
  if key == "r" then
    terrain:generate()
    person.y = 1
  end
end
