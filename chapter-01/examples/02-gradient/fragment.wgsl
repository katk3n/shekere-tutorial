// Chapter 1 Example 2: グラデーション
// 概念: UV座標による色の線形補間
// 目標: 座標値を直接色に変換してグラデーション効果を作成

@fragment
fn fs_main(in: VertexOutput) -> @location(0) vec4<f32> {
    // 正規化座標を取得 (-1.0 〜 1.0の範囲)
    let uv = NormalizedCoords(in.position.xy);
    
    // 座標値を0.0〜1.0の色範囲に変換
    let horizontal_gradient = (uv.x + 1.0) * 0.5; // 左=0.0, 右=1.0
    
    // 水平グラデーション: 左が黒、右が赤
    let color = vec3(horizontal_gradient, 0.0, 0.0);
    
    return vec4(ToLinearRgb(color), 1.0);
}

// 学習ポイント:
// - NormalizedCoords(): -1.0〜1.0の正規化座標を取得
// - (uv.x + 1.0) * 0.5: -1〜1 → 0〜1 への範囲変換
// - 座標値をそのまま色成分に使用してグラデーション作成

// 実験してみよう:
// vec3(0.0, horizontal_gradient, 0.0)  // 緑のグラデーション
// vec3(horizontal_gradient, horizontal_gradient, 0.0)  // 黄色のグラデーション