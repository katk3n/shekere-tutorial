// Chapter 2 Example 1: 基本的な時間アニメーション
// Time.durationを使って時間に応じて色を変化させる

@fragment
fn fs_main(in: VertexOutput) -> @location(0) vec4<f32> {
    // 経過時間を取得
    let time = Time.duration;
    
    // 時間に応じて色成分を変化させる
    // sin関数で -1〜1 の範囲を 0〜1 の範囲に変換
    let red = (sin(time) + 1.0) * 0.5;
    let green = (sin(time + 2.0) + 1.0) * 0.5;  // 位相を2秒ずらす
    let blue = (sin(time + 4.0) + 1.0) * 0.5;   // 位相を4秒ずらす
    
    let color = vec3(red, green, blue);
    return vec4(ToLinearRgb(color), 1.0);
}

// 実験してみよう:
// 1. 時間速度を変える: sin(time * 2.0) で2倍速に
// 2. 位相差を変える: +1.0, +2.0 で異なる色の変化
// 3. 振幅を変える: * 0.3 で弱い変化に
// 4. 全体の明度を変える: + 0.2 で明るく