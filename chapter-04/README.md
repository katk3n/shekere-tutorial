# Chapter 4: Interaction
## インタラクション

### 本章の目標
- インタラクティブシェーダーアートの基本概念を理解する
- `MouseCoords()`関数の使用方法を習得する
- マウス座標を使った動的な効果を作成する
- 距離計算を使ったカーソル追従効果を実装する
- インタラクティブパターンの応用技術を理解する

---

## 1. インタラクションとは

### インタラクティブシェーダーアートの定義
**インタラクティブシェーダーアート**とは、ユーザーの入力（マウス、キーボード、音声など）に応じてリアルタイムで変化するシェーダーアート作品です。従来の静的なアートとは異なり、観る人の行動によって作品の表現が変化します。

### インタラクションの特徴
- **リアルタイム応答**: 入力に対する即座の視覚的フィードバック
- **動的表現**: ユーザーの行動により作品が変化
- **参加型体験**: 観客が作品の一部となる体験
- **無限の可能性**: 同じ作品でも毎回異なる表現が可能

### インタラクションの応用分野
- **インスタレーション**: 美術館やギャラリーでの体験型作品
- **ライブパフォーマンス**: VJやライブコーディング
- **ゲーム開発**: プレイヤーの行動に応じた視覚効果
- **教育ツール**: 対話的な学習コンテンツ

---

## 2. マウス入力の基本

### マウス入力の概要
shekereフレームワークでは、マウス入力を使ってインタラクティブなシェーダーアートを作成できます。マウスの位置を取得し、その座標を使って様々な視覚効果を生み出すことができます。

### マウス座標の種類

#### 1. 物理座標（ピクセル座標）
```wgsl
// Mouse.position: 画面の実際のピクセル座標
// 範囲: (0, 0) 〜 (画面幅, 画面高さ)
```

#### 2. 正規化座標（normalized coordinates）
```wgsl
// MouseCoords(): 正規化されたマウス座標
// 範囲: (-1.0, -1.0) 〜 (1.0, 1.0)
// 中心: (0.0, 0.0)
```

### 座標系の比較
- **物理座標**: 画面サイズに依存、左上が原点
- **正規化座標**: 画面サイズに無関係、中心が原点、アスペクト比調整済み

---

## 3. MouseCoords()関数

### MouseCoords()の概要
`MouseCoords()`は、shekereフレームワークが提供する**マウス座標取得関数**です。マウスの現在位置を正規化座標で取得できます。

### 基本的な使用方法
```wgsl
let mouse = MouseCoords();
// mouse.x: 横方向の位置（-1.0 〜 1.0）
// mouse.y: 縦方向の位置（-1.0 〜 1.0）
```

### 座標の特性
- **データ型**: `vec2<f32>`（2次元ベクトル）
- **範囲**: x, y共に-1.0 〜 1.0
- **中心**: (0.0, 0.0)が画面中央
- **アスペクト比**: 自動的に調整される

### 実践例: マウス位置の可視化
```wgsl
@fragment
fn fs_main(in: VertexOutput) -> @location(0) vec4<f32> {
    let uv = NormalizedCoords(in.position.xy);
    let mouse = MouseCoords();
    
    // マウス位置を色として表示
    let color = vec3(
        (mouse.x + 1.0) * 0.5,  // X座標を赤成分に
        (mouse.y + 1.0) * 0.5,  // Y座標を緑成分に
        0.5                      // 青成分は固定
    );
    
    return vec4(ToLinearRgb(color), 1.0);
}
```

**この例の動作**:
- マウスを左右に動かすと画面の赤色が変化
- マウスを上下に動かすと画面の緑色が変化
- マウスの位置がリアルタイムで色として表示される

---

## 4. 距離計算とカーソル追従

### 距離計算の基本
マウス座標とピクセル座標の距離を計算することで、カーソルの位置に応じた効果を作成できます。

### length()関数による距離計算
```wgsl
let uv = NormalizedCoords(in.position.xy);
let mouse = MouseCoords();
let distance = length(uv - mouse);
```

### 距離の活用方法

#### 1. 距離による色変化
```wgsl
@fragment
fn fs_main(in: VertexOutput) -> @location(0) vec4<f32> {
    let uv = NormalizedCoords(in.position.xy);
    let mouse = MouseCoords();
    let distance = length(uv - mouse);
    
    // 距離に応じた色変化
    let color = vec3(1.0 - distance, distance, 0.5);
    
    return vec4(ToLinearRgb(color), 1.0);
}
```

#### 2. 円形効果（オーブエフェクト）
```wgsl
@fragment
fn fs_main(in: VertexOutput) -> @location(0) vec4<f32> {
    let uv = NormalizedCoords(in.position.xy);
    let mouse = MouseCoords();
    let distance = length(uv - mouse);
    
    // 半径0.1の円形効果
    let radius = 0.1;
    let intensity = clamp(1.0 - distance / radius, 0.0, 1.0);
    
    // 緑色のオーブ
    let color = vec3(0.0, intensity, 0.0);
    
    return vec4(ToLinearRgb(color), 1.0);
}
```

---

## 5. 高度なインタラクション技術

### 1. 滑らかなフォールオフ効果
```wgsl
fn smoothOrb(uv: vec2<f32>, center: vec2<f32>, radius: f32) -> f32 {
    let distance = length(uv - center);
    let t = clamp(1.0 + radius - distance, 0.0, 1.0);
    return pow(t, 16.0);  // 16乗で急激なフォールオフ
}

@fragment
fn fs_main(in: VertexOutput) -> @location(0) vec4<f32> {
    let uv = NormalizedCoords(in.position.xy);
    let mouse = MouseCoords();
    
    let intensity = smoothOrb(uv, mouse, 0.07);
    let color = vec3(0.0, intensity, 0.0);
    
    return vec4(ToLinearRgb(color), 1.0);
}
```

### 2. 複数のインタラクション要素
```wgsl
@fragment
fn fs_main(in: VertexOutput) -> @location(0) vec4<f32> {
    let uv = NormalizedCoords(in.position.xy);
    let mouse = MouseCoords();
    
    // 複数の効果を組み合わせ
    let orb1 = smoothOrb(uv, mouse, 0.05);
    let orb2 = smoothOrb(uv, mouse + vec2(0.2, 0.0), 0.03);
    let orb3 = smoothOrb(uv, mouse - vec2(0.2, 0.0), 0.03);
    
    // 異なる色で複数のオーブを表示
    let color = vec3(orb1, orb2, orb3);
    
    return vec4(ToLinearRgb(color), 1.0);
}
```

### 3. 時間と組み合わせた動的効果
```wgsl
@fragment
fn fs_main(in: VertexOutput) -> @location(0) vec4<f32> {
    let uv = NormalizedCoords(in.position.xy);
    let mouse = MouseCoords();
    let time = Time.duration;
    
    // 時間による半径の変化
    let radius = 0.05 + 0.02 * sin(time * 3.0);
    
    // 時間による色の変化
    let hue = sin(time * 2.0) * 0.5 + 0.5;
    
    let intensity = smoothOrb(uv, mouse, radius);
    let color = vec3(intensity * hue, intensity, intensity * (1.0 - hue));
    
    return vec4(ToLinearRgb(color), 1.0);
}
```

---

## 6. 実用的なテクニック

### clamp()関数による制限
```wgsl
// 値を0.0〜1.0の範囲に制限
let clamped = clamp(value, 0.0, 1.0);
```

### pow()関数による曲線制御
```wgsl
// 指数関数による滑らかな減衰
let smooth = pow(linear_value, 4.0);  // 4乗で急激な変化
let gentle = pow(linear_value, 0.5);  // 平方根で緩やかな変化
```

### mix()関数による色のブレンド
```wgsl
let color1 = vec3(1.0, 0.0, 0.0);  // 赤
let color2 = vec3(0.0, 1.0, 0.0);  // 緑
let blended = mix(color1, color2, factor);  // factorで混合比を制御
```

---

## 7. デバッグとトラブルシューティング

### よくある問題と解決方法

#### 1. マウス座標が反応しない
- `MouseCoords()`の戻り値が正しく使われているか確認
- 変数の型が`vec2<f32>`になっているか確認

#### 2. 効果が画面外に出る
- 距離計算の結果を`clamp()`で制限する
- 半径やしきい値を調整する

#### 3. 効果が弱すぎる・強すぎる
- `pow()`関数の指数を調整する
- 強度の乗算係数を変更する

### デバッグのコツ
1. **段階的な実装**: 一度に複雑な効果を作らず、段階的に機能を追加
2. **色による可視化**: 計算結果を色として表示して確認
3. **パラメータの調整**: 数値を少しずつ変更して最適な値を見つける

---

## 8. 学習のポイント

### 重要な概念
- **正規化座標**: 画面サイズに依存しない座標系
- **距離計算**: `length()`関数による2点間の距離
- **フォールオフ**: 距離に応じた効果の減衰
- **リアルタイム応答**: 入力に対する即座の視覚的反応

### 実践のコツ
1. **小さな効果から始める**: 単純な円形効果から複雑な表現へ
2. **パラメータを調整する**: 数値を変更して効果を確認
3. **複数の技術を組み合わせる**: 時間、マウス、数学関数の組み合わせ
4. **ユーザビリティを考慮する**: 直感的で楽しいインタラクション

---

## 次のステップ

Chapter 4を完了したら、以下を確認してください：
- [ ] `MouseCoords()`の使用方法を理解している
- [ ] 距離計算による効果を作成できる
- [ ] カーソル追従効果を実装できる
- [ ] 複数のインタラクション要素を組み合わせることができる

次章では、音響信号を使ったオーディオビジュアライゼーションについて学習します。

---

## サンプルプロジェクト

本章には以下のサンプルプロジェクトが含まれています：

- `examples/01-mouse-position/`: マウス位置の可視化
- `examples/02-cursor-following/`: カーソル追従オーブ効果
- `examples/03-distance-effects/`: 距離ベースの色変化

## 💡 段階的演習課題

以下の4つの演習を段階的に進めることで、インタラクティブシェーダーアートの本格的な作品を完成させます。各ステップでは前のステップのコードを継承・拡張して進めます：

### [演習1: 基本光源](./exercises/01-mouse-following/)
MouseCoords()とlength()による基本的なマウス追従光源を作成
- Chapter 4特有のインタラクション技術（マウス入力・距離計算）
- 美しい光のフォールオフ効果の基礎実装
- pow()による滑らかな曲線制御を習得

### [演習2: 複数光源](./exercises/02-distance-applications/)
前ステップの基本光源に複数の固定光源を追加
- 前ステップのコードを基礎として使用
- create_light()関数による再利用可能なシステム設計
- 複数光源の加算合成による美しい配置

### [演習3: 動的色彩システム](./exercises/03-interactive-patterns/)
HSV色空間と距離ベース色彩相互作用を追加
- 前ステップの複数光源システムを基礎として使用
- hsv_to_rgb()による自然な色彩変化システム
- マウス位置による動的色相変化と色彩効果の実践

### [演習4: 完成作品](./exercises/04-final-work/)
時間効果・パーティクル・波動エフェクトで作品を完成
- 前ステップの3システムを基礎として使用
- Time.durationによる時間軸の導入と自動アニメーション
- パーティクルシステム・エネルギー波動・レスポンシブ背景の統合
- インタラクティブ作品の完成