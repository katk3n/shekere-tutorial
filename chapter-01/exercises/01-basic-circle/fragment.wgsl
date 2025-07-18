// 演習 1: 基本の円を描く
// 目標: 画面中央に赤い円を描画する

@fragment
fn fs_main(in: VertexOutput) -> @location(0) vec4<f32> {
    // UV座標を取得（-1.0から1.0の範囲、中心が(0,0)）
    let uv = NormalizedCoords(in.position.xy);
    
    // 中心からの距離を計算
    let distance = length(uv);
    
    // 初期色を黒に設定
    var color = vec3(0.0);
    
    // 中心からの距離が0.5より小さい場合は円の内側
    if distance < 0.5 {
        color = vec3(1.0, 0.0, 0.0); // 赤色
    }
    // distance >= 0.5の場合は黒のまま（背景）
    
    return vec4(ToLinearRgb(color), 1.0);
}

// 解説:
// - NormalizedCoords(): UV座標を正規化された座標系で取得
// - length(uv): ベクトルの長さ（原点からの距離）を計算
// - 条件分岐により、距離に応じて色を変更
// - 結果: 中央に半径0.5の赤い円が描画される