// Chapter 2 Solution 2: sin/cosを使った様々なパターン
// 課題2-2-3「螺旋パターン」の解答例

@fragment
fn fs_main(in: VertexOutput) -> @location(0) vec4<f32> {
    let uv = NormalizedCoords(in.position.xy);
    let time = Time.duration;
    
    // 中心からの距離と角度を計算
    let distance = length(uv);
    let angle = atan2(uv.y, uv.x);
    
    // 螺旋パターン: 距離と角度を組み合わせた螺旋効果
    let spiral_frequency = 6.0;  // 螺旋の密度
    let spiral_speed = 2.0;      // 螺旋の回転速度
    let spiral_pattern = sin(distance * spiral_frequency + angle * 3.0 + time * spiral_speed);
    
    // 同心円パターン: 中心から広がる円形波動
    let circle_frequency = 12.0;  // 円の密度
    let circle_speed = 3.0;       // 円の拡散速度
    let circle_pattern = sin(distance * circle_frequency - time * circle_speed);
    
    // 放射状パターン: 中心から放射状に広がる波動
    let radial_frequency = 8.0;   // 放射の本数
    let radial_speed = 1.5;       // 放射の変化速度
    let radial_pattern = sin(angle * radial_frequency + time * radial_speed);
    
    // 複合パターン: 複数の波動を重ね合わせ
    let combined_pattern = spiral_pattern * 0.5 + circle_pattern * 0.3 + radial_pattern * 0.2;
    
    // 距離による減衰効果（中心が明るく、端が暗く）
    let attenuation = 1.0 - distance * 0.6;
    let final_intensity = (combined_pattern + 1.0) * 0.5 * attenuation;
    
    // 時間による色相変化
    let hue_shift = time * 0.2;
    let red = (sin(final_intensity * 6.28 + hue_shift) + 1.0) * 0.5;
    let green = (sin(final_intensity * 6.28 + hue_shift + 2.09) + 1.0) * 0.5;
    let blue = (sin(final_intensity * 6.28 + hue_shift + 4.19) + 1.0) * 0.5;
    
    // 最終的な色の計算
    let color = vec3(red, green, blue) * final_intensity;
    
    return vec4(ToLinearRgb(color), 1.0);
}

// 解答例の特徴:
// 1. 螺旋パターン: distance * frequency + angle * 係数 で螺旋を生成
// 2. 同心円パターン: distance * frequency - time * speed で円形波動
// 3. 放射状パターン: angle * frequency で放射状の効果
// 4. 複合パターン: 複数の波動を重み付けして合成
// 5. 距離による減衰: 1.0 - distance * 係数 で自然な減衰
// 6. 色相変化: 時間による色の回転効果
//
// 学習のポイント:
// - length(uv)とatan2()の極座標系での活用
// - 複数の波動の重ね合わせ技術
// - 重み付け合成による効果の調整
// - 減衰効果による自然な表現
// - 色相変化による動的な色彩効果