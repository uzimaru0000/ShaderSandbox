float random(fixed2 p) {
    return frac(sin(dot(p, fixed2(12.9898, 78.233))) * 43758.5453);
}

float random2(fixed2 st) {
    fixed x = dot(st, fixed2(127.1, 311.7));
    fixed y = dot(st, fixed2(269.5, 183.3));
    st = fixed2(x, y);

    return -1.0 + 2.0 * frac(sin(st) * 43758.5453123);
}

float noise(fixed2 st) {
    fixed2 p = floor(st);
    return random(p);
}

float valueNoise(fixed2 st) {
    fixed2 p = floor(st);
    fixed2 f = frac(st);

    float v00 = random(p + fixed2(0, 0));
    float v10 = random(p + fixed2(1, 0));
    float v01 = random(p + fixed2(0, 1));
    float v11 = random(p + fixed2(1, 1));

    fixed2 u = f * f * (3.0 - 2.0 * f);

    float v0010 = lerp(v00, v10, u.x);
    float v0111 = lerp(v01, v11, u.x);

    return lerp(v0010, v0111, u.y);
}

float perlinNoise(fixed2 st) {
    fixed2 p = floor(st);
    fixed2 f = frac(st);
    fixed2 u = f * f * (3.0 - 2.0 * f);

    fixed2 p00 = fixed2(0, 0);
    fixed2 p10 = fixed2(1, 0);
    fixed2 p01 = fixed2(0, 1);
    fixed2 p11 = fixed2(1, 1);

    float v00 = random2(p + p00);
    float v10 = random2(p + p10);
    float v01 = random2(p + p01);
    float v11 = random2(p + p11);

    float v0010 = lerp(dot(v00, f - p00), dot(v10, f - p10), u.x);
    float v0111 = lerp(dot(v01, f - p01), dot(v11, f - p11), u.x);

    return lerp(v0010, v0111, u.y) + 0.5;
}

float fBm(fixed2 st) {
    float f = 0;
    for (int i = 1; i <= 4; i++) {
        float p = pow(2.0, i);
        f += (1 / p) * perlinNoise(st * p);
    }

    return f;
}