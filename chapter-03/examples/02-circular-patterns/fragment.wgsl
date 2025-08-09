// Chapter 3 Example 2: 円形パターン
// length()関数の基本使用法 - 中心からの距離による同心円パターン

@fragment
fn fs_main(in: VertexOutput) -> @location(0) vec4<f32> {
    // 正規化座標を取得
    let uv = NormalizedCoords(in.position.xy);
    
    // 中心からの距離を計算
    let distance = length(uv);
    
    // 同心円パターンの作成
    let ring_pattern = fract(distance * 5.0);  // 5つの同心円
    
    // 距離に応じた基本的な色
    let intensity = ring_pattern;
    let color = vec3(intensity, intensity * 0.7, intensity * 0.4);
    
    return vec4(ToLinearRgb(color), 1.0);
}

// 学習ポイント:
// - length(uv): 中心からの距離を計算（0.0〜約1.4の範囲）
// - fract(distance * n): 距離を周期化して繰り返しパターンを作成
// - 距離値をそのまま色の強度として使用