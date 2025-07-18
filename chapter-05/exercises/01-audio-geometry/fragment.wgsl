// Chapter 5 Solution 1: 音響駆動幾何学パターン - 解答例
// 演習課題1「音響反応円と多角形」に対する解答例

// 周波数帯域の平均振幅を計算する補助関数
fn getBandAmplitude(start_freq: u32, end_freq: u32) -> f32 {
    var total = 0.0;
    var count = 0u;
    
    for (var i = start_freq; i < end_freq; i++) {
        total += SpectrumAmplitude(i);
        count++;
    }
    
    return total / f32(count);
}

@fragment
fn fs_main(in: VertexOutput) -> @location(0) vec4<f32> {
    let uv = NormalizedCoords(in.position.xy);
    let time = Time.duration;
    
    // 各周波数帯域の振幅を取得（音楽的に意味のある帯域分割、感度向上）
    // Bass: 0-500Hz, Mid: 500-1400Hz, Treble: 1400-2000Hz
    let bass_raw = getBandAmplitude(0u, Spectrum.num_points / 4u);
    let mid_raw = getBandAmplitude(Spectrum.num_points / 4u, (Spectrum.num_points * 7u) / 10u);
    let treble_raw = getBandAmplitude((Spectrum.num_points * 7u) / 10u, Spectrum.num_points);
    
    // 感度を大幅に向上（特に円の効果用）
    let bass = bass_raw * 3.0;
    let mid = mid_raw * 4.0;
    let treble = treble_raw * 5.0;
    
    // 中心からの距離と角度を計算
    let distance = length(uv);
    let angle = atan2(uv.y, uv.x);
    
    var final_color = vec3(0.0);
    
    // --- 1. 音響反応円 ---
    // 低音域で制御される基本的な円（大幅な感度向上）
    let bass_circle_radius = 0.15 + bass * 0.8;
    let bass_thickness = 0.04 + bass * 0.04;
    if (distance < bass_circle_radius && distance > bass_circle_radius - bass_thickness) {
        let intensity = 1.0 - abs(distance - bass_circle_radius) / bass_thickness;
        final_color += vec3(1.0, 0.1, 0.1) * intensity * bass * 8.0;
    }
    
    // --- 2. 周波数別色分け円 ---
    // 中音域の緑の円（大幅な感度向上）
    let mid_circle_radius = 0.25 + mid * 0.7;
    let mid_thickness = 0.035 + mid * 0.03;
    if (distance < mid_circle_radius && distance > mid_circle_radius - mid_thickness) {
        let intensity = 1.0 - abs(distance - mid_circle_radius) / mid_thickness;
        final_color += vec3(0.1, 1.0, 0.1) * intensity * mid * 10.0;
    }
    
    // 高音域の青の円（大幅な感度向上）
    let treble_circle_radius = 0.35 + treble * 0.6;
    let treble_thickness = 0.03 + treble * 0.035;
    if (distance < treble_circle_radius && distance > treble_circle_radius - treble_thickness) {
        let intensity = 1.0 - abs(distance - treble_circle_radius) / treble_thickness;
        final_color += vec3(0.1, 0.3, 1.0) * intensity * treble * 12.0;
    }
    
    // --- 3. 音響反応多角形 ---
    // 固定速度で回転し、音響でサイズが変化
    let constant_rotation_speed = 0.5;  // 固定の回転速度
    let rotated_angle = angle + time * constant_rotation_speed;
    
    // 多角形のパラメータ（音響でサイズ制御、大幅な感度向上）
    let sides = 6.0;  // 固定の6角形
    // 各周波数帯域で異なるサイズ変化（大幅な感度向上）
    let base_radius = 0.4;  // 音がなくても見える基本サイズ
    let bass_contribution = bass * 0.3;      // 低音域の影響（倍増）
    let mid_contribution = mid * 0.4;       // 中音域の影響（倍増）
    let treble_contribution = treble * 0.35;  // 高音域の影響（倍増）
    let polygon_radius = base_radius + bass_contribution + mid_contribution + treble_contribution;
    
    // 緊急な音の変化に対するパルス効果
    let pulse_effect = sin(time * 10.0) * (bass + mid + treble) * 0.05;
    let final_polygon_radius = polygon_radius + pulse_effect;
    
    // 多角形の描画（固定速度で回転、サイズ変化）
    let segment_angle = 6.28318 / sides;
    let polygon_angle = floor(rotated_angle / segment_angle) * segment_angle + segment_angle * 0.5;
    let polygon_distance = final_polygon_radius / cos(rotated_angle - polygon_angle);
    let polygon_thickness = 0.02 + (bass + mid + treble) * 0.03;
    
    if (distance < polygon_distance && distance > polygon_distance - polygon_thickness) {
        let intensity = 1.0 - abs(distance - polygon_distance) / polygon_thickness;
        // 音響レベルに応じた色の混合（音がなくても基本色を保持）
        let size_factor = (polygon_radius - base_radius) / 0.6; // サイズの変化率
        let polygon_color = vec3(
            bass * 1.0 + size_factor * 0.3 + 0.3,  // 基本的な赤色を保持
            mid * 1.2 + size_factor * 0.4 + 0.4,   // 基本的な緑色を保持
            treble * 1.4 + size_factor * 0.5 + 0.5 // 基本的な青色を保持
        );
        final_color += polygon_color * intensity * (2.0 + size_factor);
    }
    
    // --- 4. 音響パルス効果 ---
    // 各周波数帯域に対応したパルス効果
    // 低音域パルス（中央、大幅な感度向上）
    if (distance < 0.08 && bass > 0.05) {
        let bass_pulse_intensity = (1.0 - distance / 0.08) * bass;
        final_color += vec3(1.0, 0.1, 0.1) * bass_pulse_intensity * 12.0;
    }
    // 中音域パルス（中央周り、大幅な感度向上）
    if (distance < 0.15 && distance > 0.08 && mid > 0.03) {
        let mid_pulse_intensity = (1.0 - abs(distance - 0.115) / 0.035) * mid;
        final_color += vec3(0.2, 1.0, 0.2) * mid_pulse_intensity * 15.0;
    }
    // 高音域パルス（外側、大幅な感度向上）
    if (distance < 0.22 && distance > 0.15 && treble > 0.02) {
        let treble_pulse_intensity = (1.0 - abs(distance - 0.185) / 0.035) * treble;
        final_color += vec3(0.3, 0.5, 1.0) * treble_pulse_intensity * 18.0;
    }
    
    // --- 5. 背景のグラデーション ---
    // 各周波数帯域で異なる背景色を作成（大幅な感度向上）
    let total_amplitude = (bass + mid + treble) / 3.0;
    let background_intensity = total_amplitude * 1.2;
    let background_gradient = 1.0 - distance * 0.2;
    // 周波数帯域による色の変化（大幅強化）
    let bg_color = vec3(
        bass * 0.6 + 0.03,
        mid * 0.8 + 0.06,
        treble * 1.0 + 0.10
    );
    final_color += bg_color * background_intensity * background_gradient;
    
    // --- 6. 時間による微妙な変化 ---
    let time_modulation = sin(time * 2.0) * 0.1 + 0.9;
    final_color = final_color * time_modulation;
    
    // 最低輝度の確保（音がなくても背景が見える）
    final_color = max(final_color, vec3(0.05, 0.03, 0.08));
    
    return vec4(ToLinearRgb(final_color), 1.0);
}

// 解答例のポイント：
// 1. 複数の円が周波数帯域ごとに異なる色とサイズで表示
// 2. 回転する多角形が音響データで制御される
// 3. 中央のパルス効果が強い音に反応
// 4. 背景グラデーションが全体の音響レベルを表現
// 5. 時間変化による動的な視覚効果

// 学習ポイント：
// - 距離関数による図形の描画方法
// - 複数の効果レイヤーの重ね合わせ
// - 音響データの視覚的マッピング
// - 幾何学的変換（回転、スケール）の実装

// 応用のヒント：
// - 図形の厚さや形状を調整
// - より複雑な多角形や星型の実装
// - 音響による多角形のサイズ変化の調整
// - 色の組み合わせの実験