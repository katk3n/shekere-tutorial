# 演習 3: 多層花びらパターン

## 目標
複数のレイヤーを重ね合わせた複雑な花びらパターンを作成し、基本的なアニメーション効果を追加する。

## 学習内容
- **レイヤー合成**: 複数のパターンを重ね合わせる技術
- **回転アニメーション**: `Time.duration`を使った回転効果
- **成長アニメーション**: 時間による大きさの変化

## 課題の流れ
この演習では、「花の生命力 - Flower of Life」作品の第3ステップとして、複数レイヤーの花びらと基本的なアニメーションを実装します。

## 実装手順

### ステップ1: 花びら作成関数の定義
再利用可能な花びら作成関数を定義します。

```wgsl
// 花びらパターン生成関数
fn create_petal_layer(uv: vec2<f32>, petal_count: f32, radius: f32, rotation: f32) -> f32 {
    let distance = length(uv);
    let angle = atan2(uv.y, uv.x) + rotation;
    
    // 花びらの形状計算
    let petal_shape = sin(angle * petal_count * 0.5) * 0.2 + 0.8;
    let petal_radius = radius * petal_shape;
    
    // 滑らかなエッジ
    return 1.0 - smoothstep(petal_radius - 0.05, petal_radius + 0.05, distance);
}
```

### ステップ2: 複数レイヤーの作成
異なるサイズと花びら数のレイヤーを作成します。

```wgsl
// レイヤー1: 大きな外側の花びら（8枚）
let layer1 = create_petal_layer(uv, 8.0, 0.6, 0.0);

// レイヤー2: 中間の花びら（12枚）
let layer2 = create_petal_layer(uv, 12.0, 0.4, 0.0);

// レイヤー3: 小さな内側の花びら（16枚）
let layer3 = create_petal_layer(uv, 16.0, 0.25, 0.0);
```

### ステップ3: 回転アニメーションの追加
各レイヤーに異なる回転速度を適用します。

```wgsl
let time = Time.duration;

// 異なる回転速度
let rotation1 = time * 0.1;
let rotation2 = -time * 0.15;
let rotation3 = time * 0.2;

let layer1 = create_petal_layer(uv, 8.0, 0.6, rotation1);
let layer2 = create_petal_layer(uv, 12.0, 0.4, rotation2);
let layer3 = create_petal_layer(uv, 16.0, 0.25, rotation3);
```

### ステップ4: 成長アニメーションと合成
時間による成長効果とレイヤーの合成を実装します。

```wgsl
// 成長のアニメーション
let growth = sin(time * 0.5) * 0.3 + 0.7;

// 成長を適用したレイヤー
let layer1 = create_petal_layer(uv, 8.0, 0.6 * growth, rotation1);
let layer2 = create_petal_layer(uv, 12.0, 0.4 * growth, rotation2);
let layer3 = create_petal_layer(uv, 16.0, 0.25 * growth, rotation3);

// レイヤーの重み付き合成
let combined = layer1 * 0.5 + layer2 * 0.3 + layer3 * 0.2;
```

## 完成目標
以下の要素が含まれた多層花びらパターン：
- 3つの異なる花びらレイヤー（8枚、12枚、16枚）
- 各レイヤーの独立した回転アニメーション
- 全体の成長アニメーション
- 美しい色彩の変化


## 学習のポイント
- 関数を使ってコードを再利用可能にできます
- 複数のパターンを重ね合わせると複雑な表現ができます
- 異なる回転速度で有機的な動きを表現できます
- 成長アニメーションで生命力を表現できます

## 発展課題
余裕があれば以下にも挑戦してみてください：
1. 4つ目のレイヤーを追加してみる
2. 回転速度を変更して異なる効果を試す
3. 成長パターンを変更してみる（cos関数など）
4. 中心部にグロー効果を追加してみる