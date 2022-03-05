-- bayer.lua v1.0
-- by Potch
-- MIT License

-- hard-code smallest bayer
local bayer2 = { [0] = 0x0, [1] = 0x2, [2] = 0x3, [3] = 0x1 }

-- t should be a 64 entry table of 1 and 0s, indexed at 0
-- returns a 1-indexed table of bytes for use with playdate.graphics.setPattern
local function toBytes(t)
  local o = {}
  for i = 0, 7 do
    local v = 0x0
    for j = 0, 7 do
      v = v * 0x2 + t[i * 0x8 + j]
    end
    o[i + 1] = v
  end
  return o
end

-- helper to treat 0-indexed tables as 2d arrays
local function at(b, x, y, width)
  return b[y * width + x]
end

-- naive recursive bayer filter generator. size should be a power of 2.
local function generateBayer(size)
  if (size == 2) then
    return bayer2
  end

  local length = size * size
  local prevSize = size / 2
  local prev

  if (prevSize == 2) then
    prev = bayer2
  else 
    prev = generateBayer(prevSize)
  end

  local b = {}
  for i = 0, length - 1 do
    local x = i % size
    local y = math.floor(i / size)
    b[i] = at(prev, x % prevSize, y % prevSize, prevSize) * 0x4 +
           at(bayer2, math.floor(x / prevSize), math.floor(y / prevSize), 2)
  end
  
  return b
end

-- takes every value in a table b and converts it to a 0 or 1 byte based on the threshold t
local function threshold (b, t)
  local o = {}
  for key, value in pairs(b) do
    if value > t then
      o[key] = 0x1
    else
      o[key] = 0x0
    end
  end
  return o
end

local fillLUT = {}

-- generates 64 (completely light to completely dark) fill patterns for passing to playdate.graphics.setPattern
-- call this once before calling bayer.getFill()
local function generateFillLUT()
  for i = 0, 63 do
    fillLUT[i] = toBytes(threshold(generateBayer(8), i))
  end
end

bayer = {
  at = at,
  generate = generateBayer,
  threshold = threshold,
  generateFillLUT = generateFillLUT,
  getFill = function (n) return fillLUT[n] end,
  toByets = toBytes
}
