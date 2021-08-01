Object = require "classic"
Entity = Object:extend()

function Entity:new()
  self.entities = {}
end

function Entity:update(dt)
  for i, entity in pairs(self.entities) do
    entity[2]:update(dt)
  end
end

function Entity:draw()
  for _, entity in pairs(self.entities) do
    entity[2]:draw()
  end
end

function Entity:addEntity(entity, zIndex)
  zIndex = zIndex or 0
  table.insert(self.entities, {zIndex, entity})
  table.sort(self.entities, function(a,b) return a[1] < b[1] end)
end

function Entity:removeEntity(entity)
  for i = #self.entities, 1, -1 do
    if self.entities[i][2] == entity then
      table.remove(self.entities, i)
      break
    end
  end
end
