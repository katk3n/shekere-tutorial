// Exercise 3 Solution: 創作課題
// テーマA: 幾何学パターン - 同心円と放射状パターンの組み合わせ

@fragment
fn fs_main(in: VertexOutput) -> @location(0) vec4<f32> {
    let uv = NormalizedCoords(in.position.xy);
    
    // 中心からの距離と角度を計算
    let distance = length(uv);
    let angle = atan2(uv.y, uv.x);
    
    var color = vec3(0.0);
    
    // 同心円パターン (3層のリング)
    if distance < 0.3 {
        // 内側の円: 温かい赤
        color = vec3(1.0, 0.3, 0.1);
    } else if distance < 0.6 {
        // 中間のリング: 黄色
        color = vec3(1.0, 0.8, 0.0);
    } else if distance < 0.9 {
        // 外側のリング: オレンジ
        color = vec3(1.0, 0.5, 0.0);
    } else {
        // 背景: 深い紫
        color = vec3(0.2, 0.1, 0.4);
    }
    
    // 放射状パターンを重ねる (8方向)
    let radial_lines = sin(angle * 4.0) * 0.5 + 0.5;
    let line_intensity = step(0.7, radial_lines);
    
    // ラインを白色で描画
    if line_intensity > 0.5 && distance > 0.1 {
        color = mix(color, vec3(1.0), 0.6);
    }
    
    // 中心に小さな白い円を追加
    if distance < 0.1 {
        color = vec3(1.0, 1.0, 1.0);
    }
    
    // 縁のグラデーションで柔らかさを追加
    let edge_fade = smoothstep(0.95, 1.0, distance);
    color = mix(color, vec3(0.0), edge_fade);
    
    return vec4(ToLinearRgb(color), 1.0);
}

// 作品解説:
// タイトル: 「太陽の輪」
// テーマ: 幾何学パターン
//
// 制作意図:
// 太陽の光と熱を同心円と放射状パターンで表現。
// 中心から外側に向かって赤→黄→オレンジと変化し、
// 放射状の白いラインで光線を表現。
//
// 技術的な工夫:
// - length()で中心からの距離を計算
// - atan2()で角度を取得し放射状パターンを作成
// - if文で距離による領域分け
// - mix()関数で色のブレンド
// - smoothstep()で縁のグラデーション効果