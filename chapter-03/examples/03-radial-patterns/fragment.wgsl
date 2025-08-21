// Chapter 3 Example 3: 放射状パターン
// atan2()関数の基本使用法 - 角度による放射線パターン

const PI = 3.14159265359;

@fragment
fn fs_main(in: VertexOutput) -> @location(0) vec4<f32> {
    // 正規化座標を取得
    let uv = NormalizedCoords(in.position.xy);
    
    // 角度を計算 (-π 〜 π)
    let angle = atan2(uv.y, uv.x);
    
    // 角度を0〜1の範囲に正規化
    let normalized_angle = (angle + PI) / (2.0 * PI);
    
    // 放射線パターンの作成
    let ray_pattern = fract(normalized_angle * 8.0);  // 8本の放射線
    
    // 角度に応じた基本的な色
    let intensity = step(ray_pattern, 0.5);  // 0.5未満を1.0、以上を0.0
    let color = vec3(intensity * 0.8, intensity * 0.6, intensity * 1.0);
    
    return vec4(ToLinearRgb(color), 1.0);
}

// 学習ポイント:
// - atan2(uv.y, uv.x): 角度を計算（-π〜πの範囲）
// - 角度の正規化: 0〜1の使いやすい範囲に変換
// - fract(angle * n): 角度を周期化して放射状パターンを作成