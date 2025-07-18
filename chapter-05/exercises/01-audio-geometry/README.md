# 演習課題 1: 音響駆動幾何学パターン

## 目標
音響データを使用して、幾何学的な図形の変形やアニメーションを制御できるようになる。スペクトラム表示ではなく、音楽によって動的に変化する図形を作成する。

## 課題内容
音響信号の周波数帯域を使って、幾何学図形のパラメータ（サイズ、回転、位置、形状など）を制御する効果を作成してください。

### 1-1. 音響反応円の作成
以下の効果を順番に作成し、音響による図形制御を理解してください：

1. **基本的な音響反応円**
   - 画面中央に円を描画
   - 低音域の振幅で円のサイズを制御
   - 音が大きいほど円が大きくなる効果

2. **周波数別色分け円**
   - 低音域：赤い円
   - 中音域：緑の円
   - 高音域：青い円
   - 各帯域の振幅でそれぞれの円のサイズを制御

3. **回転する円**
   - 中音域の振幅で回転速度を制御
   - 高音域の振幅で円の輪郭の太さを制御

### 1-2. 多角形の音響制御
以下の効果を作成してください：

1. **動的多角形**
   - 低音域の振幅で多角形の頂点数を制御（3角形〜8角形）
   - 中音域の振幅でサイズを制御
   - 高音域の振幅で回転速度を制御

2. **複数多角形の配置**
   - 画面上に3つの多角形を配置
   - それぞれ異なる周波数帯域で制御
   - 互いに異なる回転方向とサイズ変化

3. **音響同期パルス**
   - 強い音の瞬間に多角形が一瞬拡大する効果
   - ビートやドラムに反応するパルス効果

### 1-3. 創作課題
以下の中から1つ選んで実装してください：

1. **音響反応星座**
   - 複数の点を配置し、音響で明度や位置を制御
   - 星座のような美しいパターンを作成

2. **音響波紋効果**
   - 中心から外に向かって広がる同心円
   - 音響で波紋の速度と間隔を制御

3. **音響万華鏡**
   - 対称的なパターンを複数配置
   - 音響で対称軸の数や回転を制御

## 実装の手引き

### 基本的な円の描画
```wgsl
// 1-1-1. 基本的な音響反応円
@fragment
fn fs_main(in: VertexOutput) -> @location(0) vec4<f32> {
    let uv = NormalizedCoords(in.position.xy);
    
    // 低音域の平均振幅を計算
    let bass_amplitude = getBandAmplitude(0u, Spectrum.num_points / 4u);
    
    // 中心からの距離
    let distance = length(uv);
    
    // 音響に応じた円のサイズ（0.1〜0.8の範囲）
    let circle_radius = 0.1 + bass_amplitude * 0.7;
    
    // 円の内外判定
    let is_inside = distance < circle_radius;
    
    // 色の設定
    let color = vec3(
        is_inside ? 1.0 : 0.0,
        is_inside ? 0.2 : 0.0,
        is_inside ? 0.2 : 0.0
    );
    
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

### 多角形の描画
```wgsl
// 1-2-1. 動的多角形
@fragment
fn fs_main(in: VertexOutput) -> @location(0) vec4<f32> {
    let uv = NormalizedCoords(in.position.xy);
    
    // 各周波数帯域の振幅
    let bass = getBandAmplitude(0u, Spectrum.num_points / 3u);
    let mid = getBandAmplitude(Spectrum.num_points / 3u, (Spectrum.num_points * 2u) / 3u);
    let treble = getBandAmplitude((Spectrum.num_points * 2u) / 3u, Spectrum.num_points);
    
    // 多角形のパラメータ
    let sides = 3.0 + bass * 5.0;  // 3〜8角形
    let radius = 0.2 + mid * 0.4;  // サイズ
    let rotation = treble * Time.duration * 2.0;  // 回転速度
    
    // 中心からの距離と角度
    let distance = length(uv);
    let angle = atan2(uv.y, uv.x) + rotation;
    
    // 多角形の判定
    let polygon_angle = (floor(angle / (6.28318 / sides)) + 0.5) * (6.28318 / sides);
    let polygon_radius = radius / cos(3.14159 / sides);
    let polygon_distance = polygon_radius * cos(angle - polygon_angle);
    
    let is_inside = distance < polygon_distance;
    
    // 色の設定
    let color = vec3(
        is_inside ? bass : 0.0,
        is_inside ? mid : 0.0,
        is_inside ? treble : 0.0
    );
    
    return vec4(ToLinearRgb(color), 1.0);
}
```

## 学習のポイント
- **幾何学的変換**: 音響データを図形パラメータにマッピングする方法
- **視覚的バランス**: 複数の図形要素の調和のとれた配置
- **時間的変化**: 音楽の時間的変化と図形アニメーションの同期
- **数学的理解**: 三角関数や距離計算を使った図形描画
- **創造的応用**: 基本的な図形から複雑なパターンを構築する思考

## 動作確認のコツ
- **多様な音楽**: 異なるジャンルの音楽で図形の反応を確認
- **パラメータ調整**: 音響感度や図形サイズを調整して最適な表示を追求
- **リアルタイム調整**: Hot Reload機能を活用して即座に変更を確認
- **視覚的印象**: 音楽を聞きながら図形の動きが音楽的に感じられるかチェック

## 発展的な学習
この演習で学んだ技術は以下に応用できます：
- より複雑な図形（花びら型、星型など）の作成
- 3D風の遠近効果を持つ図形
- 複数レイヤーの図形の重ね合わせ
- 音響による図形の変形（伸縮、歪み効果）