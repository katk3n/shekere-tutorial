# 演習 1: 基本的な座標変換

## 目標
UV座標変換の基礎を理解し、花の形状作成の土台となる座標操作を習得する。

## 学習内容
- **座標対称化**: `abs()`関数による対称パターン
- **座標スケーリング**: 拡大・縮小による形状変化
- **座標回転**: 回転変換の基礎

## 課題の流れ
この演習では、最終的に「花の生命力 - Flower of Life」という作品を作成するための第1ステップとして、基本的な座標変換を学習します。

## 実装手順

### ステップ1: 基本的な円を作成
まず、変換の効果を確認するための基本図形を作成します。

```wgsl
@fragment
fn fs_main(in: VertexOutput) -> @location(0) vec4<f32> {
    let uv = NormalizedCoords(in.position.xy);
    
    // 基本の円
    let distance = length(uv);
    let circle = 1.0 - smoothstep(0.3, 0.35, distance);
    
    // 色の計算
    let color = vec3(circle * 0.8, circle * 0.4, circle * 1.0);
    
    return vec4(ToLinearRgb(color), 1.0);
}
```

### ステップ2: 対称化による花びらの準備
`abs()`関数を使って対称パターンを作成し、花びらの基礎を準備します。

```wgsl
// 座標を対称化
let symmetric_uv = abs(uv);

// 対称化された座標で円を描画
let distance = length(symmetric_uv);
let pattern = 1.0 - smoothstep(0.2, 0.25, distance);
```

### ステップ3: スケーリングによる形状調整
花びらの形状を調整するためのスケーリングを学習します。

```wgsl
// 非等方スケーリングで楕円形を作成
let scaled_uv = vec2(uv.x * 2.0, uv.y * 0.8);
let distance = length(scaled_uv);
let ellipse = 1.0 - smoothstep(0.3, 0.35, distance);
```

### ステップ4: 基本的な回転
花びらの配置準備として、基本的な回転を学習します。

```wgsl
// 45度回転
let angle = 0.785398; // π/4
let cos_a = cos(angle);
let sin_a = sin(angle);
let rotated_uv = vec2(
    uv.x * cos_a - uv.y * sin_a,
    uv.x * sin_a + uv.y * cos_a
);
```

## 完成目標
以下の座標変換が理解できること：
- 対称化による4象限への複製
- スケーリングによる楕円形作成
- 基本的な回転変換


## 学習のポイント
- 座標変換は花びらの形状作成の基礎です
- `abs()`による対称化は花びらの複製に使えます
- スケーリングで花びらの形を調整できます
- 回転は花びらの配置に必要です

## 発展課題
余裕があれば以下にも挑戦してみてください：
1. 異なる角度での回転を試してみる
2. X軸とY軸で異なるスケーリング比率を試す
3. 対称化と回転を組み合わせてみる