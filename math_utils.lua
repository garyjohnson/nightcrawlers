function round(number)
  return math.floor(number + 0.5)
end

function clamp(low, n, high)
  assert(low < high, "low value must be less than high value")
  return math.min(math.max(n, low), high)
end
