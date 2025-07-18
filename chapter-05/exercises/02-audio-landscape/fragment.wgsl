// Chapter 5 Solution 2: 音響ランドスケープジェネレーター - 解答例
// 演習課題2「音響地形と水面効果」に対する解答例

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
    
    // --- 1. 地形生成 ---
    // 基本的な山の形状（中央が高い）
    let mountain_base = 1.0 - abs(uv.x * 0.6);
    
    // 音響による地形レイヤー
    let bass_terrain = sin(uv.x * 3.0 + time * 0.5) * 0.15 * bass;
    let mid_terrain = sin(uv.x * 8.0 + time * 1.2) * 0.12 * mid;
    let treble_terrain = sin(uv.x * 15.0 + time * 2.5) * 0.08 * treble;
    
    // 地形の合成
    let terrain_height = (mountain_base * 0.4 + bass * 0.3) + bass_terrain + mid_terrain + treble_terrain;
    
    // --- 2. 水面生成 ---
    // 複数の波の重ね合わせ
    let wave1 = sin(uv.x * 6.0 + time * 3.0) * 0.06 * bass;
    let wave2 = sin(uv.x * 12.0 - time * 2.5) * 0.04 * mid;
    let wave3 = sin(uv.x * 20.0 + time * 4.5) * 0.02 * treble;
    
    let water_level = -0.4 + wave1 + wave2 + wave3;
    
    // --- 3. Y座標の正規化 ---
    let normalized_y = (uv.y + 1.0) * 0.5;  // 0.0(下) ~ 1.0(上)
    let terrain_boundary = (terrain_height + 1.0) * 0.5;
    let water_boundary = (water_level + 1.0) * 0.5;
    
    var final_color = vec3(0.0);
    
    // --- 4. 領域判定と色付け ---
    if (normalized_y < water_boundary) {
        // === 水中・水面下 ===
        let depth = water_boundary - normalized_y;
        
        // 水の基本色（深度に応じて変化）
        let water_base_color = vec3(0.1, 0.4, 0.8);
        let depth_factor = clamp(1.0 - depth * 3.0, 0.2, 1.0);
        
        // 音響による水の色変化
        let water_color_mod = vec3(
            1.0 + bass * 0.3,
            1.0 + mid * 0.2,
            1.0 + treble * 0.4
        );
        
        final_color = water_base_color * depth_factor * water_color_mod;
        
        // 波による光の屈折効果
        let wave_distortion = sin(uv.x * 25.0 + time * 6.0) * sin(normalized_y * 40.0 + time * 5.0);
        final_color = final_color * (1.0 + wave_distortion * 0.2 * mid);
        
    } else if (normalized_y < terrain_boundary) {
        // === 地形部分 ===
        let height_in_terrain = (normalized_y - water_boundary) / (terrain_boundary - water_boundary);
        
        // 高度による色分け
        if (height_in_terrain < 0.3) {
            // 低地 - 森林（緑）
            let forest_color = vec3(0.2, 0.6, 0.2);
            let bass_influence = vec3(bass * 0.4, bass * 0.2, 0.0);
            final_color = forest_color + bass_influence;
            
        } else if (height_in_terrain < 0.7) {
            // 中間地 - 岩場（茶色）
            let rock_color = vec3(0.5, 0.4, 0.3);
            let mid_influence = vec3(mid * 0.3, mid * 0.3, mid * 0.1);
            final_color = rock_color + mid_influence;
            
        } else {
            // 高地 - 雪山（白）
            let snow_color = vec3(0.9, 0.9, 0.95);
            let treble_sparkle = treble * 0.3;
            final_color = snow_color + vec3(treble_sparkle);
        }
        
        // 地形の質感（ノイズ効果）
        let terrain_noise = sin(uv.x * 30.0) * sin(uv.y * 25.0 + time * 1.5) * 0.1;
        final_color = final_color * (1.0 + terrain_noise);
        
    } else {
        // === 空部分 ===
        let height_in_sky = (normalized_y - terrain_boundary) / (1.0 - terrain_boundary);
        
        // 空の基本色（グラデーション）
        let sky_base = mix(
            vec3(0.6, 0.8, 1.0),  // 地平線近く（薄い青）
            vec3(0.2, 0.4, 0.8),  // 上空（濃い青）
            height_in_sky
        );
        
        // 音響による空の色変化
        let sky_audio_mod = vec3(
            1.0 + bass * 0.1,
            1.0 + mid * 0.15,
            1.0 + treble * 0.2
        );
        
        final_color = sky_base * sky_audio_mod;
        
        // 雲の効果（高音域で制御）
        let cloud_pattern = sin(uv.x * 8.0 + time * 1.0) * sin((uv.y + 1.0) * 12.0 + time * 0.8);
        if (cloud_pattern > 0.3 && treble > 0.2) {
            let cloud_intensity = (cloud_pattern - 0.3) / 0.7 * treble;
            final_color = mix(final_color, vec3(1.0, 1.0, 1.0), cloud_intensity * 0.6);
        }
    }
    
    // --- 5. 全体的な効果 ---
    // 音響レベルに応じた全体の明度調整
    let total_amplitude = (bass + mid + treble) / 3.0;
    let brightness_factor = 0.8 + total_amplitude * 0.3;
    final_color = final_color * brightness_factor;
    
    // 時間による微妙な色の変化（日の出・日没効果）
    let time_of_day = sin(time * 0.3) * 0.5 + 0.5;
    let sunset_tint = vec3(1.0, 0.8 + time_of_day * 0.2, 0.6 + time_of_day * 0.4);
    final_color = final_color * mix(vec3(1.0), sunset_tint, time_of_day * 0.3);
    
    // 最低輝度の確保
    final_color = max(final_color, vec3(0.02, 0.02, 0.03));
    
    return vec4(ToLinearRgb(final_color), 1.0);
}

// 解答例のポイント：
// 1. 複数レイヤーの地形生成（基本形状 + 音響変動）
// 2. 動的な水面表現（複数の波の重ね合わせ）
// 3. 高度による色分け（森林・岩場・雪山）
// 4. 空と雲の表現（音響による雲の制御）
// 5. 環境全体の統合（明度・時間変化）

// 学習ポイント：
// - 複数の地形レイヤーの合成技術
// - 領域判定による色分け
// - 自然現象のシミュレーション
// - 音響データの空間的マッピング
// - 環境の一貫性を保つ色彩設計

// 応用のヒント：
// - より複雑な地形アルゴリズム
// - 季節変化の実装
// - より高度な水面表現
// - 複数光源による照明効果
// - 気象効果（雨、雪、霧）の追加