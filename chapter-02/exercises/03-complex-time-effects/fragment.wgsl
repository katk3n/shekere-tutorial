// Chapter 2 Exercise 3: より複雑な時間効果の追加
// ステップ3: 基本アニメーションに螺旋効果と回転を追加

@fragment
fn fs_main(in: VertexOutput) -> @location(0) vec4<f32> {
    let uv = NormalizedCoords(in.position.xy);
    let time = Time.duration;
    
    // 中心からの距離と角度を計算
    let distance = length(uv);
    let angle = atan2(uv.y, uv.x);
    
    // 前ステップのアニメーション（同心円の外向き移動）
    let circle_frequency = 8.0;
    let circle_pattern = sin(distance * circle_frequency - time * 2.0);
    
    // 前ステップの放射線に回転アニメーションを追加
    let radial_frequency = 6.0;
    let radial_pattern = sin(angle * radial_frequency + time * 1.0);  // 回転追加
    
    // 新しい要素: 螺旋パターン
    let spiral_frequency = 4.0;
    let spiral_arms = 3.0;
    let spiral_speed = 1.5;
    let spiral_pattern = sin(distance * spiral_frequency + angle * spiral_arms + time * spiral_speed);
    
    // 3つのパターンを組み合わせ
    let combined_pattern = circle_pattern * 0.4 + radial_pattern * 0.3 + spiral_pattern * 0.3;
    
    // 値を0-1の範囲に正規化
    let intensity = (combined_pattern + 1.0) * 0.5;
    
    // 距離による減衰効果
    let attenuation = 1.0 - distance * 0.6;
    let final_intensity = intensity * attenuation;
    
    // より複雑な色の時間変化
    let color_shift = sin(time * 0.5) * 0.2 + 0.8;
    let hue_rotation = time * 0.3;
    let red = (sin(final_intensity * 6.28 + hue_rotation) + 1.0) * 0.5;
    let green = (sin(final_intensity * 6.28 + hue_rotation + 2.09) + 1.0) * 0.5;
    let blue = (sin(final_intensity * 6.28 + hue_rotation + 4.19) + 1.0) * 0.5;
    
    let color = vec3(red, green, blue) * final_intensity * color_shift;
    
    return vec4(ToLinearRgb(color), 1.0);
}

// このステップで学ぶこと:
// 1. 螺旋パターンの作成: sin(distance + angle + time)
// 2. 回転アニメーション: sin(angle + time)
// 3. 複数の時間効果の組み合わせ
// 4. 色相回転による動的な色変化
// 5. より複雑な時間アニメーションの実現