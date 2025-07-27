# 演習課題 2: 基本的な時間アニメーションの追加

## 目標
前ステップの静的パターンに時間要素を追加し、Chapter 2のテーマ「時間とアニメーション」の基本を学ぶ。

## このステップで作成するもの
同心円が外向きに移動するアニメーションと、色の時間変化

## 学習内容

### 1. 時間要素の導入
Chapter 2で初めて `Time.duration` を使用：
```wgsl
let time = Time.duration;
let animated_pattern = sin(distance * frequency - time * speed);
```

### 2. 波動の時間移動

#### 同心円の外向き移動
```wgsl
// マイナス符号で外向きに移動
let circle_pattern = sin(distance * 8.0 - time * 2.0);
```
- **`- time * speed`**: 波が中心から外側へ移動
- **speed**: 移動速度の調整

#### 時間変化の数学的意味
- `sin(x - time)`: 正の方向への移動
- `sin(x + time)`: 負の方向への移動
- 位相の時間変化により波動が移動

### 3. 実装のポイント

#### 基本構造
```wgsl
@fragment
fn fs_main(in: VertexOutput) -> @location(0) vec4<f32> {
    let uv = NormalizedCoords(in.position.xy);
    let time = Time.duration;  // 時間要素を追加
    let distance = length(uv);
    let angle = atan2(uv.y, uv.x);
    
    // 前ステップの構造に時間要素を追加
    let circle_pattern = sin(distance * 8.0 - time * 2.0);  // アニメーション
    let radial_pattern = sin(angle * 6.0);                  // 静的
    let combined = circle_pattern * 0.7 + radial_pattern * 0.3;
    
    // 色の時間変化も追加
    let color_shift = sin(time * 0.5) * 0.2 + 0.8;
    
    return vec4(ToLinearRgb(color), 1.0);
}
```

#### 段階的開発の継続
- **前ステップの構造を維持**: 同じパターン組み合わせ
- **時間要素のみ追加**: 最小限の変更
- **効果の確認**: アニメーションの動きを確認

#### 時間パラメータの調整
```wgsl
// 移動速度の調整
sin(distance * 8.0 - time * 1.0);  // ゆっくり
sin(distance * 8.0 - time * 4.0);  // 高速
```

## 実験してみよう

### パラメータの調整

1. **アニメーション速度を変える**
   ```wgsl
   let circle_pattern = sin(distance * 8.0 - time * 1.0);  // ゆっくり
   let circle_pattern = sin(distance * 8.0 - time * 5.0);  // 高速
   ```

2. **移動方向を変える**
   ```wgsl
   sin(distance * 8.0 - time * 2.0);  // 外向き
   sin(distance * 8.0 + time * 2.0);  // 内向き
   ```

3. **色変化の速度を変える**
   ```wgsl
   let color_shift = sin(time * 0.2) * 0.2 + 0.8;  // ゆっくり
   let color_shift = sin(time * 1.0) * 0.2 + 0.8;  // 高速
   ```

### 発展課題

#### 課題2-1: 放射線にもアニメーションを追加
放射線パターンにも時間要素を追加してみてください：
```wgsl
let radial_pattern = sin(angle * 6.0 + time * 1.0);  // 回転する放射線
```

#### 課題2-2: 異なる速度の組み合わせ
複数の異なる速度のアニメーションを組み合わせてみてください：
```wgsl
let fast_circle = sin(distance * 8.0 - time * 3.0);
let slow_circle = sin(distance * 4.0 - time * 1.0);
let combined = fast_circle * 0.5 + slow_circle * 0.5;
```

#### 課題2-3: 色の複雑な時間変化
複数の色成分に異なる時間変化を追加してみてください：
```wgsl
let red_shift = sin(time * 0.3) * 0.3 + 0.7;
let green_shift = sin(time * 0.5 + 1.0) * 0.3 + 0.7;
let blue_shift = sin(time * 0.7 + 2.0) * 0.3 + 0.7;
```

## 次のステップへ
基本的な時間アニメーションができたら、次のステップ「03-complex-time-effects」でより複雑な時間効果を追加していきましょう。

## 学習のポイント
1. **時間要素の導入**: Chapter 2で初めて `Time.duration` を使用
2. **波動の移動**: `sin(pattern - time * speed)` による移動効果
3. **段階的追加**: 前ステップの構造を保持しながら時間要素のみ追加
4. **基本アニメーション**: 同心円の外向き移動と色の変化
5. **Chapter 2のテーマ**: 「時間とアニメーション」の基礎習得