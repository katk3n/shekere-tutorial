// Chapter 2 Exercise 1: 静的パターンの作成
// ステップ1: 時間要素なしの静的な波動パターンを作成

@fragment
fn fs_main(in: VertexOutput) -> @location(0) vec4<f32> {
    let uv = NormalizedCoords(in.position.xy);
    
    // 中心からの距離と角度を計算
    let distance = length(uv);
    let angle = atan2(uv.y, uv.x);
    
    // 静的な同心円パターン（時間要素なし）
    let circle_frequency = 8.0;
    let circle_pattern = sin(distance * circle_frequency);
    
    // 静的な放射状パターン（時間要素なし）
    let radial_frequency = 6.0;
    let radial_pattern = sin(angle * radial_frequency);
    
    // 2つのパターンを組み合わせ
    let combined_pattern = circle_pattern * 0.7 + radial_pattern * 0.3;
    
    // 値を0-1の範囲に正規化
    let intensity = (combined_pattern + 1.0) * 0.5;
    
    // 距離による減衰効果
    let attenuation = 1.0 - distance * 0.6;
    let final_intensity = intensity * attenuation;
    
    // 静的な色（青紫系）
    let color = vec3(
        final_intensity * 0.6,  // 赤
        final_intensity * 0.4,  // 緑
        final_intensity         // 青
    );
    
    return vec4(ToLinearRgb(color), 1.0);
}

// このステップで学ぶこと:
// 1. 静的な波動パターンの作成
// 2. 同心円パターン: sin(distance * frequency)
// 3. 放射状パターン: sin(angle * frequency)
// 4. パターンの組み合わせ技術
// 5. 距離による減衰効果
// 注意: まだ時間要素（Time.duration）は使用しない