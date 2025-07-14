// Chapter 4 Solution 3: オリジナルインタラクティブパターン解答例
// 作品名: 「コズミックダンス (Cosmic Dance)」
// テーマ: 宇宙的な視覚効果とインタラクティブな星の踊り

// 基本的なオーブ効果（星を表現）
fn star(p: vec2<f32>, center: vec2<f32>, radius: f32, intensity: f32) -> f32 {
    let distance = length(p - center);
    let falloff = 1.0 / (1.0 + distance * distance / (radius * radius));
    return falloff * intensity;
}

// 回転する星座パターン
fn constellation(uv: vec2<f32>, center: vec2<f32>, time: f32, size: f32) -> vec3<f32> {
    var color = vec3(0.0, 0.0, 0.0);
    
    // 5つの星で構成される星座
    for (var i = 0; i < 5; i++) {
        let angle = f32(i) * 1.256 + time * 0.5;  // 72度間隔で回転
        let distance = size * 0.3;
        let star_pos = center + vec2(cos(angle), sin(angle)) * distance;
        
        // 星の色を少しずつ変化
        let hue = f32(i) * 0.2 + time * 0.3;
        let star_color = vec3(
            sin(hue) * 0.5 + 0.5,
            sin(hue + 2.09) * 0.5 + 0.5,
            sin(hue + 4.19) * 0.5 + 0.5
        );
        
        color += star(uv, star_pos, 0.02, 0.3) * star_color;
    }
    
    return color;
}

// 粒子効果（星屑を表現）
fn stardust(uv: vec2<f32>, center: vec2<f32>, time: f32) -> f32 {
    let distance = length(uv - center);
    let angle = atan2(uv.y - center.y, uv.x - center.x);
    
    // 螺旋状の粒子分布
    let spiral = sin(angle * 8.0 + distance * 10.0 - time * 3.0);
    let falloff = 1.0 / (1.0 + distance * 3.0);
    
    return max(0.0, spiral) * falloff * 0.2;
}

// 宇宙の背景（ネビュラ効果）
fn nebula(uv: vec2<f32>, time: f32) -> vec3<f32> {
    let noise1 = sin(uv.x * 5.0 + time * 0.7) * sin(uv.y * 5.0 + time * 0.5);
    let noise2 = sin(uv.x * 8.0 - time * 0.3) * sin(uv.y * 8.0 + time * 0.8);
    
    let purple = vec3(0.4, 0.1, 0.6);
    let blue = vec3(0.1, 0.2, 0.8);
    
    let factor = (noise1 + noise2) * 0.5 + 0.5;
    return mix(purple, blue, factor) * 0.1;
}

// エネルギー波動効果
fn energyWave(uv: vec2<f32>, center: vec2<f32>, time: f32) -> f32 {
    let distance = length(uv - center);
    let wave = sin(distance * 15.0 - time * 8.0);
    let pulse = sin(time * 3.0) * 0.3 + 0.7;
    let falloff = 1.0 / (1.0 + distance * 2.0);
    
    return max(0.0, wave) * falloff * pulse * 0.15;
}

@fragment
fn fs_main(in: VertexOutput) -> @location(0) vec4<f32> {
    let uv = NormalizedCoords(in.position.xy);
    let mouse = MouseCoords();
    let time = Time.duration;
    
    // 基本的な宇宙背景
    var color = nebula(uv, time);
    
    // メインの星座（マウス位置に追従）
    let mouse_distance = length(uv - mouse);
    let constellation_size = 0.5 + 0.3 * sin(time * 1.5);
    color += constellation(uv, mouse, time, constellation_size);
    
    // 中央の固定星座
    let center_constellation = constellation(uv, vec2(0.0, 0.0), time * 0.7, 0.3);
    color += center_constellation * 0.6;
    
    // マウス位置からの星屑効果
    let dust = stardust(uv, mouse, time);
    color += vec3(dust, dust * 0.8, dust * 0.6);
    
    // エネルギー波動
    let wave = energyWave(uv, mouse, time);
    color += vec3(wave * 0.8, wave, wave * 0.6);
    
    // 中心からの光の柱
    let center_distance = length(uv);
    let light_column = 1.0 / (1.0 + center_distance * 10.0);
    color += vec3(light_column * 0.05, light_column * 0.1, light_column * 0.2);
    
    // マウス位置の強力な星（太陽のような効果）
    let sun_intensity = star(uv, mouse, 0.08, 1.0);
    let sun_color = vec3(1.0, 0.8, 0.2) * sun_intensity;
    color += sun_color;
    
    // 画面端の暗いビネット効果
    let vignette = 1.0 - pow(length(uv) / 1.4, 2.0);
    color *= vignette;
    
    // 最終的な色の調整
    color = clamp(color, vec3(0.0), vec3(1.0));
    
    return vec4(ToLinearRgb(color), 1.0);
}

// 作品解説:
// 「コズミックダンス」は宇宙空間での星々の踊りを表現したインタラクティブ作品です。
// 
// 主な特徴:
// - マウス位置に追従する主星座とエネルギー効果
// - 中央の固定星座による対称性
// - 時間による星の色変化と回転
// - 螺旋状の星屑エフェクト
// - ネビュラ（星雲）による宇宙背景
// - エネルギー波動による動的効果
// 
// 技術的要素:
// - 複数の関数による効果の階層化
// - 三角関数による回転と周期的変化
// - 距離計算による放射状効果
// - 色相変化による美しい視覚効果
// - ビネット効果による画面の引き締め
// 
// インタラクション:
// - マウス移動により星座と効果が追従
// - 時間経過による自動的な変化
// - 複数の効果の組み合わせによる豊かな表現