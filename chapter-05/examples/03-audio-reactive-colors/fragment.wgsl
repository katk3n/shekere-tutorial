// Chapter 5 Example 3: 音響リアクティブな色変化
// 音響信号に応じて色とパターンが変化するシェーダー

// 周波数帯域の平均振幅を計算する関数（感度調整付き）
fn getBandAmplitude(start_freq: u32, end_freq: u32) -> f32 {
    var total = 0.0;
    var count = 0u;
    
    for (var i = start_freq; i < end_freq; i++) {
        let frequency = SpectrumFrequency(i);
        let amplitude = SpectrumAmplitude(i);
        
        // 周波数に応じた感度調整
        var sensitivity_multiplier = 1.0;
        
        if (frequency < 100.0) {
            sensitivity_multiplier = 2.0;
        } else if (frequency < 400.0) {
            sensitivity_multiplier = 3.0;
        } else if (frequency < 800.0) {
            sensitivity_multiplier = 4.5;
        } else if (frequency < 1400.0) {
            sensitivity_multiplier = 6.0;
        } else if (frequency < 2200.0) {
            sensitivity_multiplier = 8.0;
        } else if (frequency < 3200.0) {
            sensitivity_multiplier = 10.0;
        } else {
            sensitivity_multiplier = 12.0;
        }
        
        total += amplitude * sensitivity_multiplier;
        count++;
    }
    
    return total / f32(count);
}

// HSV色空間からRGB色空間への変換関数
fn hsvToRgb(h: f32, s: f32, v: f32) -> vec3<f32> {
    let c = v * s;
    let x = c * (1.0 - abs((h / 60.0) % 2.0 - 1.0));
    let m = v - c;
    
    var rgb = vec3(0.0);
    if (h < 60.0) {
        rgb = vec3(c, x, 0.0);
    } else if (h < 120.0) {
        rgb = vec3(x, c, 0.0);
    } else if (h < 180.0) {
        rgb = vec3(0.0, c, x);
    } else if (h < 240.0) {
        rgb = vec3(0.0, x, c);
    } else if (h < 300.0) {
        rgb = vec3(x, 0.0, c);
    } else {
        rgb = vec3(c, 0.0, x);
    }
    
    return rgb + m;
}

@fragment
fn fs_main(in: VertexOutput) -> @location(0) vec4<f32> {
    // 正規化されたスクリーン座標を取得
    let uv = NormalizedCoords(in.position.xy);
    let time = Time.duration;
    
    // 各周波数帯域の振幅を取得（スペクトラム全体を適切に分割）
    let bass = getBandAmplitude(0u, Spectrum.num_points / 3u);        // 低音域
    let mid = getBandAmplitude(Spectrum.num_points / 3u, (Spectrum.num_points * 2u) / 3u);      // 中音域
    let treble = getBandAmplitude((Spectrum.num_points * 2u) / 3u, Spectrum.num_points);  // 高音域
    
    // 全体の音響レベルを計算
    let total_amplitude = (bass + mid + treble) / 3.0;
    
    // 中心からの距離を計算
    let distance = length(uv);
    
    // 音響に応じて回転効果を追加
    let rotation_speed = 0.5 + total_amplitude * 2.0;
    let angle = atan2(uv.y, uv.x) + time * rotation_speed;
    
    // 回転したUV座標を計算
    let rotated_uv = vec2(
        distance * cos(angle),
        distance * sin(angle)
    );
    
    // 音響に応じた色相の計算（適切な重み付け）
    let total_energy = bass + mid + treble + 0.001;
    let bass_weight = bass / total_energy;
    let mid_weight = mid / total_energy;
    let treble_weight = treble / total_energy;
    
    let base_hue = bass_weight * 0.0 + mid_weight * 120.0 + treble_weight * 240.0;
    let hue_variation = sin(angle * 3.0 + time * 2.0) * 30.0;
    let final_hue = base_hue + hue_variation;
    
    // 音響に応じた彩度の計算（最大彩度）
    let saturation = 1.0;
    
    // 距離に応じた明度の計算（明るいベース）
    let brightness_base = 0.5 + total_amplitude * 0.5;
    let brightness_pattern = sin(distance * 15.0 + time * 4.0) * 0.1;
    let brightness = brightness_base + brightness_pattern;
    
    // 低音域による脈動効果（明るく調整）
    let pulse_factor = 1.0 + bass * 0.8 * sin(time * 10.0);
    
    // 中音域による波紋効果（明るいリング）
    let wave_distance = distance * 25.0 - time * 8.0;
    let wave_pattern = step(0.5, sin(wave_distance)) * mid * 0.5;
    
    // 高音域による粒子効果（明るい粒子）
    let noise_x = sin(rotated_uv.x * 100.0 + time * 20.0);
    let noise_y = cos(rotated_uv.y * 100.0 + time * 20.0);
    let particle_noise = noise_x * noise_y;
    let particle_effect = step(0.7, particle_noise) * treble * 0.3;
    
    // 最終的な明度を計算（明るさを保証）
    let combined_effects = brightness + wave_pattern + particle_effect;
    let final_brightness = clamp(combined_effects * pulse_factor, 0.3, 1.0);
    
    // HSVからRGBに変換
    let color = hsvToRgb(final_hue, saturation, final_brightness);
    
    // ビネット効果を無効化（最大鮮明度）
    let final_color = color;
    
    // 最低輝度を完全に除去（完全な黒を許可）
    let adjusted_color = final_color;
    
    // 色空間を変換して出力
    return vec4(ToLinearRgb(adjusted_color), 1.0);
}

// 期待される動作：
// - 音楽を再生すると、画面全体が音響に応じて色が変化
// - 低音域：赤系統の脈動効果
// - 中音域：緑系統の波紋効果  
// - 高音域：青系統の粒子効果
// - 音響レベルに応じて回転速度が変化
// - 複数の効果が重なり合って複雑な視覚表現を生成