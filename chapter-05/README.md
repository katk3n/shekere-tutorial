# Chapter 5: Audio Visualization
## 音響ビジュアライゼーション

### 本章の目標
- 音響ビジュアライゼーションの基本概念を理解する
- `SpectrumAmplitude()`関数の使用方法を習得する
- 周波数帯域の分析とマッピング技術を学ぶ
- 音響リアクティブパターンの作成方法を理解する
- リアルタイム音響処理の実装技術を習得する

---

## 1. 音響ビジュアライゼーションとは

### 音響ビジュアライゼーションの定義
**音響ビジュアライゼーション**とは、音響信号をリアルタイムで解析し、その特性を視覚的に表現する技術です。音の周波数、振幅、位相などの情報を美しいグラフィック表現に変換します。

### 音響ビジュアライゼーションの特徴
- **リアルタイム応答**: 音響信号に対する即座の視覚的フィードバック
- **周波数分析**: FFT（高速フーリエ変換）による周波数成分の抽出
- **動的表現**: 音楽の変化に応じた動的な視覚効果
- **音楽的表現**: 音楽の感情やリズムを視覚的に表現

### 音響ビジュアライゼーションの応用分野
- **VJパフォーマンス**: ライブ音楽イベントでの映像演出
- **音楽制作**: 音響エンジニアリングの視覚的支援
- **教育ツール**: 音響学習の視覚的補助
- **インタラクティブアート**: 音響連動型インスタレーション

---

## 2. 音響信号の基本理解

### 音響信号の構成要素

#### 1. 振幅（Amplitude）
```wgsl
// 振幅は音の大きさを表す
// 範囲: 0.0（無音）〜 1.0以上（最大音量）
let amplitude = SpectrumAmplitude(frequency_index);
```

#### 2. 周波数（Frequency）
```wgsl
// 周波数は音の高さを表す（Hz単位）
// 範囲: 20Hz（低音）〜 20000Hz（高音）
let frequency = SpectrumFrequency(frequency_index);
```

#### 3. 位相（Phase）
```wgsl
// 位相は音波の時間的な位置を表す
// shekereでは振幅と周波数が主に利用される
```

### 周波数帯域の分類

#### 低音域（Bass）: 20Hz - 250Hz
- **楽器**: キックドラム、ベース、低音楽器
- **特徴**: 力強い、圧迫感がある
- **色表現**: 赤、オレンジ系統

#### 中音域（Mid）: 250Hz - 4000Hz
- **楽器**: ボーカル、ギター、ピアノ
- **特徴**: 明瞭、メロディック
- **色表現**: 緑、黄色系統

#### 高音域（Treble）: 4000Hz - 20000Hz
- **楽器**: シンバル、ハイハット、高音楽器
- **特徴**: 鋭い、煌びやか
- **色表現**: 青、紫系統

---

## 3. SpectrumAmplitude()関数

### SpectrumAmplitude()の概要
`SpectrumAmplitude()`は、shekereフレームワークが提供する**音響スペクトラム解析関数**です。指定した周波数インデックスの振幅値を取得できます。

### 基本的な使用方法
```wgsl
// 周波数インデックスを指定して振幅を取得
let amplitude = SpectrumAmplitude(frequency_index);
// frequency_index: 0〜2047の範囲（2048ポイント）
// 戻り値: 振幅値（0.0〜1.0以上）
```

### 関数の特性
- **データ型**: `f32`（32ビット浮動小数点数）
- **入力範囲**: 0〜2047（u32型）
- **出力範囲**: 0.0〜1.0以上（通常は1.0以下）
- **無効インデックス**: 範囲外の値は0.0を返す

### 実践例: 基本的な振幅可視化
```wgsl
@fragment
fn fs_main(in: VertexOutput) -> @location(0) vec4<f32> {
    let uv = NormalizedCoords(in.position.xy);
    
    // 画面のX座標を周波数インデックスにマッピング
    let freq_index = u32((uv.x + 1.0) * 0.5 * 2048.0);
    
    // 振幅を取得
    let amplitude = SpectrumAmplitude(freq_index);
    
    // 振幅に基づいて色を決定
    let color = vec3(amplitude, amplitude * 0.5, amplitude * 0.2);
    
    return vec4(ToLinearRgb(color), 1.0);
}
```

**この例の動作**:
- 画面の横方向が周波数スペクトラムを表示
- 音響信号の振幅に応じて色が変化
- 左側が低音域、右側が高音域

---

## 4. SpectrumFrequency()関数

### SpectrumFrequency()の概要
`SpectrumFrequency()`は、周波数インデックスに対応する実際の周波数値（Hz）を取得する関数です。

### 基本的な使用方法
```wgsl
// 周波数インデックスから実際の周波数を取得
let frequency = SpectrumFrequency(frequency_index);
// frequency_index: 0〜2047の範囲
// 戻り値: 周波数値（Hz）
```

### 関数の特性
- **データ型**: `f32`（32ビット浮動小数点数）
- **入力範囲**: 0〜2047（u32型）
- **出力範囲**: 0.0〜サンプリング周波数の半分（通常22050Hz）
- **分解能**: 約21.5Hz（44100Hz/2048）

### 実践例: 周波数帯域別の色分け
```wgsl
@fragment
fn fs_main(in: VertexOutput) -> @location(0) vec4<f32> {
    let uv = NormalizedCoords(in.position.xy);
    
    // 画面のX座標を周波数インデックスにマッピング
    let freq_index = u32((uv.x + 1.0) * 0.5 * 2048.0);
    
    // 周波数と振幅を取得
    let frequency = SpectrumFrequency(freq_index);
    let amplitude = SpectrumAmplitude(freq_index);
    
    // 周波数帯域による色分け
    var color = vec3(0.0);
    if (frequency < 250.0) {
        // 低音域（Bass）- 赤系統
        color = vec3(amplitude, amplitude * 0.3, 0.0);
    } else if (frequency < 4000.0) {
        // 中音域（Mid）- 緑系統
        color = vec3(amplitude * 0.3, amplitude, amplitude * 0.3);
    } else {
        // 高音域（Treble）- 青系統
        color = vec3(0.0, amplitude * 0.3, amplitude);
    }
    
    return vec4(ToLinearRgb(color), 1.0);
}
```

---

## 5. スペクトラム表示の基本技術

### 1. 基本的なスペクトラムバー
```wgsl
@fragment
fn fs_main(in: VertexOutput) -> @location(0) vec4<f32> {
    let uv = NormalizedCoords(in.position.xy);
    
    // 横方向を周波数、縦方向を振幅として表示
    let freq_index = u32((uv.x + 1.0) * 0.5 * 2048.0);
    let amplitude = SpectrumAmplitude(freq_index);
    
    // バーの高さを計算
    let bar_height = amplitude * 2.0;  // 振幅を2倍にスケール
    
    // 現在のピクセルがバーの範囲内かチェック
    let is_in_bar = (uv.y + 1.0) * 0.5 < bar_height;
    
    // バーの色を決定
    let color = vec3(
        is_in_bar ? 1.0 : 0.0,
        is_in_bar ? 0.8 : 0.0,
        is_in_bar ? 0.2 : 0.0
    );
    
    return vec4(ToLinearRgb(color), 1.0);
}
```

### 2. 円形スペクトラム表示
```wgsl
@fragment
fn fs_main(in: VertexOutput) -> @location(0) vec4<f32> {
    let uv = NormalizedCoords(in.position.xy);
    
    // 極座標への変換
    let angle = atan2(uv.y, uv.x);
    let radius = length(uv);
    
    // 角度を周波数インデックスにマッピング
    let normalized_angle = (angle + 3.14159) / (2.0 * 3.14159);
    let freq_index = u32(normalized_angle * 2048.0);
    
    // 振幅を取得
    let amplitude = SpectrumAmplitude(freq_index);
    
    // 円形バーの内側かチェック
    let inner_radius = 0.3;
    let bar_length = amplitude * 0.5;
    let is_in_bar = radius > inner_radius && radius < inner_radius + bar_length;
    
    // 色を決定
    let color = vec3(
        is_in_bar ? amplitude : 0.0,
        is_in_bar ? amplitude * 0.7 : 0.0,
        is_in_bar ? amplitude * 0.3 : 0.0
    );
    
    return vec4(ToLinearRgb(color), 1.0);
}
```

### 3. 滑らかなスペクトラム表示
```wgsl
@fragment
fn fs_main(in: VertexOutput) -> @location(0) vec4<f32> {
    let uv = NormalizedCoords(in.position.xy);
    
    // 周波数インデックスを浮動小数点で計算
    let freq_float = (uv.x + 1.0) * 0.5 * 2048.0;
    let freq_index = u32(freq_float);
    
    // 隣接する周波数の振幅を取得
    let amp1 = SpectrumAmplitude(freq_index);
    let amp2 = SpectrumAmplitude(freq_index + 1u);
    
    // 線形補間で滑らかな振幅を計算
    let frac = fract(freq_float);
    let smooth_amplitude = mix(amp1, amp2, frac);
    
    // 色を決定
    let color = vec3(smooth_amplitude, smooth_amplitude * 0.8, smooth_amplitude * 0.6);
    
    return vec4(ToLinearRgb(color), 1.0);
}
```

---

## 6. 音響リアクティブパターン

### 1. 音響による形状変化
```wgsl
@fragment
fn fs_main(in: VertexOutput) -> @location(0) vec4<f32> {
    let uv = NormalizedCoords(in.position.xy);
    
    // 低音域の振幅を取得（インデックス0〜100）
    var bass_amplitude = 0.0;
    for (var i = 0u; i < 100u; i++) {
        bass_amplitude += SpectrumAmplitude(i);
    }
    bass_amplitude /= 100.0;  // 平均化
    
    // 音響に応じて円の大きさを変更
    let circle_radius = 0.2 + bass_amplitude * 0.3;
    let distance = length(uv);
    
    // 円の内側かチェック
    let is_inside = distance < circle_radius;
    
    // 色を決定
    let color = vec3(
        is_inside ? bass_amplitude : 0.0,
        is_inside ? bass_amplitude * 0.8 : 0.0,
        is_inside ? bass_amplitude * 0.6 : 0.0
    );
    
    return vec4(ToLinearRgb(color), 1.0);
}
```

### 2. 周波数帯域別の複数パターン
```wgsl
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
    
    // 各周波数帯域の振幅を取得
    let bass = getBandAmplitude(0u, 100u);      // 低音域
    let mid = getBandAmplitude(100u, 1000u);    // 中音域
    let treble = getBandAmplitude(1000u, 2048u); // 高音域
    
    // 位置に応じて異なる帯域を使用
    let distance = length(uv);
    var color = vec3(0.0);
    
    if (distance < 0.3) {
        // 中心部：低音域
        color = vec3(bass, bass * 0.5, 0.0);
    } else if (distance < 0.6) {
        // 中間部：中音域
        color = vec3(mid * 0.5, mid, mid * 0.5);
    } else if (distance < 0.9) {
        // 外側部：高音域
        color = vec3(0.0, treble * 0.5, treble);
    }
    
    return vec4(ToLinearRgb(color), 1.0);
}
```

### 3. 時間と音響の組み合わせ
```wgsl
@fragment
fn fs_main(in: VertexOutput) -> @location(0) vec4<f32> {
    let uv = NormalizedCoords(in.position.xy);
    let time = Time.duration;
    
    // 全体の音響レベルを計算
    var total_amplitude = 0.0;
    for (var i = 0u; i < 2048u; i++) {
        total_amplitude += SpectrumAmplitude(i);
    }
    total_amplitude /= 2048.0;
    
    // 音響に応じて回転速度を変更
    let rotation_speed = 1.0 + total_amplitude * 5.0;
    let rotated_uv = vec2(
        uv.x * cos(time * rotation_speed) - uv.y * sin(time * rotation_speed),
        uv.x * sin(time * rotation_speed) + uv.y * cos(time * rotation_speed)
    );
    
    // 回転したUV座標でパターンを生成
    let pattern = sin(rotated_uv.x * 10.0) * sin(rotated_uv.y * 10.0);
    
    // 音響レベルに応じて色の強度を調整
    let intensity = pattern * total_amplitude;
    let color = vec3(intensity, intensity * 0.8, intensity * 0.6);
    
    return vec4(ToLinearRgb(color), 1.0);
}
```

---

## 7. 色の周波数マッピング

### 1. HSV色空間を使った周波数マッピング
```wgsl
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
    let uv = NormalizedCoords(in.position.xy);
    
    // 周波数インデックスを取得
    let freq_index = u32((uv.x + 1.0) * 0.5 * 2048.0);
    let frequency = SpectrumFrequency(freq_index);
    let amplitude = SpectrumAmplitude(freq_index);
    
    // 周波数を色相にマッピング（20Hz-20000Hz -> 0-360度）
    let hue = (log(frequency + 1.0) / log(20000.0)) * 360.0;
    let saturation = 1.0;
    let value = amplitude;
    
    // HSVからRGBに変換
    let color = hsvToRgb(hue, saturation, value);
    
    return vec4(ToLinearRgb(color), 1.0);
}
```

### 2. 温度マッピング（Heat Map）
```wgsl
fn temperatureToColor(temperature: f32) -> vec3<f32> {
    // 温度を0.0-1.0の範囲で受け取り、色を返す
    let t = clamp(temperature, 0.0, 1.0);
    
    var color = vec3(0.0);
    if (t < 0.25) {
        // 黒 -> 赤
        color = vec3(t * 4.0, 0.0, 0.0);
    } else if (t < 0.5) {
        // 赤 -> 黄
        color = vec3(1.0, (t - 0.25) * 4.0, 0.0);
    } else if (t < 0.75) {
        // 黄 -> 白
        let white_factor = (t - 0.5) * 4.0;
        color = vec3(1.0, 1.0, white_factor);
    } else {
        // 白 -> 青白
        color = vec3(1.0, 1.0, 1.0);
    }
    
    return color;
}

@fragment
fn fs_main(in: VertexOutput) -> @location(0) vec4<f32> {
    let uv = NormalizedCoords(in.position.xy);
    
    // 全周波数の振幅を温度として可視化
    let freq_index = u32((uv.x + 1.0) * 0.5 * 2048.0);
    let amplitude = SpectrumAmplitude(freq_index);
    
    // 温度マップで色を決定
    let color = temperatureToColor(amplitude);
    
    return vec4(ToLinearRgb(color), 1.0);
}
```

---

## 8. 高度なビジュアライゼーション技術

### 1. スペクトログラム（時間-周波数表示）
```wgsl
@fragment
fn fs_main(in: VertexOutput) -> @location(0) vec4<f32> {
    let uv = NormalizedCoords(in.position.xy);
    
    // Y軸を周波数、X軸を時間として表示
    let freq_index = u32((1.0 - (uv.y + 1.0) * 0.5) * 2048.0);
    let amplitude = SpectrumAmplitude(freq_index);
    
    // 時間による色の変化（擬似的な時間軸）
    let time_factor = sin(Time.duration * 0.5) * 0.5 + 0.5;
    
    // 振幅と時間を組み合わせた色
    let color = vec3(
        amplitude * time_factor,
        amplitude * (1.0 - time_factor),
        amplitude * 0.5
    );
    
    return vec4(ToLinearRgb(color), 1.0);
}
```

### 2. 3D効果的なスペクトラム表示
```wgsl
@fragment
fn fs_main(in: VertexOutput) -> @location(0) vec4<f32> {
    let uv = NormalizedCoords(in.position.xy);
    
    // 疑似3D効果のための深度計算
    let depth = (uv.y + 1.0) * 0.5;
    let freq_index = u32((uv.x + 1.0) * 0.5 * 2048.0);
    let amplitude = SpectrumAmplitude(freq_index);
    
    // 深度に応じた振幅の調整
    let adjusted_amplitude = amplitude * (1.0 - depth * 0.7);
    
    // 3D効果のためのシェーディング
    let shading = 1.0 - depth * 0.5;
    
    // 色の計算
    let color = vec3(
        adjusted_amplitude * shading,
        adjusted_amplitude * shading * 0.8,
        adjusted_amplitude * shading * 0.6
    );
    
    return vec4(ToLinearRgb(color), 1.0);
}
```

### 3. パーティクルシステム風エフェクト
```wgsl
@fragment
fn fs_main(in: VertexOutput) -> @location(0) vec4<f32> {
    let uv = NormalizedCoords(in.position.xy);
    let time = Time.duration;
    
    // 複数のパーティクルを生成
    var final_color = vec3(0.0);
    
    for (var i = 0u; i < 20u; i++) {
        let particle_freq = i * 100u;
        let amplitude = SpectrumAmplitude(particle_freq);
        
        // パーティクルの位置を計算
        let particle_x = sin(time * 0.5 + f32(i) * 0.3) * 0.8;
        let particle_y = cos(time * 0.3 + f32(i) * 0.5) * 0.8;
        let particle_pos = vec2(particle_x, particle_y);
        
        // パーティクルとの距離を計算
        let distance = length(uv - particle_pos);
        
        // 音響に応じてパーティクルのサイズを変更
        let particle_size = 0.05 + amplitude * 0.1;
        let particle_intensity = clamp(1.0 - distance / particle_size, 0.0, 1.0);
        
        // パーティクルの色を追加
        final_color += vec3(
            particle_intensity * amplitude,
            particle_intensity * amplitude * 0.8,
            particle_intensity * amplitude * 0.6
        );
    }
    
    return vec4(ToLinearRgb(final_color), 1.0);
}
```

---

## 9. 実践的なテクニック

### 音響データの平滑化
```wgsl
fn getSmoothedAmplitude(freq_index: u32, window_size: u32) -> f32 {
    var total = 0.0;
    var count = 0u;
    
    let start = max(0u, freq_index - window_size / 2u);
    let end = min(2048u, freq_index + window_size / 2u);
    
    for (var i = start; i < end; i++) {
        total += SpectrumAmplitude(i);
        count++;
    }
    
    return total / f32(count);
}
```

### 音響レベルの正規化
```wgsl
fn normalizeAmplitude(amplitude: f32) -> f32 {
    // 対数スケールで正規化
    return clamp(log(amplitude + 1.0) / log(2.0), 0.0, 1.0);
}
```

### 周波数帯域のグループ化
```wgsl
fn getFrequencyBand(band_index: u32) -> f32 {
    // 8つの周波数帯域に分割
    let band_size = 2048u / 8u;
    let start_freq = band_index * band_size;
    let end_freq = start_freq + band_size;
    
    var total = 0.0;
    for (var i = start_freq; i < end_freq; i++) {
        total += SpectrumAmplitude(i);
    }
    
    return total / f32(band_size);
}
```

---

## 10. パフォーマンス最適化

### 効率的な周波数サンプリング
```wgsl
@fragment
fn fs_main(in: VertexOutput) -> @location(0) vec4<f32> {
    let uv = NormalizedCoords(in.position.xy);
    
    // 低解像度でサンプリング（パフォーマンス向上）
    let sample_rate = 4u;  // 4つおきにサンプリング
    let freq_index = u32((uv.x + 1.0) * 0.5 * 2048.0 / f32(sample_rate)) * sample_rate;
    
    let amplitude = SpectrumAmplitude(freq_index);
    let color = vec3(amplitude, amplitude * 0.8, amplitude * 0.6);
    
    return vec4(ToLinearRgb(color), 1.0);
}
```

### 条件分岐の最適化
```wgsl
@fragment
fn fs_main(in: VertexOutput) -> @location(0) vec4<f32> {
    let uv = NormalizedCoords(in.position.xy);
    
    // 条件分岐を減らすためのテクニック
    let freq_index = u32((uv.x + 1.0) * 0.5 * 2048.0);
    let amplitude = SpectrumAmplitude(freq_index);
    
    // step関数を使用してif文を避ける
    let is_high = step(0.5, amplitude);
    let color = mix(
        vec3(amplitude, 0.0, 0.0),        // 低振幅時の色
        vec3(0.0, amplitude, 0.0),        // 高振幅時の色
        is_high
    );
    
    return vec4(ToLinearRgb(color), 1.0);
}
```

---

## 11. デバッグとトラブルシューティング

### よくある問題と解決方法

#### 1. 音響が反応しない
- **原因**: 音響入力が正しく設定されていない
- **解決方法**: システムの音響設定を確認し、適切な入力デバイスを選択

#### 2. 振幅値が小さすぎる
- **原因**: 音響レベルが低い、または正規化が不適切
- **解決方法**: 振幅値を適切にスケーリングする

```wgsl
let scaled_amplitude = amplitude * 5.0;  // 5倍にスケール
```

#### 3. 色が暗すぎる
- **原因**: 振幅値が小さい、または色の計算が不適切
- **解決方法**: 色の明度を調整する

```wgsl
let brightened_color = pow(color, vec3(0.8));  // ガンマ補正
```

#### 4. 周波数インデックスが無効
- **原因**: インデックスが範囲外（0-2047）
- **解決方法**: インデックスを適切な範囲に制限する

```wgsl
let safe_index = clamp(freq_index, 0u, 2047u);
```

### デバッグのコツ
1. **段階的な実装**: 単純な振幅表示から始める
2. **視覚的な確認**: 振幅値を色として表示してデバッグ
3. **範囲の確認**: 周波数インデックスと振幅値の範囲を確認

---

## 12. 学習のポイント

### 重要な概念
- **スペクトラム解析**: FFTによる周波数成分の抽出
- **リアルタイム処理**: 音響信号の即座な視覚化
- **周波数マッピング**: 周波数を色や形状に変換する技術
- **振幅の活用**: 音の大きさを視覚的な強度に変換

### 実践のコツ
1. **音響の理解**: 周波数帯域の特性を理解する
2. **色彩理論**: 効果的な色の組み合わせを学ぶ
3. **パフォーマンス**: リアルタイム処理を意識したコード作成
4. **創造性**: 音楽と視覚の調和を追求する

---

## 次のステップ

Chapter 5を完了したら、以下を確認してください：
- [ ] `SpectrumAmplitude()`の使用方法を理解している
- [ ] 周波数帯域の特性を把握している
- [ ] 音響リアクティブなパターンを作成できる
- [ ] 色の周波数マッピングを実装できる
- [ ] パフォーマンスを考慮した最適化ができる

次章では、MIDI機器との連携によるリアルタイム制御について学習します。

---

## サンプルプロジェクト

本章には以下のサンプルプロジェクトが含まれています：

- `examples/01-basic-spectrum/`: 基本的なスペクトラム表示
- `examples/02-frequency-bars/`: 周波数バーの可視化
- `examples/03-audio-reactive-colors/`: 音響リアクティブな色変化

## 演習課題

- `exercises/exercise-01.md`: 音響駆動幾何学パターン
- `exercises/exercise-02.md`: 音響ランドスケープジェネレーター

各演習の解答例は`solutions/`フォルダにあります。