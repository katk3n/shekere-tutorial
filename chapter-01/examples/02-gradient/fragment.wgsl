// Chapter 1 Example 2: グラデーション
// UV座標を利用して画面にグラデーション効果を作成

@fragment
fn fs_main(in: VertexOutput) -> @location(0) vec4<f32> {
    // 正規化座標を取得 (-1.0 〜 1.0の範囲)
    let uv = NormalizedCoords(in.position.xy);
    
    // X座標を赤成分、Y座標を緑成分に変換
    // -1.0〜1.0 を 0.0〜1.0 の範囲に変換
    let red = (uv.x + 1.0) * 0.5;
    let green = (uv.y + 1.0) * 0.5;
    let blue = 0.2; // 青成分は固定値
    
    let color = vec3(red, green, blue);
    
    return vec4(ToLinearRgb(color), 1.0);
}

// 実験してみよう:
// 1. blue成分を変更してみる
// 2. redとgreenを入れ替えてみる  
// 3. uv.x * uv.y のような計算を試してみる