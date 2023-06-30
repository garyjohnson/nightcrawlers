local geom <const> = playdate.geometry

function getCameraTransform()
  return camera:getTransform()
end

function cameraTransformPoint(point)
  return getCameraTransform():transformedPoint(point)
end

function cameraTransformPoint(x, y)
  return getCameraTransform():transformedPoint(geom.point.new(x, y))
end

function cameraTransformXY(x, y)
  return getCameraTransform():transformXY(x, y)
end

function cameraTransformRadius(radius)
  return getCameraTransform():transformedPoint(geom.point.new(0, radius)).y
end

function cameraTransformRect(x, y, width, height)
  return getCameraTransform():transformedAABB(geom.rect.new(x, y, width, height))
end
