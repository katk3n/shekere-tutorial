# 演習 4: 最終統合作品

## 目標
前3つの演習で学んだ全ての技術要素を統合し、波動パターン・時間アニメーション・HSV色空間システムを追加して、「自然界の数学的パターンの発見」シリーズの完成作品を作成する。

## 作品テーマ: 「自然界の数学的パターンの発見」シリーズ完結作
螺旋（銀河）、格子（結晶）、ノイズ（不規則性）、波動（流体）という4つの異なる自然現象を数学的に表現し、時間の流れと美しい色彩で統合した最終作品です。

## 完成作品の特徴
以下の全要素を含んだ「自然の複合パターン」が完成します：
- **4つの数学的パターン**: 螺旋・格子・ノイズ・波動の調和的統合
- **時間アニメーション**: 全体が時間とともに回転する動的な表現
- **波動パターン**: sin/cosによる流体のような波の表現
- **HSV色空間**: 時間による連続的な色相変化
- **距離減衰**: 中心から外側への美しいグラデーション
- **動的ノイズ**: 時間とともに変化するランダムパターン

## 実装する技術要素

### 前ステップからの継承（Exercise 1-3のコードを再利用）
前3つの演習で段階的に構築した数学的パターンを全て統合し、以下の新技術を追加します：

1. **Exercise 1から継承: 螺旋パターン**
   - `length()/atan2()`による銀河の腕構造
   - 時間による回転座標系への発展

2. **Exercise 2から継承: 格子パターン**
   - `rotate_uv()/fract()/smoothstep()`による結晶格子
   - 回転座標系での格子パターン生成

3. **Exercise 3から継承: ノイズパターン**
   - `pseudo_random()`による自然の不規則性
   - 時間変化する動的ノイズへの発展

4. **Exercise 4新規追加: 波動パターン**
   - `sin()/cos()`による流体の波動表現
   - 時間アニメーション統合システム

### 新規実装技術（この演習で追加学習）

1. **時間ベースアニメーション**
   - `Time.duration`による全体回転
   - 動的ノイズの時間変化

2. **波動パターンシステム**
   - X方向とY方向の独立した波動
   - 波の干渉による複雑なパターン

3. **HSV風色空間システム**
   - 時間による色相シフト
   - 120度位相差によるRGB生成

4. **距離減衰システム**
   - `smoothstep()`による美しいフェード
   - 可視性を保つ最低輝度制御

## 段階的実装手順

このexerciseでは、Exercise 3の螺旋+格子+ノイズパターンをベースに、以下の8つのステップを順番に実装することで、最終統合作品を段階的に理解し構築します。

### Step 1: Exercise 3のコードから開始

**目標**: 前のExerciseの完成コード（螺旋+格子+ノイズ）をベースとして開始

**Exercise 3から継承するコード**:
```wgsl
// Exercise 3から継承: 関数定義
fn rotate_uv(uv: vec2<f32>, angle: f32) -> vec2<f32> { /* 実装略 */ }
fn pseudo_random(uv: vec2<f32>) -> f32 { /* 実装略 */ }

// Exercise 3から継承: 3パターンの統合
let spiral_pattern = fract(normalized_angle * 3.0 + distance * 5.0);
let grid_pattern = /* 格子パターンの実装 */;
let noise_pattern = pseudo_random(noise_uv);
let final_pattern = (spiral_pattern * 0.7 + grid_pattern * 0.3) * 0.8 + noise_pattern * 0.2;
let color = vec3(final_pattern * 0.6, final_pattern * 0.8, final_pattern * 0.5);
```

**解説**: Exercise 3の螺旋+格子+ノイズパターンのコードをそのまま使用します。このベースに時間アニメーションと波動パターンを追加していきます。

**確認方法**: Exercise 3と同じ茶緑色の複合パターンが表示されることを確認してください。

---

### Step 2: Time.durationを使った時間ベース回転の実装

**目標**: `Time.duration`を使って全体を時間とともに回転させる

**新規追加コード**:
```wgsl
// 新規追加: 時間による回転座標系
let time = Time.duration;
let rotated_uv = rotate_uv(uv, time * 0.2);

// 変更: 回転された座標系でパターンを計算
let distance = length(rotated_uv);  // uv → rotated_uv
let angle = atan2(rotated_uv.y, rotated_uv.x);  // uv → rotated_uv
// 以下、すべてのパターン計算でrotated_uvを使用
```

**解説**: `Time.duration`を使って座標系を時間とともに回転させます。これにより静的なパターンに動的な生命力が加わります。

**確認方法**: パターン全体が時計回りにゆっくりと回転することを確認してください。

---

### Step 3: 波動パターンの基本実装（sin/cos）

**目標**: `sin()/cos()`を使って基本的な波動パターンを作成する

**新規追加コード**:
```wgsl
// 新規追加: 波動パターンの基本実装
let wave_x = sin(rotated_uv.x * 8.0 + time);
let wave_y = cos(rotated_uv.y * 6.0 + time * 0.8);

// 新規追加: 波の干渉パターン生成
let wave_pattern = wave_x * wave_y;
let wave_intensity = (wave_pattern + 1.0) * 0.5;  // -1〜1を0〜1に変換

// テスト: 波動パターンのみを表示
let color = vec3(wave_intensity, wave_intensity, wave_intensity);
```

**解説**: X方向とY方向に独立した波動を作成し、それらを乗算することで干渉パターンを生成します。時間により波が移動します。

**確認方法**: 波状の干渉パターンが時間とともに動くことを白黒で確認してください。

---

### Step 4: 波の干渉パターンの作成と調整

**目標**: 波の干渉パターンを調整し、美しい流体効果を作成する

**変更コード**:
```wgsl
// 変更: 調整された波動パターン
let wave_x = sin(rotated_uv.x * 8.0 + time);         // X方向の波
let wave_y = cos(rotated_uv.y * 6.0 + time * 0.8);   // Y方向の波（異なる速度）
let wave_pattern = wave_x * wave_y;                   // 干渉パターン
let wave_intensity = (wave_pattern + 1.0) * 0.5;     // 0〜1範囲に正規化

// 変更: 波動パターンを青系の色で確認
let color = vec3(
    wave_intensity * 0.4,
    wave_intensity * 0.7,
    wave_intensity * 0.9
);
```

**解説**: X方向(8.0周波数)とY方向(6.0周波数)の異なる波を組み合わせ、時間変化速度も変えることで複雑で美しい干渉パターンを作成します。

**確認方法**: 青系の色で流体のような美しい波の干渉パターンが表示されることを確認してください。

---

### Step 5: 4パターンの統合システム構築

**目標**: 螺旋、格子、ノイズ、波動の4つのパターンを統合する

**新規追加コード**:
```wgsl
// 再追加: 前3つのパターン（回転座標系で）
let spiral_pattern = fract(normalized_angle * 3.0 + distance * 5.0);
let grid_pattern = /* 格子パターンの実装（Exercise 2から継承） */;
let noise_pattern = pseudo_random(noise_uv + vec2(time * 0.1, 0.0));  // 時間変化追加

// 新規追加: 4パターンの段階的統合システム
let spiral_grid_combined = spiral_pattern * 0.7 + grid_pattern * 0.3;  // 段階1
let three_pattern_combined = spiral_grid_combined * 0.8 + noise_pattern * 0.2;  // 段階2
let final_pattern = three_pattern_combined * 0.7 + wave_intensity * 0.3;  // 段階3

// 変更: 統合結果を白黒で確認
let color = vec3(final_pattern, final_pattern, final_pattern);
```

**解説**: 段階的に統合することで各パターンの特徴を保持します。ノイズに時間変化を追加し、より動的な表現を実現します。

**確認方法**: 4つのパターンが調和した複雑で美しい複合パターンが白黒で表示されることを確認してください。

---

### Step 6: 距離減衰システムの実装

**目標**: 中心からの距離に応じて美しいフェード効果を追加する

**新規追加コード**:
```wgsl
// 新規追加: 距離減衰システム
let fade = 1.0 - smoothstep(0.8, 1.8, distance);  // 外側をフェード
let faded_intensity = final_pattern * (0.3 + fade * 0.7);  // 最低30%の明度を保持

// 変更: フェード効果を適用した表示
let color = vec3(faded_intensity, faded_intensity, faded_intensity);
```

**解説**: `smoothstep()`を使って中心から外側への美しいフェード効果を作成します。最低明度30%を保持することで外側も視認可能にします。

**確認方法**: 中心が明るく、外側に向かって自然にフェードする美しいグラデーションが確認できることを確認してください。

---

### Step 7: HSV風色空間システムの実装

**目標**: 時間による色相変化と美しい虹色効果を実装する

**新規追加コード**:
```wgsl
// 新規追加: HSV風色空間システム
let hue_shift = time * 0.1;
let hue = fract(faded_intensity + hue_shift);

// 新規追加: 120度位相差によるRGB生成
let saturation = 0.8;
let value = faded_intensity;

let red = (sin(hue * 6.28) + 1.0) * 0.5 * saturation * value;
let green = (sin(hue * 6.28 + 2.09) + 1.0) * 0.5 * saturation * value;  // 120度位相差
let blue = (sin(hue * 6.28 + 4.19) + 1.0) * 0.5 * saturation * value;   // 240度位相差

// 変更: HSV色空間による色彩
let color = vec3(red, green, blue);
```

**解説**: 時間による色相シフトと120度位相差による美しいRGB生成で、虹色効果を実現します。彩度と明度も考慮した本格的な色空間システムです。

**確認方法**: パターンが時間とともに美しい虹色に変化することを確認してください。

---

### Step 8: 最終調整と完成

**目標**: 全体のバランスを調整し、作品を完成させる

**最終版の統合**:
```wgsl
// 最終版: 全システムの統合
let rotated_uv = rotate_uv(uv, time * 0.2);  // 時間回転

// 4つのパターンの統合
let spiral_pattern = fract(normalized_angle * 3.0 + distance * 5.0);
let grid_pattern = /* Exercise 2の格子パターン */;
let noise_pattern = pseudo_random(noise_uv + vec2(time * 0.1, 0.0));
let wave_intensity = (sin(rotated_uv.x * 8.0 + time) * cos(rotated_uv.y * 6.0 + time * 0.8) + 1.0) * 0.5;

// 段階的統合
let final_pattern = (spiral_pattern * 0.7 + grid_pattern * 0.3) * 0.8 + noise_pattern * 0.2;
final_pattern = final_pattern * 0.7 + wave_intensity * 0.3;

// 距離減衰とHSV色空間
let faded_intensity = final_pattern * (0.3 + (1.0 - smoothstep(0.8, 1.8, distance)) * 0.7);
let hue = fract(faded_intensity + time * 0.1);
let color = vec3(
    (sin(hue * 6.28) + 1.0) * 0.5 * 0.8 * faded_intensity,
    (sin(hue * 6.28 + 2.09) + 1.0) * 0.5 * 0.8 * faded_intensity,
    (sin(hue * 6.28 + 4.19) + 1.0) * 0.5 * 0.8 * faded_intensity
);
```

**解説**: 「自然の複合パターン」の完成版です。螺旋（銀河）、格子（結晶）、ノイズ（不規則性）、波動（流体）という4つの自然現象が時間と色彩で統合された最終作品です。

**確認方法**: 美しい虹色で時間とともに変化する複雑で調和の取れた「自然の複合パターン」が表示されることを確認してください。完成です！

### 技術解説

#### 1. 時間ベース回転座標系
```wgsl
let rotated_uv = rotate_uv(uv, time * 0.2);
```
- 全体を時間とともに回転させる動的座標系
- 静的パターンに生命力を与える効果
- 回転速度`0.2`による適度な動きの演出

#### 2. 波動パターンの生成
```wgsl
let wave_x = sin(rotated_uv.x * 8.0 + time);
let wave_y = cos(rotated_uv.y * 6.0 + time * 0.8);
let wave_pattern = wave_x * wave_y;
```
- X方向とY方向の独立した波動
- 異なる周波数(8.0, 6.0)による複雑な干渉パターン
- 時間による波の移動効果

#### 3. 4段階パターン統合システム
```wgsl
// 段階1: 螺旋+格子
let spiral_grid = spiral_pattern * 0.7 + grid_pattern * 0.3;
// 段階2: +ノイズ
let three_patterns = spiral_grid * 0.8 + noise_pattern * 0.2;
// 段階3: +波動
let final_pattern = three_patterns * 0.7 + wave_intensity * 0.3;
```
- 各段階で重み付きで統合
- 自然な調和を保つ比率調整
- 複雑さと美しさのバランス

#### 4. HSV風色空間システム
```wgsl
let hue = fract(final_pattern + hue_shift);
let red = (sin(hue * 6.28) + 1.0) * 0.5;
let green = (sin(hue * 6.28 + 2.09) + 1.0) * 0.5;  // 120度位相差
let blue = (sin(hue * 6.28 + 4.19) + 1.0) * 0.5;   // 240度位相差
```
- 時間による連続的な色相変化
- 120度位相差による美しい色の変化
- 自然な虹色効果の実現

## 完成目標
以下の技術要素を理解し実装できること：
- 前3ステップの全技術要素の統合と継承
- 時間ベースアニメーションシステムの構築
- 波動パターンの数学的生成と統合
- HSV風色空間による動的な色彩表現
- 複数パターンの調和的な統合技術

## 作品の特徴解説

現在の実装は以下の特徴を持つ完成作品です：

```wgsl
// 作品名: "自然の複合パターン - Natural Complex Patterns"
// テーマ: 自然界の数学的パターンの発見
// 作品説明: 螺旋・格子・ノイズ・波動を統合した数学的美の表現
// 使用技術: 極座標変換、疑似乱数、波動関数、時間アニメーション、HSV色空間
// 制作の工夫: 4つの異なる自然現象を数学的に表現し、時間の流れで統合
```

## 技術的な成果
- **段階的発展**: Exercise 1-4を通じた体系的な技術習得
- **複雑な統合**: 4つの異なるパターンの調和的な合成
- **動的な表現**: 時間アニメーションによる生命力の演出
- **美しい色彩**: HSV風色空間による連続的な色相変化
- **数学的美学**: 自然現象を数式で表現する技術の習得

## Chapter 3 の完成！
このステップで、Chapter 3「座標とパターン」の学習が完了します。

### 学習の軌跡
1. **Exercise 1**: 螺旋パターン（銀河の腕）- `length()/atan2()`による極座標表現
2. **Exercise 2**: 格子パターン（結晶構造）- `fract()/smoothstep()`による規則的パターン
3. **Exercise 3**: ノイズ統合（秩序と混沌）- `pseudo_random()`による自然の不規則性
4. **Exercise 4**: 最終統合作品（自然の複合パターン）- 時間アニメーションとHSV色空間

### 習得した技術
- **極座標系の理解**: `length()/atan2()`による距離と角度の活用
- **パターン生成**: `fract()`による周期化とパターン統合技術
- **カスタム関数**: 再利用可能な`rotate_uv()/pseudo_random()`の実装
- **複雑な統合**: 4つの異なるパターンの調和的な合成
- **色彩理論**: HSV風色空間による動的な色相変化
- **時間アニメーション**: `Time.duration`による動的な表現
- **数学的美学**: 自然現象を数学関数で表現する技術

## 発展課題
余裕があれば以下にも挑戦してみてください：
1. **動きの調整**: 
   - 回転速度`time * 0.2`を変更してより速い/遅い回転
   - 波動の時間変化`time * 0.8`を調整して異なる波の動き
2. **パターン比率の実験**: 
   - 4つのパターンの統合比率（0.7, 0.3など）を変更
   - 異なるバランスによる視覚効果の違いを観察
3. **色相変化の調整**: 
   - `hue_shift = time * 0.1`を変更して色変化の速度を調整
   - 固定色相での単色表現も試行
4. **波動パターンの拡張**: 
   - 波動の周波数(8.0, 6.0)を変更してより細かい/粗い波
   - 第3の波動パターンを追加して3次元的な効果を創造

## 学習のポイント
- **統合の重要性**: 単独のパターンより複数パターンの組み合わせの美しさ
- **時間の活用**: 静的なパターンに生命力を与える時間アニメーション
- **色彩の効果**: HSV色空間による自然で美しい色の変化
- **数学の美**: 自然界のパターンが数学関数で表現できる驚異

## 次のステップへの準備
Chapter 3で習得した座標変換、極座標系、パターン統合、時間アニメーションの技術は、Chapter 4「インタラクション」での マウス入力やオーディオ連動へと発展します。数学的パターンの美しさを理解することが、より高度な表現技術への基礎となります。

