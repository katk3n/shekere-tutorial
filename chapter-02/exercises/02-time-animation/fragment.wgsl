// Chapter 2 Exercise 2: 基本的な時間アニメーションの追加
// ステップ2: 静的パターンに時間要素を追加して動きを作る

@fragment
fn fs_main(in: VertexOutput) -> @location(0) vec4<f32> {
    let uv = NormalizedCoords(in.position.xy);
    let time = Time.duration;  // 初めて時間要素を使用
    
    // 中心からの距離と角度を計算
    let distance = length(uv);
    let angle = atan2(uv.y, uv.x);
    
    // 前ステップの静的パターンに時間要素を追加
    let circle_frequency = 8.0;
    let circle_pattern = sin(distance * circle_frequency - time * 2.0);  // 時間による移動
    
    let radial_frequency = 6.0;
    let radial_pattern = sin(angle * radial_frequency);  // 放射線は静的のまま
    
    // 2つのパターンを組み合わせ
    let combined_pattern = circle_pattern * 0.7 + radial_pattern * 0.3;
    
    // 値を0-1の範囲に正規化
    let intensity = (combined_pattern + 1.0) * 0.5;
    
    // 距離による減衰効果
    let attenuation = 1.0 - distance * 0.6;
    let final_intensity = intensity * attenuation;
    
    // 色も時間で少し変化させる
    let color_shift = sin(time * 0.5) * 0.2 + 0.8;  // 0.6〜1.0の範囲で変化
    let color = vec3(
        final_intensity * 0.6 * color_shift,  // 赤
        final_intensity * 0.4,                // 緑（固定）
        final_intensity                       // 青
    );
    
    return vec4(ToLinearRgb(color), 1.0);
}

// このステップで学ぶこと:
// 1. Time.duration の初回使用
// 2. 波動パターンに時間要素を追加: sin(pattern - time * speed)
// 3. 同心円の外向き移動アニメーション
// 4. 色の時間変化
// 5. 静的要素と動的要素の組み合わせ