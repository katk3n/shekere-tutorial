// Chapter 4 Example 4: 複合インタラクティブ効果
// 時間とマウス入力を組み合わせた複雑なインタラクティブパターン

// 滑らかなオーブ効果を生成する関数
fn smoothOrb(uv: vec2<f32>, center: vec2<f32>, radius: f32) -> f32 {
    let distance = length(uv - center);
    let t = clamp(1.0 + radius - distance, 0.0, 1.0);
    return pow(t, 16.0);  // 16乗で急激なフォールオフ
}

// 波紋効果を生成する関数
fn ripple(uv: vec2<f32>, center: vec2<f32>, time: f32) -> f32 {
    let distance = length(uv - center);
    let wave = sin(distance * 20.0 - time * 10.0);
    let falloff = 1.0 / (1.0 + distance * 5.0);
    return wave * falloff * 0.3;
}

@fragment
fn fs_main(in: VertexOutput) -> @location(0) vec4<f32> {
    // 現在のピクセルの正規化座標を取得
    let uv = NormalizedCoords(in.position.xy);
    
    // マウスの正規化座標を取得
    let mouse = MouseCoords();
    
    // 経過時間を取得
    let time = Time.duration;
    
    // 時間による半径の変化
    let radius = 0.05 + 0.02 * sin(time * 3.0);
    
    // 時間による色相の変化
    let hue = sin(time * 2.0) * 0.5 + 0.5;
    
    // 複数のオーブを作成
    // メインオーブ（マウス位置）
    let main_orb = smoothOrb(uv, mouse, radius);
    
    // サブオーブ（マウスの周りを回転）
    let angle1 = time * 2.0;
    let angle2 = time * 2.0 + 2.094;  // 120度のオフセット
    let angle3 = time * 2.0 + 4.188;  // 240度のオフセット
    let orbit_radius = 0.2;
    
    let sub_orb1 = smoothOrb(uv, mouse + vec2(cos(angle1), sin(angle1)) * orbit_radius, 0.03);
    let sub_orb2 = smoothOrb(uv, mouse + vec2(cos(angle2), sin(angle2)) * orbit_radius, 0.03);
    let sub_orb3 = smoothOrb(uv, mouse + vec2(cos(angle3), sin(angle3)) * orbit_radius, 0.03);
    
    // 波紋効果を追加
    let ripple_effect = ripple(uv, mouse, time);
    
    // 距離に応じた背景色
    let distance_to_mouse = length(uv - mouse);
    let background_intensity = 0.1 * (1.0 - clamp(distance_to_mouse, 0.0, 1.0));
    
    // 各色成分を計算
    let red = main_orb * hue + sub_orb1 * 0.8 + background_intensity;
    let green = main_orb * (1.0 - hue) + sub_orb2 * 0.8 + ripple_effect + background_intensity;
    let blue = main_orb * 0.5 + sub_orb3 * 0.8 + abs(ripple_effect) + background_intensity;
    
    // 最終的な色を作成
    let color = vec3(red, green, blue);
    
    // 色空間を変換して出力
    return vec4(ToLinearRgb(color), 1.0);
}

// 期待される動作：
// - マウス位置に時間で変化する色のメインオーブが表示される
// - メインオーブの周りを3つの小さなオーブが回転する
// - マウス位置を中心とした波紋効果が拡散する
// - 距離に応じた背景の微妙な色変化
// - 時間経過による色相とサイズの変化