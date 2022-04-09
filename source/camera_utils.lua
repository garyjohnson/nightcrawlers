local geom <const> = playdate.geometry

function getCameraTransform()
  if world ~= nil then
    return world.camera:getTransform()
  end

  return geom.affineTransform.new()
end

function cameraTransformPoint(x, y)
  return getCameraTransform():transformedPoint(geom.point.new(x, y))
end

function cameraTransformRect(x, y, width, height)
  return getCameraTransform():transformedAABB(geom.rect.new(x, y, width, height))
end
