// 演習 2: 距離と角度によるパターン
// 「花の生命力 - Flower of Life」作品への第2ステップ
// 目標: 前ステップの基本図形に距離・角度関数を適用して花びらの形状を作成

const PI = 3.14159265359;

@fragment
fn fs_main(in: VertexOutput) -> @location(0) vec4<f32> {
    let uv = NormalizedCoords(in.position.xy);
    
    // 前ステップからの基礎: 対称化
    let symmetric_uv = abs(uv);
    
    // 新規追加: 距離と角度の計算
    let distance = length(uv);
    let angle = atan2(uv.y, uv.x);
    
    // 新規追加: 花びらの形状を作るための角度関数
    let petal_count = 8.0;
    let petal_shape = sin(angle * petal_count * 0.5);
    let petal_radius = 0.4 + petal_shape * 0.15;
    
    // 花びらマスクの作成
    let petal_mask = 1.0 - smoothstep(petal_radius - 0.05, petal_radius + 0.05, distance);
    
    // 色の計算
    var color = vec3(0.0, 0.0, 0.1); // 深い青の背景
    
    if petal_mask > 0.1 {
        // 花びらの色（薄いピンク）
        color = vec3(0.9, 0.7, 0.8) * petal_mask;
    }
    
    return vec4(ToLinearRgb(color), 1.0);
}

// 解説:
// - 前ステップの対称化を保持
// - 新規追加: atan2()で角度を計算
// - 新規追加: sin(angle * count)で花びらの形状を作成
// - smoothstep()で滑らかなエッジを実現
// - 次のステップで、複数レイヤーとアニメーションを追加