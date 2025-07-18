# 演習課題 2: 音響ランドスケープジェネレーター

## 目標
音響データを使用して、地形や風景のような空間的な視覚効果を作成できるようになる。2Dシェーダーで3D的な深度や高さを表現し、音楽によって動的に変化する「音響地形」を構築する。

## 課題内容
音響信号を地形の高さ、形状、質感にマッピングして、音楽に反応する美しいランドスケープを作成してください。

### 2-1. 基本的な音響地形
以下の効果を順番に作成し、音響による空間表現を理解してください：

1. **音響マウンテン**
   - Y座標を高さ、X座標を水平位置として地形を表現
   - 低音域の振幅で「山」の高さを制御
   - 音が大きいほど山が高くなる地形プロファイル

2. **周波数別地形レイヤー**
   - 低音域：基底の地面レベル
   - 中音域：丘や中間の地形
   - 高音域：山頂や尖った地形
   - 各帯域で異なる高さレベルを制御

3. **動的地形変化**
   - 時間と音響データの組み合わせで地形が変化
   - 音楽のビートに合わせて地形が「成長」「侵食」する効果

### 2-2. 音響水面・空間効果
以下の効果を作成してください：

1. **音響波水面**
   - 画面下部に「水面」を表現
   - 音響データで波の高さと周期を制御
   - 地形との境界で反射効果を表現

2. **音響雲・大気効果**
   - 画面上部に「雲」や「霞」を表現
   - 高音域で雲の動きと密度を制御
   - 地形の高さに応じて雲の表示を変化

3. **音響グラデーション**
   - 高度に応じた色のグラデーション
   - 音響データで色の遷移点を制御
   - 時間帯（朝/昼/夕/夜）の表現

### 2-3. 創作課題
以下の中から1つ選んで実装してください：

1. **音響都市スカイライン**
   - 周波数帯域ごとに「ビル」の高さを制御
   - 都市のスカイラインを音楽で動的に変化
   - 夜景やライトアップ効果を追加

2. **音響火山・溶岩効果**
   - 低音域で「火山活動」を表現
   - 溶岩の流れや火山の爆発を音響で制御
   - 熱による大気の歪み効果

3. **音響海洋・波効果**
   - 複数の波が重なり合う海洋表現
   - 音響で波の振幅、周期、方向を制御
   - 海底から水面までの深度表現

## 実装の手引き

### 基本的な地形生成
```wgsl
// 2-1-1. 音響マウンテン
@fragment
fn fs_main(in: VertexOutput) -> @location(0) vec4<f32> {
    let uv = NormalizedCoords(in.position.xy);
    
    // 低音域の振幅を取得
    let bass_amplitude = getBandAmplitude(0u, Spectrum.num_points / 4u);
    
    // X座標に基づく基本地形（山の形状）
    let mountain_shape = 1.0 - abs(uv.x * 0.8);  // 三角形の山
    
    // 音響による高さ調整
    let terrain_height = mountain_shape * (0.3 + bass_amplitude * 0.7);
    
    // 現在のY座標と地形の高さを比較
    let normalized_y = (uv.y + 1.0) * 0.5;  // 0.0(下) ~ 1.0(上)
    let is_above_terrain = normalized_y > (0.5 - terrain_height * 0.5);
    
    // 地形部分と空部分の色分け
    let terrain_color = vec3(0.4, 0.2, 0.1);  // 茶色の地面
    let sky_color = vec3(0.2, 0.4, 0.8);      // 青い空
    
    let color = is_above_terrain ? sky_color : terrain_color;
    
    return vec4(ToLinearRgb(color), 1.0);
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

### 多層地形システム
```wgsl
// 2-1-2. 周波数別地形レイヤー
@fragment
fn fs_main(in: VertexOutput) -> @location(0) vec4<f32> {
    let uv = NormalizedCoords(in.position.xy);
    let time = Time.duration;
    
    // 各周波数帯域の振幅
    let bass = getBandAmplitude(0u, Spectrum.num_points / 3u);
    let mid = getBandAmplitude(Spectrum.num_points / 3u, (Spectrum.num_points * 2u) / 3u);
    let treble = getBandAmplitude((Spectrum.num_points * 2u) / 3u, Spectrum.num_points);
    
    // 複数の地形レイヤーを生成
    let base_terrain = sin(uv.x * 2.0 + time * 0.5) * 0.1;
    let mid_terrain = sin(uv.x * 5.0 + time * 1.0) * 0.2 * mid;
    let peak_terrain = sin(uv.x * 10.0 + time * 2.0) * 0.15 * treble;
    
    // 地形の合成
    let total_height = 0.2 + bass * 0.4 + base_terrain + mid_terrain + peak_terrain;
    
    // Y座標の正規化
    let normalized_y = (uv.y + 1.0) * 0.5;
    
    // 高度による色の決定
    var color = vec3(0.0);
    
    if (normalized_y < total_height) {
        // 地形部分 - 高度に応じた色分け
        let height_ratio = normalized_y / total_height;
        
        if (height_ratio < 0.3) {
            // 低地 - 深い緑
            color = mix(vec3(0.1, 0.3, 0.1), vec3(0.2, 0.5, 0.2), height_ratio / 0.3);
        } else if (height_ratio < 0.7) {
            // 中間地 - 茶色
            color = mix(vec3(0.2, 0.5, 0.2), vec3(0.6, 0.4, 0.2), (height_ratio - 0.3) / 0.4);
        } else {
            // 高地 - 白（雪）
            color = mix(vec3(0.6, 0.4, 0.2), vec3(0.9, 0.9, 0.9), (height_ratio - 0.7) / 0.3);
        }
        
        // 音響による色の強調
        color = color * (0.7 + bass * 0.3);
    } else {
        // 空部分 - グラデーション
        let sky_gradient = 1.0 - (normalized_y - total_height) / (1.0 - total_height);
        color = mix(vec3(0.4, 0.6, 1.0), vec3(0.1, 0.2, 0.5), sky_gradient);
        
        // 高音域による「雲」効果
        let cloud_noise = sin(uv.x * 15.0 + time * 3.0) * sin(uv.y * 10.0 + time * 2.0);
        if (cloud_noise > 0.5 && treble > 0.3) {
            color = mix(color, vec3(1.0, 1.0, 1.0), treble * 0.5);
        }
    }
    
    return vec4(ToLinearRgb(color), 1.0);
}
```

### 水面効果
```wgsl
// 2-2-1. 音響波水面
@fragment
fn fs_main(in: VertexOutput) -> @location(0) vec4<f32> {
    let uv = NormalizedCoords(in.position.xy);
    let time = Time.duration;
    
    // 音響データ取得
    let bass = getBandAmplitude(0u, Spectrum.num_points / 4u);
    let mid = getBandAmplitude(Spectrum.num_points / 4u, Spectrum.num_points / 2u);
    
    // 水面の波を計算
    let wave1 = sin(uv.x * 8.0 + time * 4.0) * 0.05 * bass;
    let wave2 = sin(uv.x * 12.0 - time * 3.0) * 0.03 * mid;
    let wave3 = sin(uv.x * 16.0 + time * 6.0) * 0.02 * bass;
    
    let water_surface = -0.3 + wave1 + wave2 + wave3;
    
    // 地形（簡単な山）
    let terrain_height = 0.2 * (1.0 - abs(uv.x * 0.7)) + bass * 0.3;
    
    var color = vec3(0.0);
    
    if (uv.y < water_surface) {
        // 水面下 - 水の色
        let depth = water_surface - uv.y;
        let water_color = vec3(0.0, 0.3, 0.6);
        let depth_factor = clamp(1.0 - depth * 2.0, 0.3, 1.0);
        color = water_color * depth_factor;
        
        // 波による光の屈折効果
        let wave_distortion = sin(uv.x * 20.0 + time * 8.0) * 0.1 * mid;
        color = color * (1.0 + wave_distortion);
        
    } else if (uv.y < terrain_height) {
        // 地形部分
        color = vec3(0.4, 0.3, 0.2);
        
    } else {
        // 空部分
        color = vec3(0.3, 0.5, 0.9);
    }
    
    return vec4(ToLinearRgb(color), 1.0);
}
```

## 学習のポイント
- **空間的マッピング**: 音響データを3D空間の概念（高さ、深さ、距離）にマッピング
- **レイヤー構造**: 複数の視覚効果レイヤーの組み合わせと制御
- **自然現象シミュレーション**: 現実の自然現象の視覚的特徴を音響データで表現
- **色彩設計**: 環境に応じた自然で美しい色の選択と調和
- **時空間変化**: 時間経過と音響変化の両方を考慮した動的表現

## 動作確認のコツ
- **環境の一貫性**: 地形、水、空などの要素が調和して見えるか確認
- **音響反応性**: 音楽の変化が地形の変化として自然に感じられるかチェック
- **視覚的深度**: 2Dシェーダーでも3D的な奥行きが感じられるか確認
- **パフォーマンス**: 複雑な計算でもスムーズに動作するか確認

## 発展的な学習
この演習で学んだ技術は以下に応用できます：
- より複雑な地形（峡谷、断崖、洞窟など）
- 気象効果（雨、雪、霧、雲の動き）
- 季節変化（春夏秋冬の色彩変化）
- 複数の光源による照明効果（太陽、月、人工光）
- 音響による物理シミュレーション（風、重力、流体）