piDividedBy180 = math.pi / 180

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

function distance(x1, y1, x2, y2)
  return math.sqrt(math.pow(x2 - x1, 2) + math.pow(y2 - y1, 2))
end
