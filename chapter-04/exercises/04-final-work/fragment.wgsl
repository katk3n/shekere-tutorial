// 演習 4: 光の協奏曲
// 「インタラクティブ光現象 - Interactive Light Phenomena」作品への第4ステップ（完成）
// テーマ: 「宇宙の調和 - Cosmic Harmony」
// 目標: 全要素を統合し、時間効果と高度なインタラクション要素で完成されたインタラクティブ光アート作品を創造

// 【前ステップから継承】汎用光源関数
fn create_light(uv: vec2<f32>, center: vec2<f32>, radius: f32, 
               intensity: f32, color: vec3<f32>) -> vec3<f32> {
    let distance = length(uv - center);
    let normalized_distance = clamp(distance / radius, 0.0, 1.0);
    let light_strength = pow(1.0 - normalized_distance, 3.0) * intensity;
    return color * light_strength;
}

// 【前ステップから継承】HSV色空間からRGB色空間への変換関数
fn hsv_to_rgb(h: f32, s: f32, v: f32) -> vec3<f32> {
    let c = v * s;
    let x = c * (1.0 - abs(fract(h / 60.0) * 2.0 - 1.0));
    let m = v - c;
    
    var rgb = vec3<f32>(0.0);
    if (h >= 0.0 && h < 60.0) { rgb = vec3(c, x, 0.0); }
    else if (h >= 60.0 && h < 120.0) { rgb = vec3(x, c, 0.0); }
    else if (h >= 120.0 && h < 180.0) { rgb = vec3(0.0, c, x); }
    else if (h >= 180.0 && h < 240.0) { rgb = vec3(0.0, x, c); }
    else if (h >= 240.0 && h < 300.0) { rgb = vec3(x, 0.0, c); }
    else if (h >= 300.0 && h < 360.0) { rgb = vec3(c, 0.0, x); }
    
    return rgb + vec3(m);
}

// 【前ステップから継承】距離による色彩相互作用を計算する関数
fn get_interactive_color(base_hue: f32, mouse_pos: vec2<f32>, star_pos: vec2<f32>) -> vec3<f32> {
    let distance = length(mouse_pos - star_pos);
    let influence = 1.0 - clamp(distance / 2.0, 0.0, 1.0);
    let mouse_hue = (mouse_pos.x + 1.0) * 180.0;
    let blended_hue = mix(base_hue, mouse_hue, influence * 0.6);
    return hsv_to_rgb(blended_hue, 0.9, 1.0);
}

// 【新規追加】座標回転関数
fn rotate_point(pos: vec2<f32>, angle: f32) -> vec2<f32> {
    let cos_a = cos(angle);
    let sin_a = sin(angle);
    return vec2(
        pos.x * cos_a - pos.y * sin_a,
        pos.x * sin_a + pos.y * cos_a
    );
}

// 【新規追加】パーティクル効果
fn particle_field(uv: vec2<f32>, center: vec2<f32>, time: f32, base_hue: f32) -> vec3<f32> {
    let particle_count = 16.0;
    var intensity = 0.0;
    
    for (var i = 0.0; i < particle_count; i += 1.0) {
        // 各パーティクルの角度と距離
        let angle = (i / particle_count) * 6.28318 + time * 0.8;
        let orbit_radius = 0.25 + 0.15 * sin(time * 1.2 + i * 0.5);
        let particle_pos = center + vec2(cos(angle), sin(angle)) * orbit_radius;
        
        // パーティクルのサイズと明度
        let particle_size = 0.015 + 0.01 * sin(time * 4.0 + i * 1.5);
        let particle_distance = length(uv - particle_pos);
        let particle_glow = 1.0 / (1.0 + particle_distance * particle_distance / (particle_size * particle_size));
        
        intensity += particle_glow * 0.08;
    }
    
    // パーティクルの色相（基本色相から少し変化）
    let particle_hue = base_hue + 60.0 + sin(time * 0.5) * 30.0;
    return hsv_to_rgb(particle_hue, 0.8, intensity);
}

// 【新規追加】エネルギー波動効果
fn energy_waves(uv: vec2<f32>, center: vec2<f32>, time: f32) -> f32 {
    let distance = length(uv - center);
    let wave_count = 4.0;
    var wave_intensity = 0.0;
    
    for (var w = 0.0; w < wave_count; w += 1.0) {
        let wave_speed = 3.0;
        let wave_frequency = 6.0;
        let wave_phase = time * wave_speed - w * 1.2;
        let wave = sin(distance * wave_frequency - wave_phase);
        let wave_falloff = 1.0 / (1.0 + distance * 2.0);
        wave_intensity += max(0.0, wave) * wave_falloff * 0.15;
    }
    
    return wave_intensity;
}

// 【新規追加】レスポンシブ背景効果
fn responsive_background(uv: vec2<f32>, mouse: vec2<f32>, time: f32) -> vec3<f32> {
    let distance_from_center = length(uv);
    let distance_from_mouse = length(uv - mouse);
    
    // 中心からの放射状グラデーション
    let radial_gradient = 1.0 - clamp(distance_from_center / 1.4, 0.0, 1.0);
    
    // マウス位置による影響
    let mouse_influence = 1.0 - clamp(distance_from_mouse / 0.8, 0.0, 1.0);
    
    // 時間による色相変化
    let time_hue = fract(time * 0.1) * 360.0;
    let background_intensity = (radial_gradient * 0.1 + mouse_influence * 0.05) * (0.5 + 0.5 * sin(time * 0.3));
    
    return hsv_to_rgb(time_hue, 0.3, background_intensity);
}

@fragment
fn fs_main(in: VertexOutput) -> @location(0) vec4<f32> {
    let uv = NormalizedCoords(in.position.xy);
    let mouse = MouseCoords();
    let time = Time.duration;
    
    // 【継承+新規追加】時間による動的色相システム
    let base_hue = (mouse.x + 1.0) * 180.0 + sin(time * 0.5) * 30.0;
    
    // 【継承+新規追加】時間による脈動を持つメイン光源
    let pulse = sin(time * 2.5) * 0.2 + 0.8;
    let main_light_color = hsv_to_rgb(base_hue, 0.9, 1.0);
    let mouse_light = create_light(uv, mouse, 0.4 * pulse, 1.0, main_light_color);
    
    // 【継承+新規追加】回転する星座光源（時間による動的配置）
    let rotation_speed = 0.3;
    let constellation_rotation = time * rotation_speed;
    
    let star1_base_pos = vec2(-0.6, 0.4);
    let star1_pos = rotate_point(star1_base_pos, constellation_rotation);
    let star1_base_hue = 240.0 + sin(time * 0.7) * 20.0;
    let star1_color = get_interactive_color(star1_base_hue, mouse, star1_pos);
    let star1 = create_light(uv, star1_pos, 0.2, 0.7, star1_color);
    
    let star2_base_pos = vec2(0.5, -0.3);
    let star2_pos = rotate_point(star2_base_pos, constellation_rotation * 0.8);
    let star2_base_hue = 30.0 + sin(time * 0.9) * 15.0;
    let star2_color = get_interactive_color(star2_base_hue, mouse, star2_pos);
    let star2 = create_light(uv, star2_pos, 0.15, 0.6, star2_color);
    
    let star3_base_pos = vec2(0.0, 0.6);
    let star3_pos = rotate_point(star3_base_pos, constellation_rotation * -0.6);
    let star3_base_hue = 300.0 + sin(time * 1.1) * 25.0;
    let star3_color = get_interactive_color(star3_base_hue, mouse, star3_pos);
    let star3 = create_light(uv, star3_pos, 0.25, 0.5, star3_color);
    
    let star4_base_pos = vec2(-0.3, -0.5);
    let star4_pos = rotate_point(star4_base_pos, constellation_rotation * 1.2);
    let star4_base_hue = 120.0 + sin(time * 0.6) * 20.0;
    let star4_color = get_interactive_color(star4_base_hue, mouse, star4_pos);
    let star4 = create_light(uv, star4_pos, 0.18, 0.4, star4_color);
    
    // 【新規追加】パーティクル効果
    let particle_effects = particle_field(uv, mouse, time, base_hue);
    
    // 【新規追加】エネルギー波動
    let wave_intensity = energy_waves(uv, mouse, time);
    let wave_color = hsv_to_rgb(base_hue + 120.0, 0.7, wave_intensity);
    
    // 【継承+新規追加】時間による変化を持つ補色調和光源
    let complementary_hue = fract((base_hue + 180.0 + sin(time * 0.4) * 40.0) / 360.0) * 360.0;
    let complementary_color = hsv_to_rgb(complementary_hue, 0.6, 0.8);
    let complementary_pos = vec2(0.7, 0.2) + vec2(sin(time * 0.8), cos(time * 1.1)) * 0.1;
    let complementary_light = create_light(uv, complementary_pos, 0.12, 0.3, complementary_color);
    
    // 【新規追加】レスポンシブ背景
    let background = responsive_background(uv, mouse, time);
    
    // 【完成版】全光源とエフェクトの統合
    var total_light = vec3(0.0, 0.0, 0.0);
    
    // 背景効果（最も暗い層）
    total_light += background;
    
    // 波動効果（中間層）
    total_light += wave_color;
    
    // 主要光源群（明るい層）
    total_light += mouse_light;
    total_light += star1;
    total_light += star2; 
    total_light += star3;
    total_light += star4;
    total_light += complementary_light;
    
    // パーティクル効果（最前面）
    total_light += particle_effects;
    
    // 【新規追加】ビネット効果による画面の引き締め
    let vignette = 1.0 - pow(length(uv) / 1.4, 1.5);
    total_light *= vignette;
    
    return vec4(ToLinearRgb(total_light), 1.0);
}

// 【完成作品の技術ポイント】:
// - 演習1-3から継承: 基本光源、星座配置、色彩調和システム
// - Time.duration: 時間軸による自動的な美しい変化
// - 回転変換: rotate_point()による星座の動的配置
// - パーティクルシステム: 16個の光の粒子による豊かな表現
// - 波動効果: マウス位置からの放射状エネルギー波動
// - レスポンシブ背景: 全体に応答する背景効果
// - ビネット効果: 画面の美しい引き締め
// - 視覚階層: 背景→波動→光源→パーティクルの美しい重ね合わせ

// 【作品の特徴】:
// - 🎨 芸術性: 技術と美しさが融合したデジタルアート
// - ⚡ インタラクティブ性: ユーザーの動きに豊かに応答
// - 🎵 時間性: 音楽のように展開する時間軸を持つ
// - 🌌 宇宙的: 星座・光・エネルギーの宇宙的表現
// - 💫 統合性: 4つの演習段階の全てを統合

// 【カスタマイズのアイデア】:
// 1. パーティクル数調整: particle_count を変更して密度を調節
// 2. 回転速度変更: rotation_speed で星座の動きを調整
// 3. 波動パターン変更: wave_frequency, wave_speed で波の性質を変更
// 4. 色相範囲制限: base_hue計算を変更して特定色相に限定
// 5. 新しいエフェクト追加: 独自のアイデアによる追加効果

// 🎉 完成おめでとうございます！
// この「インタラクティブ光現象 - Interactive Light Phenomena」は
// あなたが段階的に構築した本格的なインタラクティブアート作品です！