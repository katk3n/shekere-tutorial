// 演習 1: 基本的な座標変換
// 「花の生命力 - Flower of Life」作品への第1ステップ
// 目標: 基本的な座標変換で花びらの準備となる図形を作成する

@fragment
fn fs_main(in: VertexOutput) -> @location(0) vec4<f32> {
    let uv = NormalizedCoords(in.position.xy);
    
    // ステップ1: 基本的な対称化
    // 花びらパターンの基礎となる対称図形を作成
    let symmetric_uv = abs(uv);
    let distance = length(symmetric_uv);
    
    // 楕円形の花びらの種となる形状
    let scaled_uv = vec2(symmetric_uv.x * 1.5, symmetric_uv.y * 0.8);
    let ellipse_distance = length(scaled_uv);
    
    // 花びらの基本形状
    var color = vec3(0.0, 0.0, 0.1); // 深い青の背景
    
    if ellipse_distance < 0.4 {
        // 薄いピンクの花びらの種
        color = vec3(0.9, 0.7, 0.8);
    }
    
    return vec4(ToLinearRgb(color), 1.0);
}

// 解説:
// - abs(uv): 座標を対称化し、4つの象限に同じ図形を作成
// - スケーリング: X方向に1.5倍、Y方向に0.8倍で楕円形に変形
// - 次のステップで、この基本形状に距離・角度関数を適用していく