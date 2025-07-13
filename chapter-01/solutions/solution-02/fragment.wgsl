// Exercise 2 Solution: グラデーションの変化
// 様々な方向とパターンのグラデーション解答例

@fragment
fn fs_main(in: VertexOutput) -> @location(0) vec4<f32> {
    let uv = NormalizedCoords(in.position.xy);
    
    var color = vec3(0.0);
    
    // 2-1-1. 横方向のグラデーション (左:黒 → 右:白)
    // let intensity = (uv.x + 1.0) * 0.5;  // -1~1 を 0~1 に変換
    // color = vec3(intensity);
    
    // 2-1-2. 縦方向のグラデーション (下:黒 → 上:白)
    // let intensity = (uv.y + 1.0) * 0.5;
    // color = vec3(intensity);
    
    // 2-1-3. 対角線グラデーション (左下:黒 → 右上:白)
    // let intensity = ((uv.x + uv.y) + 2.0) * 0.25;  // 範囲調整
    // color = vec3(intensity);
    
    // 2-2-1. 赤から青へのグラデーション
    // let t = (uv.x + 1.0) * 0.5;
    // color = vec3(1.0 - t, 0.0, t);  // 赤から青へ
    
    // 2-2-2. 虹色グラデーション
    // let t = (uv.x + 1.0) * 0.5;
    // if t < 0.5 {
    //     color = vec3(1.0, t * 2.0, 0.0);  // 赤→黄
    // } else {
    //     color = vec3(2.0 - t * 2.0, 1.0, (t - 0.5) * 2.0);  // 黄→緑→青
    // }
    
    // 2-3-1. 中心からの距離グラデーション (円形グラデーション)
    let distance = length(uv);
    let intensity = 1.0 - clamp(distance, 0.0, 1.0);
    color = vec3(intensity);
    
    // 発展課題の例
    // 波状グラデーション
    // let wave = sin(uv.x * 10.0) * 0.5 + 0.5;
    // color = vec3(wave, 0.5, 1.0 - wave);
    
    // チェッカーパターン
    // let checker_x = step(0.5, fract((uv.x + 1.0) * 4.0));
    // let checker_y = step(0.5, fract((uv.y + 1.0) * 4.0));
    // let checker = abs(checker_x - checker_y);
    // color = vec3(checker);
    
    return vec4(ToLinearRgb(color), 1.0);
}

// 学習ポイント:
// - clamp()関数で値の範囲を制限
// - fract()関数で小数部分を取得（繰り返しパターンに有効）
// - step()関数で閾値による二値化
// - 条件分岐で複雑なグラデーションを作成