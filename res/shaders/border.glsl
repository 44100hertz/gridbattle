uniform vec2 position;
uniform vec2 size;
uniform float scale;

vec4 effect(vec4 color, Image tex, vec2 texture_coords, vec2 screen_coords)
{
  screen_coords = screen_coords / scale;
  vec2 lower = position;
  vec2 upper = position + size;
  if (screen_coords.x < lower.x || screen_coords.y < lower.y ||
      screen_coords.x > upper.x || screen_coords.y > upper.y) {
    return vec4(0.0, 0.0, 0.0, 0.0);
  } else {
    return Texel(tex, texture_coords) * color;
  }
}
