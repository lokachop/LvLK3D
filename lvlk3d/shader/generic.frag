varying vec4 worldPosition;
varying vec4 viewPosition;
varying vec4 screenPosition;
varying vec3 vertexNormal;
varying vec4 vertexColor;


vec4 effect(vec4 color, Image tex, vec2 texture_coords, vec2 screen_coords) {
    vec4 texturecolor = Texel(tex, texture_coords);



    return texturecolor * color;
    //return vec4((vertexNormal + vec3(1, 1, 1)) * 0.5, 1.0) * color;

    //float depth = screenPosition.w / 16;
    //return vec4(color.xyz * depth, 1.0);
}