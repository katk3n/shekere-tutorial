// Chapter 4 Solution 1: 基本的なマウス追従効果の解答例
// 演習課題1の様々な解答パターンを示すシェーダー

@fragment
fn fs_main(in: VertexOutput) -> @location(0) vec4<f32> {
    let uv = NormalizedCoords(in.position.xy);
    let mouse = MouseCoords();
    
    // 解答例を選択（以下のいずれかのコメントアウトを解除）
    
    // ===== 1-1-1. X座標のみで色変化 =====
    // let red = (mouse.x + 1.0) * 0.5;
    // let color = vec3(red, 0.3, 0.3);
    
    // ===== 1-1-2. Y座標のみで色変化 =====
    // let green = (mouse.y + 1.0) * 0.5;
    // let color = vec3(0.3, green, 0.3);
    
    // ===== 1-1-3. 反転効果 =====
    // let blue = 1.0 - (mouse.x + 1.0) * 0.5;  // X座標の反転
    // let color = vec3(0.3, 0.3, blue);
    
    // ===== 1-2-1. 中心からの距離による明度変化 =====
    // let center_distance = length(uv);
    // let brightness = 1.0 - clamp(center_distance, 0.0, 1.0);
    // let color = vec3(brightness, brightness, brightness);
    
    // ===== 1-2-2. マウスからの距離による色変化 =====
    // let mouse_distance = length(uv - mouse);
    // let normalized_distance = clamp(mouse_distance / 1.4, 0.0, 1.0);
    // let red = 1.0 - normalized_distance;
    // let blue = normalized_distance;
    // let color = vec3(red, 0.3, blue);
    
    // ===== 1-3-1. 虹色効果 =====
    // let hue = (mouse.x + 1.0) * 0.5;
    // let color = vec3(
    //     sin(hue * 6.28) * 0.5 + 0.5,
    //     sin(hue * 6.28 + 2.09) * 0.5 + 0.5,
    //     sin(hue * 6.28 + 4.19) * 0.5 + 0.5
    // );
    
    // ===== 1-3-2. スポットライト効果 =====
    // let spotlight_distance = length(uv - mouse);
    // let spotlight_radius = 0.3;
    // let spotlight_intensity = 1.0 - clamp(spotlight_distance / spotlight_radius, 0.0, 1.0);
    // let color = vec3(spotlight_intensity, spotlight_intensity, spotlight_intensity);
    
    // ===== 発展例: 複合効果 =====
    let mouse_distance = length(uv - mouse);
    let center_distance = length(uv);
    let angle = atan2(uv.y - mouse.y, uv.x - mouse.x);
    
    let red = 1.0 - clamp(mouse_distance, 0.0, 1.0);
    let green = sin(angle * 3.0) * 0.5 + 0.5;
    let blue = 1.0 - clamp(center_distance, 0.0, 1.0);
    let color = vec3(red, green, blue);
    
    return vec4(ToLinearRgb(color), 1.0);
}

// 使用方法:
// 1. 上記のコメントアウトを1つずつ解除して効果を確認
// 2. マウスを動かして各効果の動作を観察
// 3. 数値を変更して効果の変化を実験
// 4. 複数の効果を組み合わせた独自パターンを作成

// 学習ポイント:
// - (mouse.x + 1.0) * 0.5 で -1.0〜1.0 を 0.0〜1.0 に変換
// - length() で距離計算
// - clamp() で値の範囲制限
// - sin() で周期的な変化
// - atan2() で角度計算