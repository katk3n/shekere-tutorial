// Chapter 3 Solution 3: 創作課題 - 解答例
// 作品名: "花の生命力 - Flower of Life"
// テーマ: 自然界のパターン
// 作品説明: 花の成長と生命力をシェーダーで表現した作品
// 使用技術: 座標変換、距離関数、角度関数、時間アニメーション、色の変化
// 制作の工夫: 複数の花びらパターンを重ね合わせ、時間による成長を表現

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

// 花びらパターン生成関数
fn create_petal(uv: vec2<f32>, petal_count: f32, growth: f32) -> f32 {
    let distance = length(uv);
    let angle = atan2(uv.y, uv.x);
    
    // 花びらの形状計算
    let petal_angle = sin(angle * petal_count) * 0.3 + 0.5;
    let petal_radius = petal_angle * growth;
    
    // 滑らかなエッジ
    let petal_mask = 1.0 - smoothstep(petal_radius - 0.1, petal_radius + 0.1, distance);
    
    // 中心部の強調
    let center_glow = exp(-distance * 3.0) * 0.5;
    
    return petal_mask + center_glow;
}

// 色相を HSV から RGB に変換
fn hsv_to_rgb(hue: f32, saturation: f32, value: f32) -> vec3<f32> {
    let red = (sin(hue * 6.28) + 1.0) * 0.5;
    let green = (sin(hue * 6.28 + 2.09) + 1.0) * 0.5;
    let blue = (sin(hue * 6.28 + 4.19) + 1.0) * 0.5;
    
    let gray = vec3(value, value, value);
    return mix(gray, vec3(red, green, blue) * value, saturation);
}

@fragment
fn fs_main(in: VertexOutput) -> @location(0) vec4<f32> {
    let uv = NormalizedCoords(in.position.xy);
    let time = Time.duration;
    
    // 成長のアニメーション
    let growth_cycle = sin(time * 0.5) * 0.5 + 0.5;  // 0〜1の範囲
    let base_growth = 0.3 + growth_cycle * 0.7;
    
    // 花の中心位置
    let center = vec2(0.0, 0.0);
    let centered_uv = uv - center;
    
    // 複数の花びらレイヤー
    var total_pattern = 0.0;
    
    // レイヤー1: 大きな花びら（8枚）
    let layer1_uv = rotate_uv(centered_uv, time * 0.1);
    let layer1_growth = base_growth * 0.8;
    let layer1_pattern = create_petal(layer1_uv, 8.0, layer1_growth);
    
    // レイヤー2: 中間の花びら（12枚）
    let layer2_uv = rotate_uv(centered_uv, -time * 0.15);
    let layer2_growth = base_growth * 0.6;
    let layer2_pattern = create_petal(layer2_uv, 12.0, layer2_growth);
    
    // レイヤー3: 小さな花びら（16枚）
    let layer3_uv = rotate_uv(centered_uv, time * 0.2);
    let layer3_growth = base_growth * 0.4;
    let layer3_pattern = create_petal(layer3_uv, 16.0, layer3_growth);
    
    // パターンの合成
    total_pattern = layer1_pattern * 0.5 + layer2_pattern * 0.3 + layer3_pattern * 0.2;
    
    // 背景パターン（茎や葉のイメージ）
    let distance_from_center = length(uv);
    let background_waves = sin(uv.x * 20.0 + time) * sin(uv.y * 15.0 + time * 1.5);
    let background_pattern = (background_waves + 1.0) * 0.5 * 0.1;
    
    // 最終パターン
    let final_pattern = total_pattern + background_pattern;
    
    // 色の計算
    let hue_base = 0.3;  // 緑系の色相
    let hue_variation = sin(final_pattern * 10.0 + time * 0.5) * 0.2;
    let final_hue = hue_base + hue_variation;
    
    let saturation = 0.7 + sin(time * 0.3) * 0.3;
    let value = final_pattern;
    
    // 中心部のグローエフェクト
    let glow_intensity = exp(-distance_from_center * 2.0) * 0.3;
    let glow_color = hsv_to_rgb(0.1, 0.8, glow_intensity);  // 黄色系のグロー
    
    // 花びらの色
    let flower_color = hsv_to_rgb(final_hue, saturation, value);
    
    // 最終的な色の合成
    let final_color = flower_color + glow_color;
    
    return vec4(ToLinearRgb(final_color), 1.0);
}

// 作品の特徴:
// 1. 座標変換: 回転による花びらの動き
// 2. 距離関数: 花びらの形状と中心部のグロー
// 3. 角度関数: 花びらの配置
// 4. 時間アニメーション: 成長と回転のアニメーション
// 5. 色の変化: 時間による色相の変化と中心部のグロー
//
// 制作の工夫:
// - 複数のレイヤーを重ね合わせて複雑な花びらパターンを作成
// - 異なる回転速度でレイヤーを動かして有機的な動きを表現
// - 成長のアニメーションで生命力を表現
// - 中心部のグローエフェクトで神秘的な美しさを演出
// - 背景の波動パターンで茎や葉の存在を暗示
//
// 技術的なポイント:
// - 関数を分割して可読性を向上
// - HSV色空間で直感的な色制御
// - 複数パターンの重み付き合成
// - 時間による滑らかなアニメーション