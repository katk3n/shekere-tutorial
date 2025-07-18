# 演習 3: 放射状パターンを加える

## 目標
前回作成した同心円に放射状のライン（光線）を追加して、太陽の光を表現する。

## 学習内容
- **角度計算**: `atan2()`関数で座標から角度を求める
- **三角関数**: `sin()`関数でパターンを作成する
- **パターンの重ね合わせ**: 複数の効果を組み合わせる

## 課題の流れ
この演習では、「太陽の輪」作品の第3ステップとして、8方向の放射状の白いラインを追加します。

## 実装手順

### ステップ1: 前回のコードから開始
まず、前回作成した同心円のコードを基に進めます。

```wgsl
@fragment
fn fs_main(in: VertexOutput) -> @location(0) vec4<f32> {
    let uv = NormalizedCoords(in.position.xy);
    let distance = length(uv);
    
    var color = vec3(0.0);
    
    // 同心円パターン
    if distance < 0.3 {
        color = vec3(1.0, 0.3, 0.1);
    } else if distance < 0.6 {
        color = vec3(1.0, 0.8, 0.0);
    } else if distance < 0.9 {
        color = vec3(1.0, 0.5, 0.0);
    }
    
    return vec4(ToLinearRgb(color), 1.0);
}
```

### ステップ2: 角度を計算する
`atan2()`関数を使って、各ピクセルの角度を求めます。

```wgsl
@fragment
fn fs_main(in: VertexOutput) -> @location(0) vec4<f32> {
    let uv = NormalizedCoords(in.position.xy);
    let distance = length(uv);
    let angle = atan2(uv.y, uv.x); // 角度を計算（-π から π）
    
    var color = vec3(0.0);
    
    // 同心円パターン（前回と同じ）
    if distance < 0.3 {
        color = vec3(1.0, 0.3, 0.1);
    } else if distance < 0.6 {
        color = vec3(1.0, 0.8, 0.0);
    } else if distance < 0.9 {
        color = vec3(1.0, 0.5, 0.0);
    }
    
    return vec4(ToLinearRgb(color), 1.0);
}
```

### ステップ3: 放射状パターンを作成する
角度を使って8方向の放射状パターンを作ります。

```wgsl
@fragment
fn fs_main(in: VertexOutput) -> @location(0) vec4<f32> {
    let uv = NormalizedCoords(in.position.xy);
    let distance = length(uv);
    let angle = atan2(uv.y, uv.x);
    
    var color = vec3(0.0);
    
    // 同心円パターン
    if distance < 0.3 {
        color = vec3(1.0, 0.3, 0.1);
    } else if distance < 0.6 {
        color = vec3(1.0, 0.8, 0.0);
    } else if distance < 0.9 {
        color = vec3(1.0, 0.5, 0.0);
    }
    
    // 放射状パターンを作成（8方向）
    let radial_lines = sin(angle * 4.0) * 0.5 + 0.5;
    let line_intensity = step(0.7, radial_lines);
    
    // ラインを白色で描画（中心の小さな円は除く）
    if line_intensity > 0.5 && distance > 0.1 {
        color = mix(color, vec3(1.0), 0.6);
    }
    
    return vec4(ToLinearRgb(color), 1.0);
}
```

### ステップ4: 理解を深める
各部分がどのように動作するか理解しましょう：

```wgsl
// angle * 4.0: 4倍することで8方向のパターンを作成
// sin(angle * 4.0): -1〜1の範囲で8回の波
// * 0.5 + 0.5: 0〜1の範囲に変換
// step(0.7, radial_lines): 0.7以上で1、未満で0
```

## 完成目標
以下が表示されることを確認してください：
- 3層の同心円（赤・黄・オレンジ）
- 8方向の白い放射状ライン
- 中心の小さな円はライン無し

## 次のステップへ
この放射状パターンができたら、最後の演習で最終調整とエフェクトを追加していきます。

## 学習のポイント
- `atan2(y, x)`で座標から角度を計算できます
- `sin()`関数でパターンを作れます
- `step()`関数で閾値による二値化ができます
- `mix()`関数で色をブレンドできます
- 角度に係数をかけることでパターンの数を調整できます

## 発展課題
余裕があれば以下にも挑戦してみてください：
1. ライン数を変更してみる（`angle * 6.0`で12方向など）
2. ライン強度を調整してみる（`step(0.7, ...)`の値を変更）
3. ライン色を変更してみる（白以外の色）
4. 中心除外範囲を調整してみる（`distance > 0.1`の値を変更）

## 数学関数の参考
```wgsl
// 三角関数
sin(x)        // サイン（-1〜1）
cos(x)        // コサイン（-1〜1）
atan2(y, x)   // アークタンジェント（-π〜π）

// 便利関数
step(edge, x) // x >= edge なら 1、そうでなければ 0
mix(a, b, t)  // a と b を t の比率で混合（t=0でa、t=1でb）
```