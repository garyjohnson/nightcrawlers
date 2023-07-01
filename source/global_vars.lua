inspect = import "lib/inspect"

WIDTH = playdate.display.getWidth()
HEIGHT = playdate.display.getHeight()
CENTER = playdate.geometry.point.new(WIDTH / 2, HEIGHT / 2)

-- acceleration due to gravity
-- 9.8 meters/second^2
-- in pixels that is maybe 90px/s
-- but that feels real floaty here
GRAVITY_ACCELERATION = 120
