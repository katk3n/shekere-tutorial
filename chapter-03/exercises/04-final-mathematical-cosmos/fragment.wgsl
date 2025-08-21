// 演習 4: 最終統合作品「自然の複合パターン - Natural Complex Patterns」
// 「自然界の数学的パターンの発見 - Mathematical Patterns in Nature」作品の完成版
// 目標: 全ての技術要素を統合し、波動パターン・時間アニメーション・HSV色彩で完成作品を作る

const PI = 3.14159265359;

// 座標回転関数（Exercise 3から継承）
fn rotate_uv(uv: vec2<f32>, angle: f32) -> vec2<f32> {
    let cos_a = cos(angle);
    let sin_a = sin(angle);
    return vec2(
        uv.x * cos_a - uv.y * sin_a,
        uv.x * sin_a + uv.y * cos_a
    );
}

// 疑似乱数生成関数（Exercise 3から継承）
fn pseudo_random(uv: vec2<f32>) -> f32 {
    return fract(sin(dot(uv, vec2(12.9898, 78.233))) * 43758.5453);
}

@fragment
fn fs_main(in: VertexOutput) -> @location(0) vec4<f32> {
    let uv = NormalizedCoords(in.position.xy);
    let time = Time.duration;
    
    // 【新規追加】時間による回転座標系
    let rotated_uv = rotate_uv(uv, time * 0.2);
    let distance = length(rotated_uv);
    let angle = atan2(rotated_uv.y, rotated_uv.x);
    let normalized_angle = (angle + PI) / (2.0 * PI);
    
    // 【前ステップから継承】螺旋パターン
    let spiral_pattern = fract(normalized_angle * 3.0 + distance * 5.0);
    
    // 【前ステップから継承】格子パターン
    let grid_size = 6.0;
    let grid_rotated_uv = rotate_uv(rotated_uv, PI * 0.25);
    let grid_uv = fract(grid_rotated_uv * grid_size);
    let grid_thickness = 0.1;
    let grid_x = smoothstep(0.0, grid_thickness, grid_uv.x) * 
                 smoothstep(grid_thickness, 0.0, grid_uv.x - grid_thickness);
    let grid_y = smoothstep(0.0, grid_thickness, grid_uv.y) * 
                 smoothstep(grid_thickness, 0.0, grid_uv.y - grid_thickness);
    let grid_pattern = max(grid_x, grid_y);
    
    // 【前ステップから継承】ノイズパターン
    let noise_scale = 10.0;
    let noise_uv = floor(rotated_uv * noise_scale) / noise_scale;
    let noise_pattern = pseudo_random(noise_uv + vec2(time * 0.1, 0.0));  // 時間変化追加
    
    // 【前ステップから継承】螺旋+格子+ノイズの合成
    let spiral_grid_combined = spiral_pattern * 0.7 + grid_pattern * 0.3;
    let three_pattern_combined = spiral_grid_combined * 0.8 + noise_pattern * 0.2;
    
    // 【新規追加】波動パターン（最終段階で追加）
    let wave_x = sin(rotated_uv.x * 8.0 + time);
    let wave_y = cos(rotated_uv.y * 6.0 + time * 0.8);
    let wave_pattern = wave_x * wave_y;
    let wave_intensity = (wave_pattern + 1.0) * 0.5;
    
    // 【新規追加】全4パターンの最終統合
    let final_pattern = 
        three_pattern_combined * 0.7 +     // 前3つのパターン
        wave_intensity * 0.3;              // 波動パターン
    
    // 【新規追加】距離による減衰効果（調整済み）
    let fade = 1.0 - smoothstep(0.8, 1.8, distance);  // 減衰開始を遅らせ、範囲を拡大
    let faded_intensity = final_pattern * (0.3 + fade * 0.7);  // 最低輝度を30%確保
    
    // 【新規追加】時間による色相変化
    let hue_shift = time * 0.1;
    let hue = fract(faded_intensity + hue_shift);
    
    // 【新規追加】HSV風色空間による美しい色彩
    let saturation = 0.8;
    let value = faded_intensity;
    
    // 120度位相差によるRGB生成
    let red = (sin(hue * 6.28) + 1.0) * 0.5 * saturation * value;
    let green = (sin(hue * 6.28 + 2.09) + 1.0) * 0.5 * saturation * value;
    let blue = (sin(hue * 6.28 + 4.19) + 1.0) * 0.5 * saturation * value;
    
    // 最終的な色の計算
    let color = vec3(red, green, blue);
    
    return vec4(ToLinearRgb(color), 1.0);
}

// 【完成作品の技術要素】:
// Exercise 1: 螺旋パターン（length/atan2による銀河の腕）
// Exercise 2: 格子パターン（fract + rotate_uv + smoothstepによる結晶構造）
// Exercise 3: ノイズパターン（pseudo_randomによる自然の不規則性）
// Exercise 4: 波動パターン + 時間アニメーション + HSV色空間 + 距離減衰

// 【自然界の数学的パターンの発見】完成作品:
// この作品では、螺旋（銀河）、格子（結晶）、ノイズ（不規則性）、波動（流体）という
// 4つの異なる自然現象を数学的に表現し、時間の流れと美しい色彩で統合しました。
// それぞれのパターンが持つ数学的な美しさが組み合わさることで、
// 自然界の複雑さと調和を表現した最終作品となっています。

// 【実験してみよう】:
// 1. 回転速度: time * 0.2 → time * 0.1 でゆっくりとした回転
// 2. パターン比率: 0.7と0.3 → 0.5と0.5 で均等な統合
// 3. 色相変化速度: time * 0.1 → time * 0.05 でゆっくりとした色の変化
// 4. 減衰調整: smoothstep(0.8, 1.8, distance) と最低輝度0.3で外側の可視性向上
// 5. 明るさ調整: 0.3 + fade * 0.7 の係数を変更して全体の明るさを調整