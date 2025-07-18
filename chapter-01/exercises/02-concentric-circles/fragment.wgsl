// 演習 2: 同心円パターンを作る
// 目標: 3層のカラフルな同心円を描画する

@fragment
fn fs_main(in: VertexOutput) -> @location(0) vec4<f32> {
    // UV座標を取得
    let uv = NormalizedCoords(in.position.xy);
    
    // 中心からの距離を計算
    let distance = length(uv);
    
    // 初期色を黒に設定（背景色）
    var color = vec3(0.0);
    
    // 距離による同心円パターンの作成
    if distance < 0.3 {
        // 内側の円: 温かい赤色（太陽の中心部）
        color = vec3(1.0, 0.3, 0.1);
    } else if distance < 0.6 {
        // 中間のリング: 明るい黄色（太陽の中間層）
        color = vec3(1.0, 0.8, 0.0);
    } else if distance < 0.9 {
        // 外側のリング: 鮮やかなオレンジ色（太陽の外層）
        color = vec3(1.0, 0.5, 0.0);
    }
    // distance >= 0.9 の場合は黒のまま（宇宙の背景）
    
    return vec4(ToLinearRgb(color), 1.0);
}

// 解説:
// - else if文を使って複数の条件分岐を実現
// - 距離によって3つの異なる色の領域を作成
// - 太陽をイメージした赤→黄→オレンジの色構成
// - 結果: 中央から外側に向かって色が変化する同心円