# Chapter 2: Time and Animation
## 時間とアニメーション

### 本章の目標
- 時間を使ったアニメーションの基本概念を理解する
- `Time.duration`の使い方を習得する
- sin/cos三角関数を使った周期的な変化を作成する
- 色の遷移やグラデーション効果を理解する
- 複数の要素を組み合わせた複合アニメーションを作成する

---

## 1. 時間とアニメーションの基本概念

### シェーダーアニメーションとは
**シェーダーアニメーション**は、時間を変数として使用し、フレームごとに異なる映像を生成する技術です。従来の画像処理とは異なり、時間軸を持つことで動的で生き生きとした表現が可能になります。

### アニメーションの基本要素
1. **時間軸**: 経過時間を基準とした変化
2. **周期性**: 規則的な繰り返しパターン
3. **連続性**: 滑らかな変化の継続
4. **数学的制御**: 関数による変化の制御

### リアルタイムアニメーションの特徴
- **フレーム独立性**: 各フレームが独立して計算される
- **決定論的**: 同じ時間なら同じ結果
- **高性能**: GPUによる並列計算
- **インタラクティブ**: リアルタイム制御が可能

---

## 2. Time.duration - 時間の取得

### Time.duration の概要
`Time.duration`は、shekereフレームワークが提供する**時間取得関数**です。アプリケーション開始からの経過時間を秒単位で取得できます。

### 基本的な使用方法
```wgsl
let time = Time.duration;  // 経過時間を取得（秒単位）
```

### 時間の特性
- **データ型**: `f32`（32bit浮動小数点数）
- **開始値**: 0.0（アプリケーション開始時）
- **増加**: 毎フレーム増加し続ける
- **精度**: 高精度な時間測定

### 実践例: 基本的な時間アニメーション
```wgsl
@fragment
fn fs_main(in: VertexOutput) -> @location(0) vec4<f32> {
    let time = Time.duration;
    
    // 時間に応じて赤成分を変化させる
    let red = time * 0.1;  // ゆっくりと赤くなる
    let color = vec3(red, 0.0, 0.0);
    
    return vec4(ToLinearRgb(color), 1.0);
}
```

### 時間の制御テクニック

#### 1. 時間のスケーリング
```wgsl
let slow_time = Time.duration * 0.5;    // 半分の速度
let fast_time = Time.duration * 2.0;    // 2倍の速度
```

#### 2. 時間の範囲制限
```wgsl
let clamped_time = clamp(Time.duration, 0.0, 10.0);  // 0〜10秒に制限
```

#### 3. 時間の周期化
```wgsl
let cyclic_time = fract(Time.duration);  // 0〜1の範囲で繰り返し
```

---

## 3. sin/cos三角関数 - 周期的な変化

### 三角関数の基本
**sin（サイン）**と**cos（コサイン）**は、周期的な変化を作り出すための基本的な数学関数です。

### sin/cos関数の特性
- **周期**: 2π（約6.28）で1回転
- **振幅**: -1.0 〜 1.0の範囲
- **位相差**: sinとcosは90度（π/2）ずれている
- **連続性**: 滑らかな曲線変化

### 基本的な使用方法
```wgsl
let time = Time.duration;
let sin_value = sin(time);  // -1.0 〜 1.0 で振動
let cos_value = cos(time);  // sinより90度位相が進んでいる
```

### 三角関数の応用テクニック

#### 1. 振幅の調整
```wgsl
// 0.0 〜 1.0 の範囲に変換
let positive_sin = (sin(time) + 1.0) * 0.5;

// 任意の振幅に調整
let amplitude = 0.8;
let scaled_sin = sin(time) * amplitude;
```

#### 2. 周期の制御
```wgsl
// 周期を2倍にする（ゆっくりと）
let slow_sin = sin(time * 0.5);

// 周期を半分にする（速く）
let fast_sin = sin(time * 2.0);
```

#### 3. 位相の調整
```wgsl
// 位相をずらす
let phase_shift = 1.0;
let shifted_sin = sin(time + phase_shift);
```

### 実践例: 色の周期的変化
```wgsl
@fragment
fn fs_main(in: VertexOutput) -> @location(0) vec4<f32> {
    let time = Time.duration;
    
    // 各色成分を異なる周期で変化
    let red = (sin(time) + 1.0) * 0.5;           // 基本周期
    let green = (sin(time * 1.5) + 1.0) * 0.5;   // 1.5倍の周期
    let blue = (cos(time * 2.0) + 1.0) * 0.5;    // 2倍の周期、cosを使用
    
    let color = vec3(red, green, blue);
    return vec4(ToLinearRgb(color), 1.0);
}
```

---

## 4. 色の遷移とグラデーション

### 色の遷移の基本
**色の遷移**は、時間経過に伴って色を滑らかに変化させる技術です。単純な色変化から複雑なグラデーション効果まで様々な表現が可能です。

### 基本的な色遷移
```wgsl
// 2色間の線形遷移
let color1 = vec3(1.0, 0.0, 0.0);  // 赤
let color2 = vec3(0.0, 0.0, 1.0);  // 青
let t = (sin(Time.duration) + 1.0) * 0.5;  // 0〜1の範囲
let mixed_color = mix(color1, color2, t);
```

### mix関数の活用
`mix()`関数は、2つの値を線形補間する関数です：
- `mix(a, b, t)`: a * (1-t) + b * t
- `t = 0.0`: 完全にa
- `t = 1.0`: 完全にb
- `t = 0.5`: aとbの中間

### 複数色の遷移
```wgsl
fn get_rainbow_color(t: f32) -> vec3<f32> {
    let normalized_t = fract(t);  // 0〜1の範囲に正規化
    
    if (normalized_t < 0.33) {
        // 赤 → 緑
        let local_t = normalized_t * 3.0;
        return mix(vec3(1.0, 0.0, 0.0), vec3(0.0, 1.0, 0.0), local_t);
    } else if (normalized_t < 0.66) {
        // 緑 → 青
        let local_t = (normalized_t - 0.33) * 3.0;
        return mix(vec3(0.0, 1.0, 0.0), vec3(0.0, 0.0, 1.0), local_t);
    } else {
        // 青 → 赤
        let local_t = (normalized_t - 0.66) * 3.0;
        return mix(vec3(0.0, 0.0, 1.0), vec3(1.0, 0.0, 0.0), local_t);
    }
}
```

### 位置による色の変化
```wgsl
@fragment
fn fs_main(in: VertexOutput) -> @location(0) vec4<f32> {
    let uv = NormalizedCoords(in.position.xy);
    let time = Time.duration;
    
    // 位置と時間を組み合わせた色変化
    let color_factor = length(uv) + time * 0.1;
    let color = get_rainbow_color(color_factor);
    
    return vec4(ToLinearRgb(color), 1.0);
}
```

---

## 5. 実践例解説

### 例1: 基本的な時間アニメーション
画面全体の色が時間経過とともに変化する最もシンプルなアニメーション。

```wgsl
@fragment
fn fs_main(in: VertexOutput) -> @location(0) vec4<f32> {
    let time = Time.duration;
    
    // 時間に応じて色を変化させる
    let intensity = (sin(time) + 1.0) * 0.5;  // 0〜1の範囲
    let color = vec3(intensity, intensity * 0.5, 1.0 - intensity);
    
    return vec4(ToLinearRgb(color), 1.0);
}
```

### 例2: sin/cos三角関数アニメーション
三角関数を使った周期的な変化で、より複雑なパターンを作成。

```wgsl
@fragment
fn fs_main(in: VertexOutput) -> @location(0) vec4<f32> {
    let uv = NormalizedCoords(in.position.xy);
    let time = Time.duration;
    
    // UV座標と時間を組み合わせた波動パターン
    let wave = sin(uv.x * 5.0 + time * 2.0) * cos(uv.y * 3.0 + time * 1.5);
    let intensity = (wave + 1.0) * 0.5;  // 0〜1の範囲に変換
    
    let color = vec3(intensity, intensity * 0.8, intensity * 0.6);
    return vec4(ToLinearRgb(color), 1.0);
}
```

### 例3: 色の遷移アニメーション
複数の色を滑らかに遷移させる効果。

```wgsl
@fragment
fn fs_main(in: VertexOutput) -> @location(0) vec4<f32> {
    let uv = NormalizedCoords(in.position.xy);
    let time = Time.duration;
    
    // 中心からの距離に基づく色遷移
    let distance = length(uv);
    let color_cycle = distance + time * 0.3;
    
    // 虹色の循環
    let hue = fract(color_cycle) * 6.28;  // 0〜2πの範囲
    let red = (sin(hue) + 1.0) * 0.5;
    let green = (sin(hue + 2.09) + 1.0) * 0.5;  // 120度位相差
    let blue = (sin(hue + 4.19) + 1.0) * 0.5;   // 240度位相差
    
    let color = vec3(red, green, blue);
    return vec4(ToLinearRgb(color), 1.0);
}
```

### 例4: 複合アニメーション
複数の要素を組み合わせた複雑なアニメーション。

```wgsl
@fragment
fn fs_main(in: VertexOutput) -> @location(0) vec4<f32> {
    let uv = NormalizedCoords(in.position.xy);
    let time = Time.duration;
    
    // 複数の波動の合成
    let wave1 = sin(uv.x * 4.0 + time * 1.5);
    let wave2 = cos(uv.y * 6.0 + time * 2.0);
    let wave3 = sin(length(uv) * 8.0 - time * 3.0);
    
    let combined_wave = (wave1 + wave2 + wave3) / 3.0;
    let intensity = (combined_wave + 1.0) * 0.5;
    
    // 時間による色相の変化
    let hue_shift = time * 0.5;
    let red = (sin(intensity * 6.28 + hue_shift) + 1.0) * 0.5;
    let green = (sin(intensity * 6.28 + hue_shift + 2.09) + 1.0) * 0.5;
    let blue = (sin(intensity * 6.28 + hue_shift + 4.19) + 1.0) * 0.5;
    
    let color = vec3(red, green, blue);
    return vec4(ToLinearRgb(color), 1.0);
}
```

---

## 6. 学習のポイント

### アニメーションデザインのコツ
1. **段階的な構築**: 単純な要素から複雑なものへ
2. **周期の調整**: 見やすい速度での変化
3. **色の調和**: 美しい色の組み合わせ
4. **パフォーマンス**: 複雑すぎない計算

### デバッグテクニック
1. **時間の可視化**: `Time.duration`を色として表示
2. **関数の確認**: `sin()`や`cos()`の値を色で確認
3. **段階的テスト**: 一つずつ要素を追加してテスト
4. **パラメータ調整**: 数値を変えて効果を確認

### よくある問題と解決方法
1. **値の範囲**: sin/cosは-1〜1、色は0〜1の範囲
2. **速度調整**: 時間係数を調整して適切な速度に
3. **色の鮮やかさ**: 振幅と位相を調整して理想的な色に
4. **滑らかさ**: 急激な変化を避けて連続性を保つ

---

## 7. 数学的補足

### 三角関数の性質
- `sin(0) = 0`, `sin(π/2) = 1`, `sin(π) = 0`, `sin(3π/2) = -1`
- `cos(0) = 1`, `cos(π/2) = 0`, `cos(π) = -1`, `cos(3π/2) = 0`
- `sin(x + π/2) = cos(x)` (位相差)
- `sin²(x) + cos²(x) = 1` (三角関数の基本関係)

### 周期とアニメーション
- **周期**: 2π秒で1回転
- **周波数**: 1秒間の回転数
- **振幅**: 最大値と最小値の差の半分
- **位相**: 波形の開始点のずれ

---

## 8. 学習達成目標

Chapter 2を完了したら、以下を確認してください：
- [ ] Time.durationの使用方法を理解している
- [ ] sin/cos関数による周期的変化を作成できる
- [ ] 色の遷移アニメーションを実装できる
- [ ] 複数の要素を組み合わせた複合アニメーションを作成できる
- [ ] 段階的な作品制作を通して1つの完成作品を作れる

---

## 9. サンプルプロジェクト

本章には以下のサンプルプロジェクトが含まれています：

- `examples/01-basic-time/`: 基本的な時間アニメーション
- `examples/02-sin-cos-animation/`: sin/cos三角関数アニメーション
- `examples/03-color-transition/`: 色の遷移アニメーション
- `examples/04-complex-animation/`: 複合アニメーション

## 💡 段階的演習課題

**作品目標**: 複合螺旋パターン作品

以下の4つの演習を段階的に進めることで、1つの美しい螺旋アニメーション作品を完成させます。各ステップでは前のステップのコードを修正・拡張して進めます：

### [演習1: 静止パターンの作成](./exercises/01-static-patterns/)
**基礎作り**: 時間要素なしの基本波動パターンを作成
- 極座標系での基本パターン（同心円・放射線）
- 静的な数学的パターンの理解
- 次ステップでの時間追加の準備

### [演習2: 基本時間アニメーション](./exercises/02-time-animation/)
**動きの追加**: 前ステップの静止パターンに時間要素を追加
- 前ステップのコードを基礎として使用
- `Time.duration`による基本的な時間変化
- sin/cos関数による周期的アニメーション

### [演習3: 複雑時間効果](./exercises/03-complex-time-effects/)
**高度化**: 単純な時間効果を複雑な効果に発展
- 前ステップのアニメーションを基礎として使用
- 複数の時間効果の組み合わせ
- 同心円・放射線・螺旋の統合

### [演習4: 最終螺旋作品](./exercises/04-final-spiral-artwork/)
**完成**: 高度な技術で螺旋作品を完成
- 前ステップの複雑効果を基礎として使用
- 美しい色相回転システムの実装
- 最終的な複合螺旋パターンの完成