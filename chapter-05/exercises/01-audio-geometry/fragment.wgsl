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
    
    // 各周波数帯域の振幅を取得
    let bass = getBandAmplitude(0u, Spectrum.num_points / 3u);
    let mid = getBandAmplitude(Spectrum.num_points / 3u, (Spectrum.num_points * 2u) / 3u);
    let treble = getBandAmplitude((Spectrum.num_points * 2u) / 3u, Spectrum.num_points);
    
    // 中心からの距離と角度を計算
    let distance = length(uv);
    let angle = atan2(uv.y, uv.x);
    
    var final_color = vec3(0.0);
    
    // --- 1. 音響反応円 ---
    // 低音域で制御される基本的な円
    let bass_circle_radius = 0.15 + bass * 0.3;
    if (distance < bass_circle_radius && distance > bass_circle_radius - 0.02) {
        let intensity = 1.0 - abs(distance - bass_circle_radius) / 0.02;
        final_color += vec3(1.0, 0.3, 0.3) * intensity * bass * 2.0;
    }
    
    // --- 2. 周波数別色分け円 ---
    // 中音域の緑の円
    let mid_circle_radius = 0.25 + mid * 0.2;
    if (distance < mid_circle_radius && distance > mid_circle_radius - 0.015) {
        let intensity = 1.0 - abs(distance - mid_circle_radius) / 0.015;
        final_color += vec3(0.3, 1.0, 0.3) * intensity * mid * 2.0;
    }
    
    // 高音域の青の円
    let treble_circle_radius = 0.35 + treble * 0.15;
    if (distance < treble_circle_radius && distance > treble_circle_radius - 0.01) {
        let intensity = 1.0 - abs(distance - treble_circle_radius) / 0.01;
        final_color += vec3(0.3, 0.3, 1.0) * intensity * treble * 2.0;
    }
    
    // --- 3. 回転する多角形 ---
    // 音響による回転速度制御
    let rotation_speed = mid * 3.0 + 0.5;
    let rotated_angle = angle + time * rotation_speed;
    
    // 多角形のパラメータ（音響で制御）
    let sides = 5.0 + bass * 3.0;  // 5〜8角形
    let polygon_radius = 0.45 + treble * 0.2;
    
    // 多角形の描画
    let segment_angle = 6.28318 / sides;
    let polygon_angle = floor(rotated_angle / segment_angle) * segment_angle + segment_angle * 0.5;
    let polygon_distance = polygon_radius / cos(rotated_angle - polygon_angle);
    
    if (distance < polygon_distance && distance > polygon_distance - 0.025) {
        let intensity = 1.0 - abs(distance - polygon_distance) / 0.025;
        // 音響レベルに応じた色の混合
        let polygon_color = vec3(
            bass * 0.8 + 0.2,
            mid * 0.8 + 0.2,
            treble * 0.8 + 0.2
        );
        final_color += polygon_color * intensity * 1.5;
    }
    
    // --- 4. 音響パルス効果 ---
    // 強い音で中央に光る効果
    let total_amplitude = (bass + mid + treble) / 3.0;
    if (distance < 0.08 && total_amplitude > 0.3) {
        let pulse_intensity = (1.0 - distance / 0.08) * total_amplitude;
        final_color += vec3(1.0, 1.0, 0.5) * pulse_intensity * 2.0;
    }
    
    // --- 5. 背景のグラデーション ---
    // 音響レベルに応じた背景色
    let background_intensity = total_amplitude * 0.3;
    let background_gradient = 1.0 - distance * 0.5;
    final_color += vec3(0.1, 0.05, 0.15) * background_intensity * background_gradient;
    
    // --- 6. 時間による微妙な変化 ---
    let time_modulation = sin(time * 2.0) * 0.1 + 0.9;
    final_color = final_color * time_modulation;
    
    // 最低輝度の確保
    final_color = max(final_color, vec3(0.02, 0.01, 0.03));
    
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
// - アニメーション速度の細かい調整
// - 色の組み合わせの実験