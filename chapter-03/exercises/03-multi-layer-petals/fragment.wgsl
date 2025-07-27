// 演習 3: 多層花びらパターン
// 「花の生命力 - Flower of Life」作品への第3ステップ
// 目標: 前ステップの単層花びらを基礎として、複数レイヤーとアニメーションを追加

const PI = 3.14159265359;

// 花びらパターン生成関数（新規追加）
fn create_petal_layer(uv: vec2<f32>, petal_count: f32, radius: f32, rotation: f32) -> f32 {
    let distance = length(uv);
    let angle = atan2(uv.y, uv.x) + rotation;
    
    // 前ステップと同じ花びら形状の計算
    let petal_shape = sin(angle * petal_count * 0.5);
    let petal_radius = radius + petal_shape * 0.15;
    
    // 滑らかなエッジ
    return 1.0 - smoothstep(petal_radius - 0.05, petal_radius + 0.05, distance);
}

@fragment
fn fs_main(in: VertexOutput) -> @location(0) vec4<f32> {
    let uv = NormalizedCoords(in.position.xy);
    let time = Time.duration;
    
    // 前ステップからの基礎要素を保持
    let distance = length(uv);
    let angle = atan2(uv.y, uv.x);
    
    // 新規追加: 複数レイヤーの花びら
    let rotation1 = time * 0.1;
    let rotation2 = -time * 0.15;
    let rotation3 = time * 0.2;
    
    let layer1 = create_petal_layer(uv, 8.0, 0.5, rotation1);   // 外側レイヤー
    let layer2 = create_petal_layer(uv, 12.0, 0.35, rotation2); // 中間レイヤー
    let layer3 = create_petal_layer(uv, 16.0, 0.2, rotation3);  // 内側レイヤー
    
    // 新規追加: レイヤーの重み付き合成
    let combined_pattern = layer1 * 0.5 + layer2 * 0.3 + layer3 * 0.2;
    
    // 新規追加: 成長アニメーション
    let growth = sin(time * 0.5) * 0.3 + 0.7;
    let final_pattern = combined_pattern * growth;
    
    // 色の計算（前ステップから発展）
    var color = vec3(0.0, 0.0, 0.1); // 深い青の背景
    
    if final_pattern > 0.1 {
        // 花びらの色（薄いピンク）
        color = vec3(0.9, 0.7, 0.8) * final_pattern;
    }
    
    // 新規追加: 中心部のグロー効果
    let center_glow = exp(-distance * 3.0) * 0.3;
    color += vec3(1.0, 0.9, 0.9) * center_glow;
    
    return vec4(ToLinearRgb(color), 1.0);
}

// 解説:
// - 前ステップの花びら形状計算を関数化
// - 新規追加: 複数レイヤー（8枚、12枚、16枚の花びら）
// - 新規追加: 各レイヤーの独立した回転アニメーション
// - 新規追加: 成長アニメーション効果
// - 新規追加: 中心部のグロー効果
// - 次のステップで、より高度な色彩システムを追加