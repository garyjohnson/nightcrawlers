piDividedBy180 = math.pi / 180
oneHundredEightyDividedByPi = 180 / math.pi

function round(number)
  return math.floor(number + 0.5)
end

function clamp(low, n, high)
  assert(low < high, "low value must be less than high value")
  return math.min(math.max(n, low), high)
end

function degToRad(deg)
  return deg * piDividedBy180
end

function radToDeg(rad)
  return rad * oneHundredEightyDividedByPi
end

function distance(x1, y1, x2, y2)
  return math.sqrt(math.pow(x2 - x1, 2) + math.pow(y2 - y1, 2))
end

function angle(x1, y1, x2, y2)
  return math.atan(y2 - y1, x2 - x1)
end

function min(...)
  local args = table.pack(...)
  local min = args[1]
  for _,value in pairs(args) do
    min = math.min(min, value)
  end

  return min
end

function max(...)
  local args = table.pack(...)
  local max = args[1]
  for _,value in pairs(args) do
    max = math.max(max, value)
  end

  return max
end
