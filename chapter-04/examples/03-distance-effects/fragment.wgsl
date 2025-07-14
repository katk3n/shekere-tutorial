// Chapter 4 Example 3: 距離ベースの色変化
// マウスカーソルからの距離に応じて色が変化するシェーダー

@fragment
fn fs_main(in: VertexOutput) -> @location(0) vec4<f32> {
    // 現在のピクセルの正規化座標を取得
    let uv = NormalizedCoords(in.position.xy);
    
    // マウスの正規化座標を取得
    let mouse = MouseCoords();
    
    // マウスカーソルから現在のピクセルまでの距離を計算
    let distance = length(uv - mouse);
    
    // 距離を0.0〜1.0の範囲に正規化（最大距離を約1.4と仮定）
    let normalized_distance = clamp(distance / 1.4, 0.0, 1.0);
    
    // 距離に応じた色の変化を作成
    // 近い場所（距離が小さい）: 赤色が強い
    // 遠い場所（距離が大きい）: 青色が強い
    // 中間の場所: 緑色が強い
    let red = 1.0 - normalized_distance;              // 距離が近いほど赤が強い
    let blue = normalized_distance;                   // 距離が遠いほど青が強い
    let green = sin(normalized_distance * 3.14159);   // 中間距離で緑が最大
    
    // 最終的な色を作成
    let color = vec3(red, green, blue);
    
    // 色空間を変換して出力
    return vec4(ToLinearRgb(color), 1.0);
}

// 期待される動作：
// - マウスカーソルの周辺は赤色が強く表示される
// - マウスカーソルから遠い場所は青色が強く表示される
// - 中間の距離では緑色が混じった色が表示される
// - マウスを動かすと色の分布がリアルタイムで変化する