// 演習 3: ノイズ統合パターン
// 「自然界の数学的パターンの発見 - Mathematical Patterns in Nature」作品への第3ステップ
// テーマ: 「秩序と混沌の調和 - Order and Chaos」
// 目標: 前ステップの螺旋+格子パターンにノイズを追加し、自然の不規則性を表現

const PI = 3.14159265359;

// 座標回転関数（Exercise 2から継承）
fn rotate_uv(uv: vec2<f32>, angle: f32) -> vec2<f32> {
    let cos_a = cos(angle);
    let sin_a = sin(angle);
    return vec2(
        uv.x * cos_a - uv.y * sin_a,
        uv.x * sin_a + uv.y * cos_a
    );
}

// 疑似乱数生成関数（新規追加）
fn pseudo_random(uv: vec2<f32>) -> f32 {
    return fract(sin(dot(uv, vec2(12.9898, 78.233))) * 43758.5453);
}

@fragment
fn fs_main(in: VertexOutput) -> @location(0) vec4<f32> {
    let uv = NormalizedCoords(in.position.xy);
    
    // 【前ステップから継承】螺旋パターン
    let distance = length(uv);
    let angle = atan2(uv.y, uv.x);
    let normalized_angle = (angle + PI) / (2.0 * PI);
    let spiral_pattern = fract(normalized_angle * 3.0 + distance * 5.0);
    
    // 【前ステップから継承】格子パターン
    let grid_size = 6.0;
    let rotated_uv = rotate_uv(uv, PI * 0.25);
    let grid_uv = fract(rotated_uv * grid_size);
    let grid_thickness = 0.1;
    let grid_x = smoothstep(0.0, grid_thickness, grid_uv.x) * 
                 smoothstep(grid_thickness, 0.0, grid_uv.x - grid_thickness);
    let grid_y = smoothstep(0.0, grid_thickness, grid_uv.y) * 
                 smoothstep(grid_thickness, 0.0, grid_uv.y - grid_thickness);
    let grid_pattern = max(grid_x, grid_y);
    
    // 【前ステップから継承】螺旋+格子の合成
    let spiral_grid_combined = spiral_pattern * 0.7 + grid_pattern * 0.3;
    
    // 【新規追加】ノイズパターンの作成
    let noise_scale = 10.0;
    let noise_uv = floor(uv * noise_scale) / noise_scale;  // セル化
    let noise_pattern = pseudo_random(noise_uv);
    
    // 【新規追加】3つのパターンの統合
    let final_pattern = 
        spiral_grid_combined * 0.8 +    // 前ステップの複合パターン
        noise_pattern * 0.2;            // 自然の不規則性（ノイズ）
    
    // 自然の調和をイメージした色彩（茶〜緑系）
    let color = vec3(
        final_pattern * 0.6,            // 赤成分（茶色味）
        final_pattern * 0.8,            // 緑成分（強め、自然の色）
        final_pattern * 0.5             // 青成分（低め）
    );
    
    return vec4(ToLinearRgb(color), 1.0);
}

// 【技術ポイント】:
// - 前ステップから継承: 螺旋+格子パターン
// - pseudo_random(): ハッシュ関数による疑似乱数生成
// - floor(uv * scale) / scale: 座標のセル化によるノイズパターン
// - 3パターンの調和的統合: 規則性と不規則性の組み合わせ
// - 自然をイメージした色彩システム

// 【実験してみよう】:
// 1. ノイズ解像度: noise_scale を 5.0, 15.0, 20.0 などに変更
// 2. 合成比率調整: 0.8と0.2 → 0.6と0.4 などに変更
// 3. 色の調整: 茶〜緑系から他の自然色（青〜紫など）に変更
// 4. ノイズ分布: pseudo_random()の係数を変えて異なるランダム性を試行