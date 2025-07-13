// Chapter 1 Example 3: UV座標の可視化
// 座標系の理解を深めるため、UV座標を色として表示

@fragment
fn fs_main(in: VertexOutput) -> @location(0) vec4<f32> {
    // 正規化座標を取得 (-1.0 〜 1.0の範囲)
    let uv = NormalizedCoords(in.position.xy);
    
    // 座標値を可視化
    // 負の値も表示するため絶対値を使用
    let color = vec3(
        abs(uv.x),  // X座標の絶対値を赤成分に
        abs(uv.y),  // Y座標の絶対値を緑成分に
        0.5         // 青成分は固定値
    );
    
    return vec4(ToLinearRgb(color), 1.0);
}

// 観察してみよう:
// - 画面中央(0,0)は黒色
// - 画面右端(x=1.0)は赤色が強い
// - 画面上端(y=1.0)は緑色が強い
// - 画面右上角は黄色（赤+緑）

// 他のパターンも試してみよう:
// vec3(uv.x, uv.y, 0.0)  // 負の値も表示
// vec3((uv.x + 1.0) * 0.5, (uv.y + 1.0) * 0.5, 0.0)  // 0-1範囲に変換