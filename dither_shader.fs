vec4 effect( vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords )
{
  vec4 c = Texel(texture, texture_coords);
  if (
    c[0] > 0.28 &&
    c[0] < 0.31 &&
    c[1] > 0.28 &&
    c[1] < 0.31 &&
    c[2] > 0.28 &&
    c[2] < 0.31
  ) {
    if(mod(screen_coords.y, 2.0) < 1.0 && 
        mod(screen_coords.x, 2.0) < 1.0) {
      return vec4(0.84, 0.83, 0.8, 1.0);
    } else {
      return vec4(0.19, 0.18, 0.16, 1.0);
    }
  } else if (
    c[0] > 0.58 &&
    c[0] < 0.61 &&
    c[1] > 0.58 &&
    c[1] < 0.61 &&
    c[2] > 0.58 &&
    c[2] < 0.61
  ) {
    if(mod(screen_coords.y, 4.0) < 1.0 && 
        mod(screen_coords.x, 4.0) < 1.0) {
      return vec4(0.84, 0.83, 0.8, 1.0);
    } else {
      return vec4(0.19, 0.18, 0.16, 1.0);
    }
  } else {
    return color * Texel(texture, texture_coords);
  }
}
