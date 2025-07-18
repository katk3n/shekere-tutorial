// Chapter 5 Example 2: 周波数バーの可視化
// 周波数帯域別に色分けされたバーを表示するシェーダー

@fragment
fn fs_main(in: VertexOutput) -> @location(0) vec4<f32> {
    // 正規化されたスクリーン座標を取得
    let uv = NormalizedCoords(in.position.xy);
    
    // 画面のX座標を周波数インデックスにマッピング
    // アスペクト比に関係なく均等分布するように調整
    let screen_x = (uv.x + 1.0) * 0.5; // 0.0 ~ 1.0 に正規化
    let freq_index = u32(clamp(screen_x * f32(Spectrum.num_points), 0.0, f32(Spectrum.num_points - 1u)));
    
    // 周波数と振幅を取得
    let frequency = SpectrumFrequency(freq_index);
    let amplitude = SpectrumAmplitude(freq_index);
    
    // 20-4000Hz範囲での感度調整
    var sensitivity_multiplier = 1.0;
    
    if (frequency < 100.0) {
        // 超低音域 - 標準感度
        sensitivity_multiplier = 2.0;
    } else if (frequency < 400.0) {
        // 低音域 - 感度を上げる
        sensitivity_multiplier = 3.0;
    } else if (frequency < 800.0) {
        // 中低音域 - さらに感度を上げる
        sensitivity_multiplier = 4.5;
    } else if (frequency < 1400.0) {
        // 中音域 - 高い感度
        sensitivity_multiplier = 6.0;
    } else if (frequency < 2200.0) {
        // 高中音域 - より高い感度
        sensitivity_multiplier = 8.0;
    } else if (frequency < 3200.0) {
        // 高音域 - 大幅に感度を上げる
        sensitivity_multiplier = 10.0;
    } else {
        // 超高音域 - 最大感度
        sensitivity_multiplier = 12.0;
    }
    
    // 振幅を周波数帯域に応じてスケーリング
    let scaled_amplitude = amplitude * sensitivity_multiplier;
    
    // Y座標を0.0〜1.0に正規化（0.0が下、1.0が上）
    let y_normalized = (-uv.y + 1.0) * 0.5;
    
    // バーの高さを計算（下から上へ）
    let bar_height = clamp(scaled_amplitude, 0.0, 1.0);
    
    // 現在のピクセルがバーの範囲内かチェック（下から上へのバー）
    let is_in_bar = y_normalized <= bar_height;
    
    // 20-4000Hz範囲での色分け（紫の範囲を狭くしつつ維持）
    var base_color = vec3(0.0);
    
    if (frequency < 100.0) {
        // 超低音域（20-100Hz）- 深い赤
        base_color = vec3(0.9, 0.1, 0.1);
    } else if (frequency < 400.0) {
        // 低音域（100-400Hz）- 赤からオレンジ
        let t = (frequency - 100.0) / 300.0;
        base_color = mix(vec3(0.9, 0.1, 0.1), vec3(1.0, 0.6, 0.0), t);
    } else if (frequency < 800.0) {
        // 中低音域（400-800Hz）- オレンジから黄色
        let t = (frequency - 400.0) / 400.0;
        base_color = mix(vec3(1.0, 0.6, 0.0), vec3(1.0, 1.0, 0.2), t);
    } else if (frequency < 1400.0) {
        // 中音域（800-1400Hz）- 黄色から緑
        let t = (frequency - 800.0) / 600.0;
        base_color = mix(vec3(1.0, 1.0, 0.2), vec3(0.2, 1.0, 0.2), t);
    } else if (frequency < 2200.0) {
        // 高中音域（1400-2200Hz）- 緑から青緑
        let t = (frequency - 1400.0) / 800.0;
        base_color = mix(vec3(0.2, 1.0, 0.2), vec3(0.0, 0.8, 1.0), t);
    } else if (frequency < 3200.0) {
        // 高音域（2200-3200Hz）- 青緑から青
        let t = (frequency - 2200.0) / 1000.0;
        base_color = mix(vec3(0.0, 0.8, 1.0), vec3(0.2, 0.3, 1.0), t);
    } else if (frequency < 3700.0) {
        // 超高音域（3200-3700Hz）- 青から紫
        let t = (frequency - 3200.0) / 500.0;
        base_color = mix(vec3(0.2, 0.3, 1.0), vec3(0.5, 0.2, 0.8), t);
    } else {
        // 最高音域（3700Hz以上）- 紫
        base_color = vec3(0.5, 0.2, 0.8);
    }
    
    // バーの内側の場合のみ色を表示
    var final_color = vec3(0.0);
    
    if (is_in_bar) {
        // 振幅に応じて色の強度を調整
        let intensity = clamp(scaled_amplitude * 0.7, 0.4, 1.0);
        final_color = base_color * intensity;
        
        // Y座標に応じてグラデーション効果を追加
        let gradient_factor = 0.7 + 0.3 * (1.0 - y_normalized);
        final_color = final_color * gradient_factor;
        
        // バーの上部をより明るく
        if (y_normalized > bar_height * 0.85) {
            final_color = final_color * 1.2;
        }
    } else {
        // バーの外側は帯域の色を薄く表示
        final_color = base_color * 0.08;
    }
    
    // 背景に微かなグリッド線を追加（スペクトラム数に基づく）
    let grid_x = fract(screen_x * f32(Spectrum.num_points / 8u));
    let grid_y = fract((uv.y + 1.0) * 0.5 * 40.0);
    
    if (grid_x < 0.08 || grid_y < 0.012) {
        final_color = final_color + vec3(0.06, 0.06, 0.06);
    }
    
    // 時間による微妙な変化を追加
    let time_factor = sin(Time.duration * 1.0) * 0.03 + 0.97;
    final_color = final_color * time_factor;
    
    // 各帯域の最低輝度を確保
    let min_brightness = base_color * 0.15;
    final_color = max(final_color, min_brightness);
    
    // 音が無い場合でも各帯域の境界を表示
    let freq_ratio = frequency / 4000.0;
    let boundary_effect = sin(freq_ratio * 15.0) * 0.015 + 0.985;
    final_color = final_color * boundary_effect;
    
    // 色空間を変換して出力
    return vec4(ToLinearRgb(final_color), 1.0);
}

// 元の仕様に戻した内容：
// 1. 直接的な周波数インデックスマッピング
// 2. Spectrum.num_pointsを使用して全画面を活用
// 3. 周波数帯域の境界を音楽的に意味のある値に調整
// 4. 感度調整を現実的な値に設定
// 5. 最低輝度を向上させて全帯域の表示を確保
// 6. グリッド線を細かくして全画面での表示を改善

// 期待される動作：
// - 音楽を再生すると、画面全体に周波数バーが表示される
// - 左端（超低音域）は深い赤色
// - 左1/4（低音域）は赤からオレンジ
// - 中央（中音域）は緑色（感度向上）
// - 右1/4（高中音域）は青緑色（大幅な感度向上）
// - 右端（高音域）は紫色（最大感度）
// - 音の大きさに応じてバーの高さが変化
// - 音が無い場合でも各帯域の色を薄く表示
// - 画面全体でバランスの取れた表示