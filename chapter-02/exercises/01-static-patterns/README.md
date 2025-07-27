# 演習課題 1: 静止パターンの作成

## 目標
時間要素なしの静的な波動パターンを作成し、Chapter 2「時間とアニメーション」の基礎となる静止状態を作る。

## このステップで作成するもの
同心円と放射線が組み合わさった静的なパターン（時間による変化なし）

## 学習内容

### 1. 静的な波動パターンの基礎
時間要素を使わない静的な数学的パターンの作成：
```wgsl
let circle_pattern = sin(distance * frequency);
let radial_pattern = sin(angle * frequency);
```

### 2. 極座標系での基本パターン
- **`length(uv)`**: 中心からの距離
- **`atan2(uv.y, uv.x)`**: 中心からの角度
- **同心円**: 距離による周期的パターン
- **放射線**: 角度による周期的パターン

### 3. 実装のポイント

#### 基本構造
```wgsl
@fragment
fn fs_main(in: VertexOutput) -> @location(0) vec4<f32> {
    let uv = NormalizedCoords(in.position.xy);
    let distance = length(uv);
    let angle = atan2(uv.y, uv.x);
    
    // 静的パターンの作成（時間要素なし）
    let circle_pattern = sin(distance * 8.0);
    let radial_pattern = sin(angle * 6.0);
    let combined = circle_pattern * 0.7 + radial_pattern * 0.3;
    
    // 色の生成
    let intensity = (combined + 1.0) * 0.5;
    let attenuation = 1.0 - distance * 0.6;
    let final_intensity = intensity * attenuation;
    
    return vec4(ToLinearRgb(color), 1.0);
}
```

#### 重要なポイント
- **時間要素を使用しない**: `Time.duration` は一切使わない
- **静的なパターン**: 表示される画像は完全に静止
- **次ステップの準備**: この静的パターンに時間要素を追加していく

## 実験してみよう

### パラメータの調整
現在のコードの数値を変更して、効果を観察してみてください：

1. **同心円の密度を変える**
   ```wgsl
   let circle_pattern = sin(distance * 4.0);  // 粗い円
   let circle_pattern = sin(distance * 16.0); // 細かい円
   ```

2. **放射線の本数を変える**
   ```wgsl
   let radial_pattern = sin(angle * 3.0);  // 3本の線
   let radial_pattern = sin(angle * 12.0); // 12本の線
   ```

3. **パターンの組み合わせ比率を変える**
   ```wgsl
   let combined = circle_pattern * 0.9 + radial_pattern * 0.1; // 同心円重視
   let combined = circle_pattern * 0.2 + radial_pattern * 0.8; // 放射線重視
   ```

### 発展課題

#### 課題1-1: 異なる周波数の組み合わせ
複数の異なる周波数を組み合わせてみてください：
```wgsl
let circle1 = sin(distance * 6.0);
let circle2 = sin(distance * 12.0);
let combined_circles = (circle1 + circle2) * 0.5;
```

#### 課題1-2: 位相のずれ
sinとcosを組み合わせて位相をずらしてみてください：
```wgsl
let pattern1 = sin(distance * 8.0);
let pattern2 = cos(distance * 8.0);
let combined = pattern1 * 0.5 + pattern2 * 0.5;
```

#### 課題1-3: 非対称パターン
x軸とy軸で異なる効果を持つパターンを作成してみてください：
```wgsl
let x_pattern = sin(uv.x * 10.0);
let y_pattern = sin(uv.y * 8.0);
let asymmetric = x_pattern * y_pattern;
```

## 次のステップへ
静的なパターンが作成できたら、次のステップ「02-time-animation」でこのパターンに基本的な時間アニメーションを追加していきましょう。

## 学習のポイント
1. **静的パターンの理解**: 時間要素なしでの波動パターン作成
2. **極座標系の活用**: 距離と角度による数学的パターン
3. **パターン合成**: 複数の波動の組み合わせ技術
4. **時間への準備**: 次ステップで時間要素を追加する基盤作り
5. **Chapter 2のテーマ**: 「時間とアニメーション」の出発点