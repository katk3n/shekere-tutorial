// Chapter 1 Example 1: 単色表示
// 画面全体を指定した色で塗りつぶす最もシンプルなシェーダー

@fragment
fn fs_main(in: VertexOutput) -> @location(0) vec4<f32> {
    // 赤色を定義 (R=1.0, G=0.0, B=0.0)
    let color = vec3(1.0, 0.0, 0.0);
    
    // ToLinearRgb()で色空間を正しく変換してから返す
    return vec4(ToLinearRgb(color), 1.0);
}

// 他の色を試してみよう:
// vec3(0.0, 1.0, 0.0)  // 緑
// vec3(0.0, 0.0, 1.0)  // 青  
// vec3(1.0, 1.0, 0.0)  // 黄
// vec3(1.0, 0.0, 1.0)  // マゼンタ
// vec3(0.0, 1.0, 1.0)  // シアン
// vec3(1.0, 1.0, 1.0)  // 白
// vec3(0.5, 0.5, 0.5)  // グレー