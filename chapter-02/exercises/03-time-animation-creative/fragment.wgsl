// Chapter 2 Solution 3: 創作課題の例
// テーマ: 「海の波」の表現

@fragment
fn fs_main(in: VertexOutput) -> @location(0) vec4<f32> {
    let uv = NormalizedCoords(in.position.xy);
    let time = Time.duration;
    
    // 海面の基本的な波動（複数の波の重ね合わせ）
    let wave1 = sin(uv.x * 3.0 + time * 1.2);           // 大きな波
    let wave2 = sin(uv.x * 8.0 + time * 2.5) * 0.5;     // 中程度の波
    let wave3 = sin(uv.x * 15.0 + time * 4.0) * 0.3;    // 小さな波
    
    // 縦方向の波動（潮の満ち引きのような効果）
    let tide = sin(uv.y * 2.0 + time * 0.8) * 0.4;
    
    // 全体の波動パターン
    let ocean_wave = wave1 + wave2 + wave3 + tide;
    
    // 距離による波の減衰（遠くの波は小さく）
    let distance_from_center = length(uv);
    let wave_attenuation = 1.0 - distance_from_center * 0.3;
    let final_wave = ocean_wave * wave_attenuation;
    
    // 時間による一日の色変化（朝→昼→夕→夜）
    let day_cycle = time * 0.1;  // ゆっくりとした一日の変化
    let day_phase = fract(day_cycle);
    
    // 基本の海の色
    let ocean_blue = vec3(0.1, 0.4, 0.8);
    let ocean_green = vec3(0.2, 0.6, 0.7);
    
    // 一日の時間帯による色変化
    var base_color = ocean_blue;
    if (day_phase < 0.25) {
        // 朝: 青から青緑へ
        base_color = mix(ocean_blue, ocean_green, day_phase * 4.0);
    } else if (day_phase < 0.5) {
        // 昼: 明るい青
        let brightness = 1.0 + (day_phase - 0.25) * 2.0;
        base_color = ocean_blue * brightness;
    } else if (day_phase < 0.75) {
        // 夕: 青からオレンジがかった色へ
        let sunset_color = vec3(0.6, 0.5, 0.3);
        let t = (day_phase - 0.5) * 4.0;
        base_color = mix(ocean_blue, sunset_color, t);
    } else {
        // 夜: 暗い青
        let night_color = vec3(0.05, 0.1, 0.3);
        let t = (day_phase - 0.75) * 4.0;
        base_color = mix(ocean_blue, night_color, t);
    }
    
    // 波の高さによる明度変化（波の山は明るく、谷は暗く）
    let wave_intensity = (final_wave + 1.0) * 0.5;  // 0〜1の範囲
    let brightness_variation = wave_intensity * 0.4 + 0.6;  // 0.6〜1.0の範囲
    
    // 泡や光の反射効果（波の頂点で白っぽく）
    let foam_threshold = 0.7;
    let foam_intensity = max(0.0, wave_intensity - foam_threshold) * 5.0;
    let foam_color = vec3(1.0, 1.0, 1.0);
    
    // 最終的な色の計算
    let water_color = base_color * brightness_variation;
    let final_color = mix(water_color, foam_color, foam_intensity);
    
    // 全体の明度調整
    let global_brightness = 0.8 + sin(time * 0.3) * 0.2;  // 微妙な明度変化
    let result = final_color * global_brightness;
    
    return vec4(ToLinearRgb(result), 1.0);
}

// 創作作品の特徴:
// テーマ: 「海の波」
// 
// 1. 自然現象の表現:
//    - 複数の波動の重ね合わせで海面の複雑な動きを表現
//    - 異なる周波数と振幅の波を組み合わせて自然な波動を生成
//
// 2. 時間による変化:
//    - 一日の時間帯による色の変化（朝→昼→夕→夜）
//    - 潮の満ち引きのような縦方向の波動
//
// 3. 空間的な効果:
//    - 距離による波の減衰で遠近感を表現
//    - 波の高さによる明度変化で立体感を演出
//
// 4. 特殊効果:
//    - 波の頂点での泡や光の反射効果
//    - 全体の微妙な明度変化で生き生きとした表現
//
// 5. 色彩設計:
//    - 海の基本色（青、青緑）を基調
//    - 時間帯による自然な色変化
//    - 物理的に妥当な色の遷移
//
// 学習のポイント:
// - 複数の要素を統合した総合的な表現
// - 自然現象の観察と抽象化
// - 時間と空間の両軸での効果設計
// - 色彩理論の実践的な応用