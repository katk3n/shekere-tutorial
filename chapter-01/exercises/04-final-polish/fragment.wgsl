// 演習 4: 最終調整とエフェクト - 太陽の輪（完成版）
// 目標: 「太陽の輪」作品を完成させる

@fragment
fn fs_main(in: VertexOutput) -> @location(0) vec4<f32> {
    // UV座標と基本パラメータを計算
    let uv = NormalizedCoords(in.position.xy);
    let distance = length(uv);
    let angle = atan2(uv.y, uv.x);
    
    // 初期色を背景色に設定
    var color = vec3(0.0);
    
    // 同心円パターン（3層のリング）
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
        // 背景: 深い紫（宇宙色）
        color = vec3(0.2, 0.1, 0.4);
    }
    
    // 放射状パターンを重ねる（8方向の光線）
    let radial_lines = sin(angle * 4.0) * 0.5 + 0.5;
    let line_intensity = step(0.7, radial_lines);
    
    // ラインを白色で描画（中心の小さな円は除く）
    if line_intensity > 0.5 && distance > 0.1 {
        color = mix(color, vec3(1.0), 0.6);
    }
    
    // 中心に小さな白い円を追加（太陽の核心）
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
// 技術要素:
// - length()で中心からの距離を計算
// - atan2()で角度を取得し放射状パターンを作成
// - if文で距離による領域分け
// - mix()関数で色のブレンド
// - smoothstep()で縁のグラデーション効果
//
// Chapter 1で学習した要素の統合:
// ✓ UV座標システム
// ✓ 距離計算と条件分岐
// ✓ 角度計算と三角関数
// ✓ 色の合成とブレンド
// ✓ 滑らかなグラデーション