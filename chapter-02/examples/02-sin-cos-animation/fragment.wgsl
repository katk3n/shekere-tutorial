// Chapter 2 Example 2: sin/cos三角関数アニメーション
// UV座標と時間を組み合わせた波動パターン

@fragment
fn fs_main(in: VertexOutput) -> @location(0) vec4<f32> {
    let uv = NormalizedCoords(in.position.xy);
    let time = Time.duration;
    
    // X方向の波動（左右に移動する波）
    let wave_x = sin(uv.x * 5.0 + time * 2.0);
    
    // Y方向の波動（上下に移動する波）
    let wave_y = cos(uv.y * 3.0 + time * 1.5);
    
    // 両方の波動を組み合わせる
    let combined_wave = wave_x * wave_y;
    
    // -1〜1 の範囲を 0〜1 の範囲に変換
    let intensity = (combined_wave + 1.0) * 0.5;
    
    // 強度に応じて色を変化
    let color = vec3(
        intensity,           // 赤成分
        intensity * 0.8,     // 緑成分（少し弱く）
        intensity * 0.6      // 青成分（さらに弱く）
    );
    
    return vec4(ToLinearRgb(color), 1.0);
}

// 実験してみよう:
// 1. 波の密度を変える: * 8.0, * 2.0 で密度調整
// 2. 波の速度を変える: * 3.0, * 0.5 で速度調整  
// 3. 合成方法を変える: 乗算(*) を加算(+) に
// 4. 円形波を試す: length(uv) * 6.0 - time * 2.0