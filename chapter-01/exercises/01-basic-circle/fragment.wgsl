// 演習 1: 基本の円を描く
// 目標: Chapter1基本技術の統合作品「太陽の輪」制作 - 第1段階
// 段階目標: UV座標とlength()関数で中心に基本の太陽円を描画

@fragment
fn fs_main(in: VertexOutput) -> @location(0) vec4<f32> {
    // UV座標を取得（-1.0から1.0の範囲、中心が(0,0)）
    let uv = NormalizedCoords(in.position.xy);
    
    // 中心からの距離を計算
    let distance = length(uv);
    
    // 基本の太陽円を描画
    var color = vec3(0.0, 0.0, 0.2); // 背景: 深い宇宙色
    
    // 太陽の本体（半径0.7の温かい光）
    if distance < 0.7 {
        color = vec3(1.0, 0.6, 0.0); // 温かいオレンジ色
    }
    
    return vec4(ToLinearRgb(color), 1.0);
}

// 【新規実装技術】:
// - NormalizedCoords(): UV座標系の取得
// - length(uv): 中心からの距離計算（距離関数の基礎）
// - 条件分岐による領域分割
// - 天体をイメージした色彩設計

// 【作品進行】:
// 第1段階: 単純な円形太陽 ← 今ここ
// 第2段階: 同心円による層構造
// 第3段階: 放射状光線の追加  
// 第4段階: 完成（グラデーション・細部調整）