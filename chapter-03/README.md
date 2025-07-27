# Chapter 3: Coordinates and Patterns
## 座標系とパターン

### 本章の目標
- UV座標系の理解と効果的な活用方法を習得する
- 距離関数`length()`を使った円形パターンを作成する
- 角度関数`atan2()`を使った放射状パターンを作成する
- 複数の数学関数を組み合わせた複雑なパターンを作成する
- 座標変換と数学的パターン生成の基礎を理解する

---

## 1. UV座標系の深い理解

### UV座標とは何か（復習）
**UV座標**は、2D画面上の位置を表現するための座標系です。Chapter 1で学んだ`NormalizedCoords()`関数は、画面座標をUV座標に変換します。

### 座標系の種類と特徴

#### 1. 正規化座標（NormalizedCoords）
```wgsl
let uv = NormalizedCoords(in.position.xy);
// 範囲: x = -1.0 〜 1.0, y = -1.0 〜 1.0
// 中心: (0.0, 0.0)
// 特徴: 画面の縦横比が自動調整される
```

#### 2. 標準テクスチャ座標
```wgsl
let uv = in.position.xy;
// 範囲: x = 0.0 〜 1.0, y = 0.0 〜 1.0
// 左上: (0.0, 0.0), 右下: (1.0, 1.0)
// 特徴: 画像処理でよく使用される
```

### 座標変換の基本テクニック

#### 1. 座標のスケーリング
```wgsl
let uv = NormalizedCoords(in.position.xy);
let scaled_uv = uv * 5.0;  // 5倍に拡大
```

#### 2. 座標の移動
```wgsl
let uv = NormalizedCoords(in.position.xy);
let offset_uv = uv + vec2(0.5, 0.0);  // 右に0.5移動
```

#### 3. 座標の回転
```wgsl
fn rotate_uv(uv: vec2<f32>, angle: f32) -> vec2<f32> {
    let cos_a = cos(angle);
    let sin_a = sin(angle);
    return vec2(
        uv.x * cos_a - uv.y * sin_a,
        uv.x * sin_a + uv.y * cos_a
    );
}
```

### 座標の対称性利用

#### 1. 絶対値による対称性
```wgsl
let uv = NormalizedCoords(in.position.xy);
let symmetric_uv = abs(uv);  // 4つの象限を同じパターンに
```

#### 2. fract関数による繰り返し
```wgsl
let uv = NormalizedCoords(in.position.xy);
let repeated_uv = fract(uv * 3.0);  // 3×3のタイル状に繰り返し
```

---

## 2. 距離関数 - 円形パターンの作成

### length()関数の基本
`length()`関数は、ベクトルの長さ（原点からの距離）を計算します。

```wgsl
let uv = NormalizedCoords(in.position.xy);
let distance = length(uv);  // 中心からの距離
```

### 距離の特性
- **中心**: distance = 0.0
- **画面端**: distance ≈ 1.0〜1.4（画面の縦横比による）
- **単調増加**: 中心から離れるほど値が大きくなる

### 基本的な円形パターン

#### 1. 同心円パターン
```wgsl
@fragment
fn fs_main(in: VertexOutput) -> @location(0) vec4<f32> {
    let uv = NormalizedCoords(in.position.xy);
    let distance = length(uv);
    
    // 距離を色の強度として使用
    let intensity = distance;
    let color = vec3(intensity, intensity, intensity);
    
    return vec4(ToLinearRgb(color), 1.0);
}
```

#### 2. 逆グラデーション
```wgsl
let intensity = 1.0 - distance;  // 中心が明るく、端が暗い
```

#### 3. 円形マスク
```wgsl
let mask = step(distance, 0.5);  // 半径0.5の円
let color = vec3(mask, mask, mask);
```

### 距離の加工テクニック

#### 1. 距離の周期化
```wgsl
let ring_pattern = fract(distance * 10.0);  // 10本の同心円
```

#### 2. 距離の非線形変換
```wgsl
let curved_distance = pow(distance, 2.0);  // 二次関数的変化
let sin_distance = sin(distance * 10.0);   // 波動的変化
```

#### 3. 複数中心の距離計算
```wgsl
let center1 = vec2(-0.5, 0.0);
let center2 = vec2(0.5, 0.0);
let distance1 = length(uv - center1);
let distance2 = length(uv - center2);
let combined = min(distance1, distance2);  // 最小値を使用
```

---

## 3. 角度関数 - 放射状パターンの作成

### atan2()関数の基本
`atan2(y, x)`関数は、点(x, y)の角度をラジアン単位で返します。

```wgsl
let uv = NormalizedCoords(in.position.xy);
let angle = atan2(uv.y, uv.x);  // -π 〜 π の範囲
```

### 角度の特性
- **右方向**: angle = 0.0
- **上方向**: angle = π/2
- **左方向**: angle = π または -π
- **下方向**: angle = -π/2

### 角度の正規化
```wgsl
// 0 〜 2π の範囲に変換
let normalized_angle = (atan2(uv.y, uv.x) + 3.14159) / (2.0 * 3.14159);

// 0 〜 1 の範囲に変換
let angle_01 = (atan2(uv.y, uv.x) + 3.14159) / (2.0 * 3.14159);
```

### 基本的な放射状パターン

#### 1. 角度による色分け
```wgsl
@fragment
fn fs_main(in: VertexOutput) -> @location(0) vec4<f32> {
    let uv = NormalizedCoords(in.position.xy);
    let angle = atan2(uv.y, uv.x);
    
    // 角度を色相として使用
    let hue = (angle + 3.14159) / (2.0 * 3.14159);
    let color = vec3(hue, 1.0, 1.0);  // HSV的な表現
    
    return vec4(ToLinearRgb(color), 1.0);
}
```

#### 2. 放射線パターン
```wgsl
let rays = fract(angle * 8.0 / (2.0 * 3.14159));  // 8本の放射線
let ray_intensity = step(rays, 0.5);
```

#### 3. 螺旋パターン
```wgsl
let distance = length(uv);
let angle = atan2(uv.y, uv.x);
let spiral = fract(angle * 2.0 / (2.0 * 3.14159) + distance * 5.0);
```

### 角度と距離の組み合わせ

#### 1. 極座標パターン
```wgsl
let distance = length(uv);
let angle = atan2(uv.y, uv.x);

// 極座標グリッド
let radial_grid = fract(distance * 10.0);
let angular_grid = fract(angle * 6.0 / (2.0 * 3.14159));
let grid_pattern = min(radial_grid, angular_grid);
```

#### 2. 花びらパターン
```wgsl
let distance = length(uv);
let angle = atan2(uv.y, uv.x);

// 花びら形状
let petal_count = 8.0;
let petal_angle = sin(angle * petal_count) * 0.5 + 0.5;
let flower = step(distance, petal_angle * 0.5);
```

---

## 4. 複合パターンの作成

### 複数の数学関数の組み合わせ

#### 1. 波動パターン
```wgsl
let uv = NormalizedCoords(in.position.xy);

// 水平と垂直の波動
let wave_x = sin(uv.x * 10.0);
let wave_y = cos(uv.y * 8.0);
let wave_pattern = wave_x * wave_y;
```

#### 2. 格子パターン
```wgsl
let uv = NormalizedCoords(in.position.xy);

// 格子の作成
let grid_size = 8.0;
let grid_uv = fract(uv * grid_size);
let grid_lines = step(grid_uv, vec2(0.1, 0.1));
let grid_pattern = max(grid_lines.x, grid_lines.y);
```

#### 3. ノイズライクパターン
```wgsl
fn pseudo_random(uv: vec2<f32>) -> f32 {
    return fract(sin(dot(uv, vec2(12.9898, 78.233))) * 43758.5453);
}

let uv = NormalizedCoords(in.position.xy);
let noise_uv = floor(uv * 20.0);
let noise_value = pseudo_random(noise_uv);
```

### 時間との組み合わせ

#### 1. 回転するパターン
```wgsl
let time = Time.duration;
let uv = NormalizedCoords(in.position.xy);

// 時間による回転
let rotated_uv = rotate_uv(uv, time * 0.5);
let distance = length(rotated_uv);
let pattern = fract(distance * 8.0);
```

#### 2. 脈動するパターン
```wgsl
let time = Time.duration;
let uv = NormalizedCoords(in.position.xy);

// 時間による脈動
let pulse = (sin(time * 2.0) + 1.0) * 0.5;
let distance = length(uv);
let pulsing_circle = step(distance, pulse * 0.5);
```

### 複合パターンの実例

#### 1. 万華鏡パターン
```wgsl
@fragment
fn fs_main(in: VertexOutput) -> @location(0) vec4<f32> {
    let uv = NormalizedCoords(in.position.xy);
    let time = Time.duration;
    
    // 回転
    let rotated_uv = rotate_uv(uv, time * 0.3);
    
    // 対称性
    let symmetric_uv = abs(rotated_uv);
    
    // 距離と角度
    let distance = length(symmetric_uv);
    let angle = atan2(symmetric_uv.y, symmetric_uv.x);
    
    // 複合パターン
    let pattern = sin(distance * 10.0) * cos(angle * 6.0);
    let intensity = (pattern + 1.0) * 0.5;
    
    // 色彩
    let hue = fract(intensity + time * 0.1);
    let color = vec3(
        (sin(hue * 6.28) + 1.0) * 0.5,
        (sin(hue * 6.28 + 2.09) + 1.0) * 0.5,
        (sin(hue * 6.28 + 4.19) + 1.0) * 0.5
    );
    
    return vec4(ToLinearRgb(color), 1.0);
}
```

---

## 5. 実践例解説

### 例1: UV座標可視化
座標系の理解を深めるための基本的な可視化。

```wgsl
@fragment
fn fs_main(in: VertexOutput) -> @location(0) vec4<f32> {
    let uv = NormalizedCoords(in.position.xy);
    
    // X座標を赤成分、Y座標を緑成分に
    let color = vec3(
        (uv.x + 1.0) * 0.5,  // -1〜1 を 0〜1 に変換
        (uv.y + 1.0) * 0.5,  // -1〜1 を 0〜1 に変換
        0.0
    );
    
    return vec4(ToLinearRgb(color), 1.0);
}
```

### 例2: 円形パターン
中心からの距離を使用した同心円パターン。

```wgsl
@fragment
fn fs_main(in: VertexOutput) -> @location(0) vec4<f32> {
    let uv = NormalizedCoords(in.position.xy);
    let distance = length(uv);
    
    // 同心円パターン
    let rings = fract(distance * 8.0);
    let intensity = smoothstep(0.0, 0.1, rings) * smoothstep(0.9, 0.8, rings);
    
    let color = vec3(intensity, intensity * 0.8, intensity * 0.6);
    return vec4(ToLinearRgb(color), 1.0);
}
```

### 例3: 放射状パターン
角度を使用した放射線パターン。

```wgsl
@fragment
fn fs_main(in: VertexOutput) -> @location(0) vec4<f32> {
    let uv = NormalizedCoords(in.position.xy);
    let angle = atan2(uv.y, uv.x);
    
    // 放射線パターン
    let ray_count = 12.0;
    let ray_angle = fract(angle * ray_count / (2.0 * 3.14159));
    let ray_intensity = smoothstep(0.0, 0.1, ray_angle) * smoothstep(1.0, 0.9, ray_angle);
    
    // 距離による減衰
    let distance = length(uv);
    let fade = 1.0 - smoothstep(0.0, 1.0, distance);
    
    let final_intensity = ray_intensity * fade;
    let color = vec3(final_intensity, final_intensity * 0.7, final_intensity * 0.4);
    
    return vec4(ToLinearRgb(color), 1.0);
}
```

### 例4: 複合パターン
複数の要素を組み合わせた複雑なパターン。

```wgsl
@fragment
fn fs_main(in: VertexOutput) -> @location(0) vec4<f32> {
    let uv = NormalizedCoords(in.position.xy);
    let time = Time.duration;
    
    // 回転する座標系
    let rotated_uv = rotate_uv(uv, time * 0.2);
    
    // 距離と角度
    let distance = length(rotated_uv);
    let angle = atan2(rotated_uv.y, rotated_uv.x);
    
    // 複合パターン
    let wave1 = sin(distance * 12.0 - time * 3.0);
    let wave2 = cos(angle * 8.0 + time * 2.0);
    let combined = wave1 * wave2;
    
    // 色の計算
    let intensity = (combined + 1.0) * 0.5;
    let hue = fract(intensity + time * 0.1);
    
    let color = vec3(
        (sin(hue * 6.28) + 1.0) * 0.5,
        (sin(hue * 6.28 + 2.09) + 1.0) * 0.5,
        (sin(hue * 6.28 + 4.19) + 1.0) * 0.5
    );
    
    return vec4(ToLinearRgb(color), 1.0);
}
```

---

## 6. 学習のポイント

### 数学的思考の重要性
1. **座標系の理解**: 各座標系の特性を理解する
2. **関数の性質**: 各数学関数の入力と出力の関係
3. **組み合わせ**: 複数の関数を組み合わせる創造性
4. **視覚化**: 数学的概念を視覚的に表現する能力

### デバッグテクニック
1. **単純化**: 複雑なパターンを単純な要素に分解
2. **可視化**: 中間結果を色として表示
3. **段階的構築**: 一つずつ要素を追加
4. **パラメータ調整**: 値を変えて効果を確認

### パフォーマンス考慮
1. **計算量**: 複雑な計算は避ける
2. **最適化**: 繰り返し計算を変数に保存
3. **精度**: 必要以上の精度は避ける
4. **分岐**: 条件分岐を最小限に抑える

---

## 7. 応用のヒント

### 創作のアプローチ
1. **観察**: 自然のパターンを観察する
2. **実験**: 異なる関数の組み合わせを試す
3. **反復**: 同じパターンを繰り返し配置
4. **変化**: 時間や位置による変化を加える

### 高度なテクニック
1. **フラクタル**: 自己相似パターンの作成
2. **ノイズ**: 自然らしいランダムパターン
3. **変形**: 座標系の非線形変換
4. **合成**: 複数のパターンの重ね合わせ

---

## 8. よくある間違いと解決方法

### 座標系の混同
```wgsl
// 間違い: 範囲を考慮しない
let uv = NormalizedCoords(in.position.xy);
let color = vec3(uv.x, uv.y, 0.0);  // 負の値で暗くなる

// 正しい: 範囲を0〜1に変換
let color = vec3((uv.x + 1.0) * 0.5, (uv.y + 1.0) * 0.5, 0.0);
```

### 角度の範囲
```wgsl
// 間違い: atan2の範囲を考慮しない
let angle = atan2(uv.y, uv.x);
let color = vec3(angle, angle, angle);  // 負の値で暗くなる

// 正しい: 0〜1の範囲に変換
let angle = (atan2(uv.y, uv.x) + 3.14159) / (2.0 * 3.14159);
```

### 距離の扱い
```wgsl
// 間違い: 距離の上限を考慮しない
let distance = length(uv);
let color = vec3(distance, distance, distance);  // 1.0を超える可能性

// 正しい: 適切な範囲に制限
let distance = min(length(uv), 1.0);
```

---

## 9. 学習達成目標

Chapter 3を完了したら、以下を確認してください：
- [ ] UV座標系の理解と活用ができる
- [ ] length()関数による円形パターンを作成できる
- [ ] atan2()関数による放射状パターンを作成できる
- [ ] 複数の数学関数を組み合わせた複雑なパターンを作成できる
- [ ] 座標変換の基本テクニックを理解している
- [ ] 段階的な作品制作を通して1つの完成作品を作れる

---

## 10. サンプルプロジェクト

本章には以下のサンプルプロジェクトが含まれています：

- `examples/01-uv-coordinates/`: UV座標可視化の例
- `examples/02-circular-patterns/`: 円形パターンの例
- `examples/03-radial-patterns/`: 放射状パターンの例
- `examples/04-complex-patterns/`: 複合パターンの例

## 💡 段階的演習課題

**作品目標**: 「花の生命力 - Flower of Life」

以下の4つの演習を段階的に進めることで、1つの美しい花の作品を完成させます。各ステップでは前のステップのコードを修正・拡張して進めます：

### [演習1: 基本的な座標変換](./exercises/01-basic-coordinate-transformations/)
**基礎作り**: 花びらの基本となる図形を作成
- 対称化による基本形状の作成
- スケーリングによる楕円形の花びらの種
- 座標変換の基礎技術を習得

### [演習2: 距離と角度によるパターン](./exercises/02-distance-and-angle-patterns/)
**花びら形状**: 前ステップの基本図形を花びらに発展
- 前ステップのコードを基礎として使用
- 距離・角度関数による花びらの形状作成
- 滑らかなエッジ処理の追加

### [演習3: 多層花びらパターン](./exercises/03-multi-layer-petals/)
**複雑化**: 単層花びらを多層構造に発展
- 前ステップの花びら形状を関数化
- 複数レイヤー（8枚、12枚、16枚）の実装
- 回転アニメーションと成長効果の追加

### [演習4: 最終作品「花の生命力」](./exercises/04-final-flower-artwork/)
**完成**: 高度な技術で作品を完成
- 前ステップの多層構造を基礎として使用
- HSV色空間による美しい色彩システム
- 背景パターンと最終的な仕上げ