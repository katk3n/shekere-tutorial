# 演習課題 2: 音響波形ビジュアライザー

## 目標
音響データとsin/cos関数を組み合わせて、美しい波形パターンを作成できるようになる。数学的な波動関数を理解し、音楽に反応する動的な波の可視化技術を習得する。

## 課題内容
sin/cos関数を使った波形を音響信号で制御し、音楽の周波数や振幅に応じて変化する美しい波形ビジュアライゼーションを作成してください。

### 2-1. 基本波形の作成
以下の効果を順番に作成し、波形ビジュアライゼーションの基本を理解してください：

1. **単純な正弦波**
   - 画面に水平な正弦波を描画
   - 低音域の振幅で波の高さ（振幅）を制御
   - 中音域の振幅で波の周波数（波長）を制御

2. **垂直波形の追加**
   - 水平波形に加えて垂直方向の波形を追加
   - コサイン関数を使用して位相の違いを表現
   - 高音域の振幅で垂直波の強度を制御

3. **時間による波の進行**
   - `Time.duration`を使って波が流れるような動きを追加
   - 音響データで波の進行速度を制御
   - 波の移動方向を音響レベルで制御

### 2-2. 複合波形の生成
以下の効果を作成してください：

1. **複数波の重ね合わせ**
   - 異なる周波数の複数の波を同時に表示
   - 低音域・中音域・高音域でそれぞれ異なる波を制御
   - 波の干渉パターンによる美しい効果

2. **リサージュ図形**
   - X軸とY軸に異なる周波数のsin/cos波を適用
   - 音響データで両軸の周波数比を制御
   - 音楽に応じて変化する幾何学的パターン

3. **放射状波形**
   - 中心から放射状に広がる波形パターン
   - 角度方向にsin/cos関数を適用
   - 距離方向に音響反応の波を重ね合わせ

### 2-3. 創作課題
以下の中から1つ選んで実装してください：

1. **音響波紋効果**
   - 複数の点から同心円状に広がる波紋
   - 各波紋の中心位置と周波数を音響データで制御
   - 波紋同士の干渉による複雑な模様

2. **三次元風波面表現**
   - 2Dシェーダーで3D的な波面を表現
   - sin/cosの組み合わせで高度なうねりを表現
   - 音響による波面の形状と色彩の制御

3. **音響スパイログラフ**
   - 複数の円運動を組み合わせた軌跡パターン
   - 各円の半径と回転速度を音響で制御
   - 美しい数学的図形の音響連動表現

## 実装の手引き

### 基本的な正弦波
```wgsl
// 2-1-1. 単純な正弦波
@fragment
fn fs_main(in: VertexOutput) -> @location(0) vec4<f32> {
    let uv = NormalizedCoords(in.position.xy);
    let time = Time.duration;
    
    // 音響データを取得
    let bass = getBandAmplitude(0u, Spectrum.num_points / 3u);
    let mid = getBandAmplitude(Spectrum.num_points / 3u, (Spectrum.num_points * 2u) / 3u);
    
    // 水平方向の正弦波
    let wave_frequency = 3.0 + mid * 5.0;  // 中音域で周波数を制御
    let wave_amplitude = 0.3 + bass * 0.5;  // 低音域で振幅を制御
    let wave_phase = time * 2.0;  // 時間による位相変化
    
    // 波形の計算
    let wave_value = sin(uv.x * wave_frequency + wave_phase) * wave_amplitude;
    
    // 現在のピクセルが波形上にあるかチェック
    let wave_distance = abs(uv.y - wave_value);
    let wave_thickness = 0.05;
    let is_on_wave = wave_distance < wave_thickness;
    
    // 波形の色を決定
    let wave_color = vec3(
        is_on_wave ? (0.8 + bass * 0.5) : 0.0,
        is_on_wave ? (0.6 + mid * 0.4) : 0.0,
        is_on_wave ? 0.3 : 0.0
    );
    
    return vec4(ToLinearRgb(wave_color), 1.0);
}

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
```

### 複数波の重ね合わせ
```wgsl
// 2-2-1. 複数波の重ね合わせ
@fragment
fn fs_main(in: VertexOutput) -> @location(0) vec4<f32> {
    let uv = NormalizedCoords(in.position.xy);
    let time = Time.duration;
    
    // 各周波数帯域の振幅を取得
    let bass = getBandAmplitude(0u, Spectrum.num_points / 3u);
    let mid = getBandAmplitude(Spectrum.num_points / 3u, (Spectrum.num_points * 2u) / 3u);
    let treble = getBandAmplitude((Spectrum.num_points * 2u) / 3u, Spectrum.num_points);
    
    // 3つの異なる波を生成
    let wave1 = sin(uv.x * 2.0 + time * 1.0) * (0.15 + bass * 0.25);    // 低周波波
    let wave2 = sin(uv.x * 5.0 + time * 2.0) * (0.10 + mid * 0.20);     // 中周波波
    let wave3 = sin(uv.x * 8.0 + time * 3.0) * (0.05 + treble * 0.15);  // 高周波波
    
    // 波の合成
    let combined_wave = wave1 + wave2 + wave3;
    
    // 各波を異なる色で表示
    let wave1_intensity = 1.0 - abs(uv.y - wave1) / 0.08;
    let wave2_intensity = 1.0 - abs(uv.y - wave2) / 0.06;
    let wave3_intensity = 1.0 - abs(uv.y - wave3) / 0.04;
    let combined_intensity = 1.0 - abs(uv.y - combined_wave) / 0.03;
    
    // 強度を0-1にクランプ
    let wave1_smooth = clamp(wave1_intensity, 0.0, 1.0);
    let wave2_smooth = clamp(wave2_intensity, 0.0, 1.0);
    let wave3_smooth = clamp(wave3_intensity, 0.0, 1.0);
    let combined_smooth = clamp(combined_intensity, 0.0, 1.0);
    
    // 色の合成
    var final_color = vec3(0.0);
    final_color += vec3(wave1_smooth * bass, 0.0, 0.0);           // 低音域：赤
    final_color += vec3(0.0, wave2_smooth * mid, 0.0);            // 中音域：緑
    final_color += vec3(0.0, 0.0, wave3_smooth * treble);        // 高音域：青
    final_color += vec3(combined_smooth * 0.8);                   // 合成波：白
    
    return vec4(ToLinearRgb(final_color), 1.0);
}
```

### リサージュ図形
```wgsl
// 2-2-2. リサージュ図形
@fragment
fn fs_main(in: VertexOutput) -> @location(0) vec4<f32> {
    let uv = NormalizedCoords(in.position.xy);
    let time = Time.duration;
    
    // 音響データを取得
    let bass = getBandAmplitude(0u, Spectrum.num_points / 4u);
    let mid = getBandAmplitude(Spectrum.num_points / 4u, Spectrum.num_points / 2u);
    let treble = getBandAmplitude(Spectrum.num_points / 2u, Spectrum.num_points);
    
    // リサージュ図形のパラメータ
    let freq_x = 2.0 + bass * 3.0;    // X軸の周波数
    let freq_y = 3.0 + mid * 4.0;     // Y軸の周波数
    let phase_diff = treble * 6.28;   // 位相差
    
    // リサージュ曲線の軌跡を計算
    let lissajous_x = sin(time * freq_x) * 0.6;
    let lissajous_y = sin(time * freq_y + phase_diff) * 0.6;
    let lissajous_pos = vec2(lissajous_x, lissajous_y);
    
    // 現在位置からリサージュ軌跡までの距離
    let distance_to_curve = length(uv - lissajous_pos);
    
    // 軌跡の描画
    let curve_thickness = 0.05 + treble * 0.03;
    let curve_intensity = 1.0 - clamp(distance_to_curve / curve_thickness, 0.0, 1.0);
    
    // 軌跡の色（周波数によって変化）
    let curve_color = vec3(
        0.5 + sin(freq_x * time) * 0.5,
        0.5 + cos(freq_y * time) * 0.5,
        0.5 + sin(phase_diff + time) * 0.5
    );
    
    // 背景グラデーション（音響レベルで制御）
    let total_audio = (bass + mid + treble) / 3.0;
    let background = vec3(total_audio * 0.1, total_audio * 0.05, total_audio * 0.15);
    
    // 最終色の合成
    let final_color = background + curve_color * curve_intensity;
    
    return vec4(ToLinearRgb(final_color), 1.0);
}
```

### 放射状波形
```wgsl
// 2-2-3. 放射状波形
@fragment
fn fs_main(in: VertexOutput) -> @location(0) vec4<f32> {
    let uv = NormalizedCoords(in.position.xy);
    let time = Time.duration;
    
    // 極座標への変換
    let radius = length(uv);
    let angle = atan2(uv.y, uv.x);
    
    // 音響データを取得
    let bass = getBandAmplitude(0u, Spectrum.num_points / 3u);
    let mid = getBandAmplitude(Spectrum.num_points / 3u, (Spectrum.num_points * 2u) / 3u);
    let treble = getBandAmplitude((Spectrum.num_points * 2u) / 3u, Spectrum.num_points);
    
    // 角度方向の波形
    let angular_frequency = 8.0 + mid * 8.0;
    let angular_wave = sin(angle * angular_frequency + time * 2.0) * (0.1 + bass * 0.2);
    
    // 距離方向の波形
    let radial_frequency = 6.0 + treble * 10.0;
    let radial_wave = sin(radius * radial_frequency - time * 3.0) * (0.05 + treble * 0.1);
    
    // 波形の合成
    let target_radius = 0.3 + angular_wave + radial_wave;
    
    // 波形の描画強度を計算
    let wave_distance = abs(radius - target_radius);
    let wave_thickness = 0.02 + bass * 0.02;
    let wave_intensity = 1.0 - clamp(wave_distance / wave_thickness, 0.0, 1.0);
    
    // 色の計算（角度に応じた色相変化）
    let hue_shift = angle / 6.28 + time * 0.5;
    let wave_color = vec3(
        0.5 + sin(hue_shift * 6.28) * 0.5,
        0.5 + sin(hue_shift * 6.28 + 2.09) * 0.5,  // 120度位相差
        0.5 + sin(hue_shift * 6.28 + 4.19) * 0.5   // 240度位相差
    );
    
    // 音響レベルに応じた明度調整
    let brightness = 0.3 + (bass + mid + treble) * 0.7;
    let final_color = wave_color * wave_intensity * brightness;
    
    return vec4(ToLinearRgb(final_color), 1.0);
}
```

## 学習のポイント
- **波動関数の理解**: sin/cos関数の数学的性質と視覚的表現の関係
- **波の干渉**: 複数の波が重なり合って生じる美しいパターン
- **極座標変換**: 直交座標から極座標への変換技術
- **音響マッピング**: 音響データを波のパラメータに効果的にマッピングする方法
- **時間変化**: 時間による波の進行と位相変化の制御

## 動作確認のコツ
- **波の可視性**: 波形が明確に見えるよう線の太さと色を調整
- **音響反応性**: 音楽の変化が波形の変化として分かりやすく表現されているかチェック
- **干渉パターン**: 複数の波が重なった時の美しい干渉効果を確認
- **パフォーマンス**: 複雑な波形計算でもスムーズに動作するか確認

## 発展的な学習
この演習で学んだ技術は以下に応用できます：
- より高次の波動方程式（方形波、三角波、のこぎり波）
- フーリエ級数による複雑な波形の合成
- 3次元波動の2次元投影表現
- 物理シミュレーション（水面波、音波の伝播）
- インタラクティブな波形生成ツールの作成