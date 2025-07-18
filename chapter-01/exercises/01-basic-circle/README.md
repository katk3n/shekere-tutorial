# 演習 1: 基本の円を描く

## 目標
UV座標と距離計算を理解し、画面の中心に単色の円を描画できるようになる。

## 学習内容
- **UV座標**: `NormalizedCoords()`関数の使い方
- **距離計算**: `length()`関数で中心からの距離を求める
- **条件分岐**: `if`文で領域を分ける

## 課題の流れ
この演習では、最終的に「太陽の輪」という作品を作成するための第1ステップとして、基本的な円を描画します。

## 実装手順

### ステップ1: UV座標を理解する
まず、UV座標システムを理解しましょう。

```wgsl
@fragment
fn fs_main(in: VertexOutput) -> @location(0) vec4<f32> {
    let uv = NormalizedCoords(in.position.xy);
    
    // UV座標をそのまま色として表示（デバッグ用）
    let color = vec3(uv.x * 0.5 + 0.5, uv.y * 0.5 + 0.5, 0.0);
    return vec4(ToLinearRgb(color), 1.0);
}
```

### ステップ2: 中心からの距離を計算する
`length()`関数を使って、各ピクセルが中心からどれくらい離れているかを計算します。

```wgsl
@fragment
fn fs_main(in: VertexOutput) -> @location(0) vec4<f32> {
    let uv = NormalizedCoords(in.position.xy);
    
    // 中心からの距離を計算
    let distance = length(uv);
    
    // 距離を色として可視化
    let color = vec3(distance);
    return vec4(ToLinearRgb(color), 1.0);
}
```

### ステップ3: 条件分岐で円を描く
距離を使って、円の内側と外側で異なる色を設定します。

```wgsl
@fragment
fn fs_main(in: VertexOutput) -> @location(0) vec4<f32> {
    let uv = NormalizedCoords(in.position.xy);
    
    // 中心からの距離を計算
    let distance = length(uv);
    
    var color = vec3(0.0); // 初期値: 黒色
    
    // 距離が0.5より小さい場合は円の内側
    if distance < 0.5 {
        color = vec3(1.0, 0.0, 0.0); // 赤色の円
    }
    
    return vec4(ToLinearRgb(color), 1.0);
}
```

## 完成目標
画面中央に赤い円が描画されることを確認してください。

## 次のステップへ
この基本的な円ができたら、次の演習で複数の色のリングを作成していきます。

## 学習のポイント
- UV座標は-1.0〜1.0の範囲で、(0,0)が画面中央です
- `length(uv)`で中心からの距離が計算できます
- 距離が小さいほど中心に近い位置です
- Hot Reload機能を使って、値を変更しながら実験してみましょう

## 発展課題
余裕があれば以下にも挑戦してみてください：
1. 円のサイズを変更してみる（0.5以外の値を試す）
2. 円の色を変更してみる
3. 複数の円を描いてみる（異なる距離で条件分岐を増やす）