// 演習 3: 色彩調和
// 「インタラクティブ光現象 - Interactive Light Phenomena」作品への第3ステップ
// テーマ: 「光のシンフォニー - Symphony of Light」
// 目標: 前ステップの光の星座に動的な色彩変化システムを追加し、インタラクティブな色彩調和を実現する

// 【前ステップから継承】汎用光源関数
fn create_light(uv: vec2<f32>, center: vec2<f32>, radius: f32, 
               intensity: f32, color: vec3<f32>) -> vec3<f32> {
    let distance = length(uv - center);
    let normalized_distance = clamp(distance / radius, 0.0, 1.0);
    let light_strength = pow(1.0 - normalized_distance, 3.0) * intensity;
    return color * light_strength;
}

// 【新規追加】HSV色空間からRGB色空間への変換関数
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

// 【新規追加】距離による色彩相互作用を計算する関数
fn get_interactive_color(base_hue: f32, mouse_pos: vec2<f32>, star_pos: vec2<f32>) -> vec3<f32> {
    let distance = length(mouse_pos - star_pos);
    let influence = 1.0 - clamp(distance / 2.0, 0.0, 1.0);
    
    // マウス位置の色相と固定光源の基本色相をブレンド
    let mouse_hue = (mouse_pos.x + 1.0) * 180.0;
    let blended_hue = mix(base_hue, mouse_hue, influence * 0.6);
    
    return hsv_to_rgb(blended_hue, 0.9, 1.0);
}

@fragment
fn fs_main(in: VertexOutput) -> @location(0) vec4<f32> {
    let uv = NormalizedCoords(in.position.xy);
    let mouse = MouseCoords();
    
    // 【新規追加】マウス位置による動的色相システム
    let base_hue = (mouse.x + 1.0) * 180.0;  // -1〜1 を 0〜360度に変換
    
    // 【継承+新規追加】動的色彩を持つメイン光源
    // 演習2の基本光源にHSV色空間による動的色彩を追加
    let main_light_color = hsv_to_rgb(base_hue, 0.8, 1.0);
    let mouse_light = create_light(uv, mouse, 0.4, 1.0, main_light_color);
    
    // 【継承+新規追加】固定星座光源（色彩相互作用付き）
    // 演習2の固定光源に距離ベースの色彩変化を追加
    let star1_pos = vec2(-0.6, 0.4);
    let star1_base_hue = 240.0;  // 青系
    let star1_color = get_interactive_color(star1_base_hue, mouse, star1_pos);
    let star1 = create_light(uv, star1_pos, 0.2, 0.7, star1_color);
    
    let star2_pos = vec2(0.5, -0.3);
    let star2_base_hue = 30.0;   // オレンジ系
    let star2_color = get_interactive_color(star2_base_hue, mouse, star2_pos);
    let star2 = create_light(uv, star2_pos, 0.15, 0.6, star2_color);
    
    let star3_pos = vec2(0.0, 0.6);
    let star3_base_hue = 300.0;  // 紫系
    let star3_color = get_interactive_color(star3_base_hue, mouse, star3_pos);
    let star3 = create_light(uv, star3_pos, 0.25, 0.5, star3_color);
    
    let star4_pos = vec2(-0.3, -0.5);
    let star4_base_hue = 120.0;  // 緑系
    let star4_color = get_interactive_color(star4_base_hue, mouse, star4_pos);
    let star4 = create_light(uv, star4_pos, 0.18, 0.4, star4_color);
    
    // 【新規追加】色彩調和による補完光源
    // 補色関係による美しい対比効果
    let complementary_hue = fract((base_hue + 180.0) / 360.0) * 360.0;
    let complementary_color = hsv_to_rgb(complementary_hue, 0.6, 0.8);
    let complementary_light = create_light(uv, vec2(0.7, 0.2), 0.12, 0.3, complementary_color);
    
    // 【前ステップから継承】全光源の合成
    var total_light = vec3(0.0, 0.0, 0.0);
    
    // メイン光源（最も明るく、動的色相）
    total_light += mouse_light;
    
    // 固定星座光源（色彩相互作用付き）
    total_light += star1;
    total_light += star2;
    total_light += star3;
    total_light += star4;
    
    // 補色調和光源
    total_light += complementary_light;
    
    return vec4(ToLinearRgb(total_light), 1.0);
}

// 【技術ポイント】:
// - 前ステップから継承: 光の星座システムとcreate_light()関数
// - HSV色空間: より直感的な色相・彩度・明度の制御
// - 動的色相: マウスX座標 → 0〜360度の色相変化
// - 色彩相互作用: マウスと固定光源の距離による色のブレンド
// - 色彩調和: 補色関係による美しい対比効果
// - mix()関数: 2つの色相の滑らかなブレンド

// 【実験してみよう】:
// 1. 色相範囲を変更: base_hue を (mouse.x + 1.0) * 120.0 で限定色相
// 2. 彩度を調整: hsv_to_rgb()の第2引数を0.4〜1.0で変更
// 3. 相互作用範囲を変更: distance / 2.0 → distance / 1.5, distance / 3.0
// 4. 類似色関係を追加: base_hue ± 30度の色相で類似色光源を作成
// 5. Y軸活用: mouse.yを彩度や明度の制御に使用
// 6. 複数補色: 分裂補色（base_hue ± 150度）を試す

// 【次のステップへの準備】:
// このコードは演習4で継承・拡張されます：
// - この動的色彩システムを保持
// - Time.durationによる時間軸の追加
// - パーティクル効果やエネルギー波動の実装
// - 完成されたインタラクティブ光アート作品への仕上げ