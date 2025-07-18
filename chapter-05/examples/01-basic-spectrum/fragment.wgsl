// Chapter 5 Example 1: 基本的なスペクトラム表示
// 音響スペクトラムの振幅を横方向に表示するシェーダー

@fragment
fn fs_main(in: VertexOutput) -> @location(0) vec4<f32> {
    // 正規化されたスクリーン座標を取得
    let uv = NormalizedCoords(in.position.xy);
    
    // 画面のX座標（-1.0〜1.0）を周波数インデックスにマッピング
    // Spectrum.num_pointsを使用して全画面を活用
    let freq_index = u32(clamp((uv.x + 1.0) * 0.5 * f32(Spectrum.num_points), 0.0, f32(Spectrum.num_points - 1u)));
    
    // 指定した周波数インデックスの振幅を取得
    let amplitude = SpectrumAmplitude(freq_index);
    
    // 周波数に応じた感度調整
    let frequency_ratio = f32(freq_index) / f32(Spectrum.num_points);
    var sensitivity_multiplier = 1.0;
    
    if (frequency_ratio < 0.2) {
        // 低音域（0-20%）- 通常の感度
        sensitivity_multiplier = 8.0;
    } else if (frequency_ratio < 0.6) {
        // 中音域（20-60%）- 感度を上げる
        sensitivity_multiplier = 15.0;
    } else {
        // 高音域（60-100%）- 大幅に感度を上げる
        sensitivity_multiplier = 25.0;
    }
    
    // 振幅を周波数帯域に応じてスケーリング
    let scaled_amplitude = amplitude * sensitivity_multiplier;
    
    // 基本的な色の生成（より鮮やかに）
    var base_color = vec3(0.0);
    
    if (frequency_ratio < 0.2) {
        // 低音域（0-20%）- 赤系統
        base_color = vec3(1.0, 0.1, 0.0);
    } else if (frequency_ratio < 0.6) {
        // 中音域（20-60%）- 緑系統
        base_color = vec3(0.0, 1.0, 0.2);
    } else {
        // 高音域（60-100%）- 青系統
        base_color = vec3(0.0, 0.2, 1.0);
    }
    
    // 振幅に基づいて色の強度を決定
    let color_intensity = clamp(scaled_amplitude, 0.0, 1.0);
    let final_color = base_color * color_intensity;
    
    // 音が小さい場合でも各帯域の色を薄く表示
    let min_brightness = base_color * 0.08;  // 帯域別の最低輝度
    let enhanced_color = max(final_color, min_brightness);
    
    // 周波数に応じた微妙なグラデーション効果
    let gradient_factor = sin(frequency_ratio * 3.14159) * 0.15 + 0.85;
    let gradient_color = enhanced_color * gradient_factor;
    
    // 時間による微妙な変化を追加（動きを感じやすくする）
    let time_factor = sin(Time.duration * 1.5) * 0.1 + 0.9;
    let animated_color = gradient_color * time_factor;
    
    // 高音域の反応を更に向上させる後処理
    if (frequency_ratio > 0.6) {
        // 高音域の場合、より敏感に反応
        let high_freq_boost = pow(color_intensity, 0.7);  // ガンマ補正で敏感に
        let boosted_color = base_color * high_freq_boost;
        let final_boosted = max(animated_color, boosted_color * 0.5);
        return vec4(ToLinearRgb(final_boosted), 1.0);
    }
    
    // 色空間を変換して出力
    return vec4(ToLinearRgb(animated_color), 1.0);
}

// 改善点：
// 1. 周波数範囲を20-8000Hzに拡大（より多くの音楽成分をカバー）
// 2. 周波数帯域別の感度調整（低音域:8倍、中音域:15倍、高音域:25倍）
// 3. 帯域の割合を調整（低音域20%、中音域40%、高音域40%）
// 4. 各帯域の最低輝度を色別に設定
// 5. 高音域専用の追加ブースト処理
// 6. より鮮やかな色設定

// 期待される動作：
// - 低音域（左側20%）：赤色で表示
// - 中音域（中央40%）：緑色で表示、感度向上
// - 高音域（右側40%）：青色で表示、大幅な感度向上
// - 音楽の全帯域で明確な反応を表示
// - 音が無い場合でも各帯域の色を薄く表示