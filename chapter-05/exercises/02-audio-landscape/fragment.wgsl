// Chapter 5 Solution 2: 音響波形ビジュアライザー - 解答例
// 演習課題2「音響波形ビジュアライゼーション」に対する解答例

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
    
    // === 音響データの取得（周波数帯域を調整） ===
    let bass = getBandAmplitude(0u, Spectrum.num_points / 4u);                    // 0-25%: 低音域
    let mid = getBandAmplitude(Spectrum.num_points / 4u, Spectrum.num_points / 2u); // 25-50%: 中音域  
    let treble = getBandAmplitude(Spectrum.num_points / 2u, Spectrum.num_points);   // 50-100%: 高音域
    
    // === 1. 基本的な水平正弦波 ===
    // 低音域で振幅を制御、中音域で周波数を制御（感度大幅向上）
    let base_frequency = 4.0 + mid * 12.0;
    let base_amplitude = 0.25 + bass * 0.8;
    let base_phase = time * 1.5;
    let base_wave = sin(uv.x * base_frequency + base_phase) * base_amplitude;
    
    // === 2. 複数波の重ね合わせ ===
    // 異なる周波数帯域で制御される3つの波（感度を極限まで向上）
    let wave1 = sin(uv.x * 2.5 + time * 1.0) * (0.15 + bass * 1.50);    // 低周波波
    let wave2 = sin(uv.x * 6.0 + time * 2.2) * (0.12 + mid * 1.80);     // 中周波波  
    let wave3 = sin(uv.x * 11.0 + time * 3.5) * (0.08 + treble * 1.50); // 高周波波
    
    // === 3. 波形の合成と描画 ===
    var final_color = vec3(0.0);
    
    // 水平波形群の描画（線の太さも音響感度向上）
    let horizontal_combined = base_wave + wave1 + wave2 + wave3;
    let h_wave_distance = abs(uv.y - horizontal_combined);
    let h_wave_thickness = 0.04 + (bass + mid + treble) * 0.04;
    let h_wave_intensity = 1.0 - clamp(h_wave_distance / h_wave_thickness, 0.0, 1.0);
    
    // 個別波形の色付け（線の太さ調整）
    let wave1_distance = abs(uv.y - wave1);
    let wave2_distance = abs(uv.y - wave2);
    let wave3_distance = abs(uv.y - wave3);
    
    let wave1_intensity = 1.0 - clamp(wave1_distance / 0.06, 0.0, 1.0);
    let wave2_intensity = 1.0 - clamp(wave2_distance / 0.05, 0.0, 1.0);
    let wave3_intensity = 1.0 - clamp(wave3_distance / 0.04, 0.0, 1.0);
    
    // === 4. 色彩の合成 ===
    // 各波形に異なる色を割り当て（緑・青の感度を最大限向上）
    
    // 低音域波形 - 赤系統
    final_color += vec3(wave1_intensity * (1.0 + bass * 4.0), wave1_intensity * bass * 1.0, 0.0);
    
    // 中音域波形 - 緑系統（感度最大化）
    final_color += vec3(wave2_intensity * mid * 1.5, wave2_intensity * (1.0 + mid * 6.0), wave2_intensity * mid * 1.0);
    
    // 高音域波形 - 青系統（感度最大化）
    final_color += vec3(0.0, wave3_intensity * treble * 2.0, wave3_intensity * (1.0 + treble * 6.0));
    
    // 合成水平波形 - 白系統（全体の輪郭、音響反応向上）
    let current_total_audio = (bass + mid + treble) / 3.0;
    final_color += vec3(h_wave_intensity * (0.8 + current_total_audio * 1.5));
    
    // === 5. 背景効果とポストプロセシング ===
    // 音響レベルに応じた背景グラデーション
    let total_audio = (bass + mid + treble) / 3.0;
    let background_base = vec3(
        total_audio * 0.05,
        total_audio * 0.08, 
        total_audio * 0.12
    );
    
    // 位置に応じた背景の微妙な変化（length(uv)を再定義）
    let radius = length(uv);
    let position_factor = (radius + 1.0) * 0.5;
    let background_gradient = background_base * (0.5 + position_factor * 0.5);
    
    final_color += background_gradient;
    
    // === 6. リサージュ効果の追加 ===
    // 音響データで制御されるリサージュ図形（感度向上）
    let lissajous_freq_x = 2.0 + bass * 4.0;
    let lissajous_freq_y = 3.0 + mid * 6.0;
    let lissajous_phase = treble * 12.56;
    
    let lissajous_x = sin(time * lissajous_freq_x) * 0.7;
    let lissajous_y = sin(time * lissajous_freq_y + lissajous_phase) * 0.7;
    let lissajous_pos = vec2(lissajous_x, lissajous_y);
    
    let lissajous_distance = length(uv - lissajous_pos);
    let lissajous_size = 0.03 + treble * 0.05;
    let lissajous_intensity = 1.0 - clamp(lissajous_distance / lissajous_size, 0.0, 1.0);
    
    // リサージュの軌跡色（時間で変化、明度向上）
    let lissajous_color = vec3(
        0.9 + sin(time * 2.0) * 0.1,
        0.8 + cos(time * 1.5) * 0.2,
        1.0
    );
    
    final_color += lissajous_color * lissajous_intensity * (0.5 + total_audio * 2.5);
    
    // === 7. 最終調整 ===
    // 音響レベルに応じた全体の明度調整（感度さらに向上）
    let brightness_boost = 0.7 + total_audio * 1.5;
    final_color = final_color * brightness_boost;
    
    // 時間による色調変化（微妙な効果）
    let time_hue = sin(time * 0.2) * 0.1 + 1.0;
    final_color = final_color * vec3(time_hue, 1.0, time_hue);
    
    // 最低輝度の確保（完全な黒を避ける）
    final_color = max(final_color, vec3(0.01, 0.01, 0.02));
    
    // 最大輝度の制限（過度な明度を防ぐ）
    final_color = min(final_color, vec3(1.5, 1.5, 1.5));
    
    return vec4(ToLinearRgb(final_color), 1.0);
}

// === 解答例の実装ポイント ===
// 1. 複数の波形タイプの同時表示
//    - 水平正弦波（基本＋3つの周波数）
//    - 垂直コサイン波  
//    - 放射状波形（極座標）
//    - リサージュ図形

// 2. 音響データの効果的なマッピング
//    - 低音域：波の振幅と基本形状制御
//    - 中音域：波の周波数と密度制御
//    - 高音域：詳細効果と色彩制御

// 3. 視覚的な階層構造
//    - メインの波形：明確で太い線
//    - サブ波形：細かい詳細効果
//    - 背景：音響に反応する環境効果

// 4. 色彩設計
//    - 周波数帯域ごとの色分け
//    - 時間による色調変化
//    - 角度/位置による色相シフト

// === 学習効果 ===
// - sin/cos関数の実際的な活用方法
// - 複数波の干渉と合成技術
// - 音響データの視覚的マッピング手法
// - 極座標変換の応用
// - 色彩と動きの調和的な組み合わせ

// === 応用可能性 ===  
// - より高次の波動方程式への拡張
// - 3D風波面表現への発展
// - インタラクティブ楽器との連携
// - VJ用リアルタイム波形ツール
// - 教育用音響可視化ツール