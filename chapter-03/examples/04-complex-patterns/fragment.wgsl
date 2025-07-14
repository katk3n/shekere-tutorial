// Chapter 3 Example 4: 複合パターン
// 複数の数学関数を組み合わせて複雑なパターンを作成

// 定数定義
const PI = 3.14159265359;

// 座標回転関数
fn rotate_uv(uv: vec2<f32>, angle: f32) -> vec2<f32> {
    let cos_a = cos(angle);
    let sin_a = sin(angle);
    return vec2(
        uv.x * cos_a - uv.y * sin_a,
        uv.x * sin_a + uv.y * cos_a
    );
}

// 疑似乱数生成関数
fn pseudo_random(uv: vec2<f32>) -> f32 {
    return fract(sin(dot(uv, vec2(12.9898, 78.233))) * 43758.5453);
}

@fragment
fn fs_main(in: VertexOutput) -> @location(0) vec4<f32> {
    // 正規化座標を取得
    let uv = NormalizedCoords(in.position.xy);
    
    // 時間の取得
    let time = Time.duration;
    
    // 回転する座標系
    let rotated_uv = rotate_uv(uv, time * 0.2);
    
    // 基本的な座標情報
    let distance = length(rotated_uv);
    let angle = atan2(rotated_uv.y, rotated_uv.x);
    let normalized_angle = (angle + PI) / (2.0 * PI);
    
    // パターン1: 波動による変形
    let wave_frequency = 8.0;
    let wave_amplitude = 0.3;
    let wave_time = time * 1.5;
    let wave_pattern = sin(distance * wave_frequency - wave_time) * wave_amplitude;
    
    // パターン2: 螺旋パターン
    let spiral_frequency = 3.0;
    let spiral_pattern = fract(normalized_angle * spiral_frequency + distance * 5.0);
    
    // パターン3: 格子パターン
    let grid_size = 6.0;
    let grid_uv = fract(rotated_uv * grid_size);
    let grid_thickness = 0.1;
    let grid_pattern = smoothstep(0.0, grid_thickness, grid_uv.x) * 
                      smoothstep(grid_thickness, 0.0, grid_uv.x - grid_thickness) +
                      smoothstep(0.0, grid_thickness, grid_uv.y) * 
                      smoothstep(grid_thickness, 0.0, grid_uv.y - grid_thickness);
    
    // パターン4: ノイズ風パターン
    let noise_scale = 10.0;
    let noise_uv = floor(rotated_uv * noise_scale) / noise_scale;
    let noise_pattern = pseudo_random(noise_uv + vec2(time * 0.1, 0.0));
    
    // パターンの合成
    let combined_pattern = 
        wave_pattern * 0.4 +
        spiral_pattern * 0.3 +
        grid_pattern * 0.2 +
        noise_pattern * 0.1;
    
    // 距離による減衰
    let fade = 1.0 - smoothstep(0.0, 1.2, distance);
    let final_intensity = combined_pattern * fade;
    
    // 時間による色相変化
    let hue_shift = time * 0.1;
    let hue = fract(final_intensity + hue_shift);
    
    // 色の計算（HSV風の色空間）
    let saturation = 0.8;
    let value = final_intensity;
    
    let red = (sin(hue * 6.28) + 1.0) * 0.5 * saturation * value;
    let green = (sin(hue * 6.28 + 2.09) + 1.0) * 0.5 * saturation * value;
    let blue = (sin(hue * 6.28 + 4.19) + 1.0) * 0.5 * saturation * value;
    
    // 最終的な色の計算
    let color = vec3(red, green, blue);
    
    return vec4(ToLinearRgb(color), 1.0);
}

// パターンの解析:
// 1. 座標回転: 時間による回転効果
// 2. 波動パターン: sin関数による波動変形
// 3. 螺旋パターン: 角度と距離の組み合わせ
// 4. 格子パターン: 繰り返し座標による格子
// 5. ノイズパターン: 疑似乱数による自然な変化
// 6. パターン合成: 複数パターンの重み付き加算

// 実験してみよう:
// 1. 各パターンの重みを変える: wave_pattern * 係数
// 2. 時間係数を変える: time * 係数
// 3. 周波数を変える: wave_frequency, spiral_frequency など
// 4. 新しいパターンを追加: 独自の数学関数を試す
// 5. 色の計算方法を変える: 異なる色空間を試す