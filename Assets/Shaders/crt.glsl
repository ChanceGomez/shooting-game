extern vec2 screen_size;
extern float time;

vec2 curve(vec2 uv,float barrelX,float barrelY) {
    uv = uv * 2.0 - 1.0;
    vec2 offset = abs(uv.yx) / vec2(barrelY, barrelX);
    uv = uv + uv * offset * offset;
    uv = uv * 0.5 + 0.5;
    return uv;
}

vec4 effect(vec4 color, Image tex, vec2 texture_coords, vec2 screen_coords) {
    float aberration = 0.000;
    float vignetteReach = 100.0;
    float flicker = 0.0;
    float darkness = .9;
    float barrelX = 100;
    float barrelY = 100;
    
    vec2 uv = curve(texture_coords,barrelX,barrelY);

    // Kill pixels outside the curved screen edge
    if (uv.x < 0.0 || uv.x > 1.0 || uv.y < 0.0 || uv.y > 1.0)
        return vec4(0.0, 0.0, 0.0, 1.0);

    // Chromatic aberration
    float r = Texel(tex, uv + vec2( aberration, 0.0)).r;
    float g = Texel(tex, uv).g;
    float b = Texel(tex, uv + vec2(-aberration, 0.0)).b;

    vec4 col = vec4(r, g, b, 1.0);

    // Scanlines
    float scanline = sin(uv.y * screen_size.y * 3.14159) * 0.5 + 0.5;
    scanline = pow(scanline, 0.25);
    col.rgb *= mix(darkness, 1.0, scanline);

    // Vignette
    vec2 vig_uv = uv * (1.0 - uv.yx);
    float vignette = pow(vig_uv.x * vig_uv.y * vignetteReach, 0.25);
    col.rgb *= vignette;

    // Subtle phosphor flicker
    col.rgb *= 0.98 + flicker * sin(time * 60.0);

    return col * color;
}