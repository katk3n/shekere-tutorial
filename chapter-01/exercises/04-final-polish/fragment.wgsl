// 演習 4: 最終調整とエフェクト
// 目標: Chapter1基本技術の統合作品「太陽の輪」制作 - 第4段階（完成）
// 段階目標: 前ステップの太陽にsmoothstep()でプロ品質のグラデーション効果を追加

@fragment
fn fs_main(in: VertexOutput) -> @location(0) vec4<f32> {
    // 【前ステップから継承】: 基本設定
    let uv = NormalizedCoords(in.position.xy);
    let distance = length(uv);
    let angle = atan2(uv.y, uv.x);
    var color = vec3(0.0, 0.0, 0.2); // 背景: 深い宇宙色
    
    // 【前ステップから継承】: 3層同心円構造
    if distance < 0.25 {
        color = vec3(1.0, 0.9, 0.7); // 太陽の核心
    } else if distance < 0.45 {
        color = vec3(1.0, 0.7, 0.2); // 太陽の中間層
    } else if distance < 0.7 {
        color = vec3(1.0, 0.6, 0.0); // 太陽の外層
    }
    
    // 【前ステップから継承】: 放射状光線
    let radial_pattern = sin(angle * 4.0) * 0.5 + 0.5;
    let light_rays = step(0.75, radial_pattern);
    if light_rays > 0.5 && distance > 0.1 && distance < 0.9 {
        color = mix(color, vec3(1.0, 1.0, 0.8), 0.7);
    }
    
    // 【新規追加】: 太陽コロナ（外側の柔らかな光）
    if distance > 0.7 && distance < 1.1 {
        let corona_intensity = smoothstep(1.1, 0.7, distance); // 外側へ向かって減衰
        let corona_color = vec3(1.0, 0.8, 0.4); // 温かいコロナ色
        color = mix(color, corona_color, corona_intensity * 0.3);
    }
    
    // 【新規追加】: 画面端への柔らかなフェード（視覚的洗練）
    let edge_fade = smoothstep(1.2, 1.4, distance);
    color = mix(color, vec3(0.0, 0.0, 0.1), edge_fade);
    
    // 【新規追加】: 太陽中心の白熱コア
    if distance < 0.15 {
        let core_glow = smoothstep(0.15, 0.0, distance);
        color = mix(color, vec3(1.0, 1.0, 1.0), core_glow * 0.8);
    }
    
    return vec4(ToLinearRgb(color), 1.0);
}

// 【前ステップから継承】:
// - UV座標系、distance・angle計算
// - 3層同心円による太陽構造
// - 8方向放射状光線

// 【新規追加技術】:
// - smoothstep(): 滑らかな補間関数（プロ品質のグラデーション）
// - 太陽コロナ効果: 外側への自然な減衰
// - 複数レイヤーの色合成: mix()の高度な応用
// - 中心白熱効果: 距離による強度変化

// 【完成作品 - Chapter 1技術の統合】:
// ✓ UV座標システム (NormalizedCoords)
// ✓ 距離計算 (length) と条件分岐
// ✓ 角度計算 (atan2) と三角関数 (sin)  
// ✓ 色の合成とブレンド (mix)
// ✓ プロ品質のグラデーション (smoothstep)
// 
// 【作品進行】:
// 第1段階: 単純な円形太陽 ✓
// 第2段階: 同心円による層構造 ✓  
// 第3段階: 放射状光線の追加 ✓
// 第4段階: 完成（グラデーション・細部調整）← 今ここ ✓