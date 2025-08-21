// Chapter 1 Example 1: 単色表示
// 概念: ToLinearRgb()関数とRGB色空間の基本
// 目標: 画面全体を指定した色で塗りつぶす

@fragment
fn fs_main(in: VertexOutput) -> @location(0) vec4<f32> {
    // RGB色空間で赤色を定義
    let color = vec3(1.0, 0.0, 0.0); // R=1.0, G=0.0, B=0.0
    
    // ToLinearRgb()で色空間を正しく変換
    return vec4(ToLinearRgb(color), 1.0);
}

// 学習ポイント:
// - vec3(R, G, B): RGB値を0.0〜1.0で指定
// - ToLinearRgb(): sRGB→リニア色空間変換（必須）
// - アルファ値: 1.0で完全不透明

// 実験してみよう:
// vec3(0.0, 1.0, 0.0)  // 緑
// vec3(0.0, 0.0, 1.0)  // 青
// vec3(1.0, 1.0, 1.0)  // 白
// vec3(0.5, 0.5, 0.5)  // グレー