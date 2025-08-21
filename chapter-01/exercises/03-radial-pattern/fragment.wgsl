// 演習 3: 放射状パターンを加える
// 目標: Chapter1基本技術の統合作品「太陽の輪」制作 - 第3段階
// 段階目標: 前ステップの同心円太陽にatan2()とsin()で放射状光線を追加

@fragment
fn fs_main(in: VertexOutput) -> @location(0) vec4<f32> {
    // 【前ステップから継承】: 基本設定と同心円構造
    let uv = NormalizedCoords(in.position.xy);
    let distance = length(uv);
    var color = vec3(0.0, 0.0, 0.2); // 背景: 深い宇宙色
    
    // 【前ステップから継承】: 同心円による太陽の層構造
    if distance < 0.25 {
        color = vec3(1.0, 0.9, 0.7); // 太陽の核心
    } else if distance < 0.45 {
        color = vec3(1.0, 0.7, 0.2); // 太陽の中間層
    } else if distance < 0.7 {
        color = vec3(1.0, 0.6, 0.0); // 太陽の外層
    }
    
    // 【新規追加】: 角度計算による放射状光線
    let angle = atan2(uv.y, uv.x); // -π から π の範囲
    
    // 【新規追加】: sin()による8方向の光線パターン
    let radial_pattern = sin(angle * 4.0) * 0.5 + 0.5; // 0〜1範囲の波形
    let light_rays = step(0.75, radial_pattern); // 0.75以上で光線
    
    // 【新規追加】: 光線を太陽領域に重ね合わせ
    if light_rays > 0.5 && distance > 0.1 && distance < 0.9 {
        color = mix(color, vec3(1.0, 1.0, 0.8), 0.7); // 明るい光線効果
    }
    
    return vec4(ToLinearRgb(color), 1.0);
}

// 【前ステップから継承】:
// - UV座標系、distance計算、宇宙背景
// - 3層同心円による太陽構造（核心・中間層・外層）

// 【新規追加技術】:
// - atan2(uv.y, uv.x): 角度計算（極座標系の導入）
// - sin(angle * 4.0): 角度による周期的パターン生成
// - step(): 閾値による二値化（光線の境界作成）
// - mix(): 色の合成（光線効果の重ね合わせ）

// 【作品進行】:
// 第1段階: 単純な円形太陽 ✓
// 第2段階: 同心円による層構造 ✓
// 第3段階: 放射状光線の追加 ← 今ここ
// 第4段階: 完成（グラデーション・細部調整）