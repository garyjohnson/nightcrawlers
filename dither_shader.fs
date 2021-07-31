const int indexMatrix4x4[16] = int[](0,  8,  2,  10,
                                     12, 4,  14, 6,
                                     3,  11, 1,  9,
                                     15, 7,  13, 5);

vec4 effect( vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords ) {
  vec4 c = Texel(texture, texture_coords) * color;
  float a = c[3];
  float c2 = c[0];

  float newColor = 0;

  if(c2 < 0.01) {
    newColor = 0;
  } else if (c2 > 0.99) {
    newColor = 1;
  } else {
    float closestColor = c2 < 0.5 ? 0 : 1;
    float secondClosestColor = 1 - closestColor;

    int x = int(mod(screen_coords.x, 4));
    int y = int(mod(screen_coords.y, 4));

    float d = indexMatrix4x4[(x + y * 4)] / 16.0;
    float distance = abs(closestColor - c2);

    newColor = distance < d ? closestColor : secondClosestColor;
  }

  if(newColor < 0.01) {
    return vec4(0.19, 0.18, 0.16, a);
  } else if (newColor > 0.99) {
    return vec4(0.84, 0.83, 0.8, a);
  }
}

