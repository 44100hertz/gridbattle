uniform vec2 texture_size;
uniform float scale;
uniform vec2 offset;

vec4 effect(vec4 color, Image tex, vec2 texture_coords, vec2 screen_coords)
{
  vec2 pixel_position = screen_coords / scale;
  pixel_position = pixel_position + vec2(sin(pixel_position.y * 0.1) * 5.0, 0.0);
  vec2 looping_coords = mod((pixel_position + offset) / texture_size, 1.0);
  return Texel(tex, looping_coords);
}
