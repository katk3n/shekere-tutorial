// 演習 2: 格子パターン
// 「自然界の数学的パターンの発見 - Mathematical Patterns in Nature」作品への第2ステップ
// テーマ: 「結晶の格子構造 - Crystal Lattice」
// 目標: 前ステップの螺旋パターンに格子パターンを追加し、結晶の規則的な構造を表現

const PI = 3.14159265359;

// 座標回転関数（新規追加）
fn rotate_uv(uv: vec2<f32>, angle: f32) -> vec2<f32> {
    let cos_a = cos(angle);
    let sin_a = sin(angle);
    return vec2(
        uv.x * cos_a - uv.y * sin_a,
        uv.x * sin_a + uv.y * cos_a
    );
}

@fragment
fn fs_main(in: VertexOutput) -> @location(0) vec4<f32> {
    let uv = NormalizedCoords(in.position.xy);
    
    // 【前ステップから継承】螺旋パターン
    let distance = length(uv);
    let angle = atan2(uv.y, uv.x);
    let normalized_angle = (angle + PI) / (2.0 * PI);
    let spiral_frequency = 3.0;
    let spiral_tightness = 5.0;
    let spiral_pattern = fract(normalized_angle * spiral_frequency + distance * spiral_tightness);
    
    // 【新規追加】格子パターンの作成
    let grid_size = 6.0;                              // 格子のサイズ
    let rotated_uv = rotate_uv(uv, PI * 0.25);       // 45度回転
    let grid_uv = fract(rotated_uv * grid_size);     // 繰り返し座標
    let grid_thickness = 0.1;                        // 格子線の太さ
    
    // 水平・垂直の格子線を作成
    let grid_x = smoothstep(0.0, grid_thickness, grid_uv.x) * 
                 smoothstep(grid_thickness, 0.0, grid_uv.x - grid_thickness);
    let grid_y = smoothstep(0.0, grid_thickness, grid_uv.y) * 
                 smoothstep(grid_thickness, 0.0, grid_uv.y - grid_thickness);
    let grid_pattern = max(grid_x, grid_y);
    
    // 【新規追加】螺旋パターンと格子パターンの合成
    let combined_pattern = spiral_pattern * 0.7 + grid_pattern * 0.3;
    
    // 結晶をイメージした緑〜青系の色彩
    let color = vec3(
        combined_pattern * 0.3,                       // 赤成分（低め）
        combined_pattern * 0.8,                       // 緑成分（強め、結晶の色）
        combined_pattern * 0.6                        // 青成分（中程度）
    );
    
    return vec4(ToLinearRgb(color), 1.0);
}

// 【技術ポイント】:
// - 前ステップから継承: 螺旋パターン（length/atan2）
// - rotate_uv(): カスタム関数による座標回転
// - fract(uv * size): 繰り返し座標による格子パターン
// - smoothstep(): 滑らかなエッジを持つ格子線の作成
// - max(grid_x, grid_y): 水平・垂直線の統合
// - パターン合成: 螺旋と格子の重み付き合成

// 【実験してみよう】:
// 1. 格子サイズ変更: grid_size を 4.0, 8.0, 10.0 などに変更
// 2. 格子回転角度: PI * 0.25 → PI * 0.125 (22.5度) など
// 3. 格子線太さ: grid_thickness を 0.05, 0.15 などに変更
// 4. 合成比率調整: 0.7と0.3 → 0.5と0.5 などに変更