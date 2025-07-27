# 演習 2: 距離と角度によるパターン

## 目標
距離関数と角度関数を使って、花びらの基本的な形状とパターンを作成する。

## 学習内容
- **距離関数**: `length()`を使った円形パターン
- **角度関数**: `atan2()`を使った放射状パターン
- **花びら形状**: 距離と角度を組み合わせた基本的な花びら

## 課題の流れ
この演習では、「花の生命力 - Flower of Life」作品の第2ステップとして、花びらの基本形状を作成します。

## 実装手順

### ステップ1: 基本的な同心円パターン
距離関数を使って同心円を作成し、花の層構造の基礎を作ります。

```wgsl
@fragment
fn fs_main(in: VertexOutput) -> @location(0) vec4<f32> {
    let uv = NormalizedCoords(in.position.xy);
    let distance = length(uv);
    
    // 同心円パターン
    let ring_pattern = sin(distance * 10.0);
    let rings = (ring_pattern + 1.0) * 0.5;
    
    // 色の計算
    let color = vec3(rings * 0.8, rings * 0.4, rings * 1.0);
    
    return vec4(ToLinearRgb(color), 1.0);
}
```

### ステップ2: 基本的な放射状パターン
角度関数を使って放射状のラインを作成します。

```wgsl
// 角度の計算
let angle = atan2(uv.y, uv.x);

// 放射状パターン（8本の線）
let radial_lines = sin(angle * 4.0); // 4.0 * 2 = 8本の線
let lines = (radial_lines + 1.0) * 0.5;
```

### ステップ3: 基本的な花びら形状
距離と角度を組み合わせて、花びらの基本形状を作成します。

```wgsl
// 花びらの形状（8枚の花びら）
let petal_count = 8.0;
let petal_shape = sin(angle * petal_count * 0.5);
let petal_radius = 0.3 + petal_shape * 0.2;

// 花びらマスク
let petal_mask = 1.0 - smoothstep(petal_radius - 0.05, petal_radius + 0.05, distance);
```

### ステップ4: 花びらと同心円の組み合わせ
花びらの形状に同心円パターンを組み合わせます。

```wgsl
// 花びらパターンと同心円パターンの合成
let combined_pattern = petal_mask * rings;

// より複雑な色の変化
let hue = angle * 0.159 + distance * 2.0; // 角度による色相変化
```

## 完成目標
以下の要素が含まれた花の基本形状：
- 8枚の基本的な花びら
- 同心円による内部構造
- 角度による色の変化


## 学習のポイント
- `length(uv)`で中心からの距離が計算できます
- `atan2(uv.y, uv.x)`で中心からの角度が計算できます
- 距離と角度を組み合わせると花びらの形を作れます
- 三角関数の引数を変えると花びらの数が変わります

## 発展課題
余裕があれば以下にも挑戦してみてください：
1. 花びらの数を変更してみる（4枚、12枚など）
2. 花びらの形状を変更してみる（cos関数を使うなど）
3. 時間による動的な変化を追加してみる