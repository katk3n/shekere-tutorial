# 演習課題 4: 最終螺旋作品の完成

## 目標
前ステップの複雑時間効果を発展させ、高度な複合螺旋パターン作品を完成させる。

## このステップで作成するもの
前ステップの複雑時間効果を基礎として、最終的な複合螺旋パターン作品を完成

## 学習内容

### 1. 前ステップからの発展
前ステップの3つの時間効果を基礎として更なる発展：
- 同心円の時間移動効果
- 放射線の回転効果
- 螺旋パターンの回転効果
- これらをより高度な構成に発展させる

### 2. 高度な複合パターンの完成
前ステップを発展させた高度な複合螺旋パターンを実現：
```wgsl
// 高度な3つの構成要素
let enhanced_spiral = sin(distance * 6.0 + angle * 3.0 + time * 2.0);  // 螺旋パターン
let enhanced_circle = sin(distance * 12.0 - time * 3.0);              // 同心円パターン
let enhanced_radial = sin(angle * 8.0 + time * 1.5);                  // 放射状パターン

// 最適化された重み付け合成
let combined_pattern = enhanced_spiral * 0.5 + enhanced_circle * 0.3 + enhanced_radial * 0.2;
```

### 3. 完成度の高い色彩システム
美しい色相回転システム：
- 時間による連続的な色相変化
- 120度位相差によるRGB生成
- 強度に応じた色彩の調整

## 実装のポイント

### 段階的な構築手順
1. **前ステップの3つの効果を継続**：基礎となる時間アニメーション
2. **パラメータの最適化**：より美しい作品レベルに調整
3. **複合パターンの完成**：螺旋・同心円・放射線の最適な組み合わせ
4. **色彩システムの完成**：美しい色相回転の実現

### 基本構造
```wgsl
@fragment
fn fs_main(in: VertexOutput) -> @location(0) vec4<f32> {
    let uv = NormalizedCoords(in.position.xy);
    let time = Time.duration;
    let distance = length(uv);
    let angle = atan2(uv.y, uv.x);
    
    // 前ステップの3つの時間効果を高度なレベルに発展
    
    // 螺旋パターン: 距離と角度を組み合わせた螺旋効果
    let spiral_frequency = 6.0;
    let spiral_speed = 2.0;
    let enhanced_spiral = sin(distance * spiral_frequency + angle * 3.0 + time * spiral_speed);
    
    // 同心円パターン: 中心から広がる円形波動
    let circle_frequency = 12.0;
    let circle_speed = 3.0;
    let enhanced_circle = sin(distance * circle_frequency - time * circle_speed);
    
    // 放射状パターン: 中心から放射状に広がる波動
    let radial_frequency = 8.0;
    let radial_speed = 1.5;
    let enhanced_radial = sin(angle * radial_frequency + time * radial_speed);
    
    // 複合パターン: 複数の波動を最適な重み付けで重ね合わせ
    let combined_pattern = enhanced_spiral * 0.5 + enhanced_circle * 0.3 + enhanced_radial * 0.2;
    
    // 距離による減衰効果（中心が明るく、端が暗く）
    let attenuation = 1.0 - distance * 0.6;
    let final_intensity = (combined_pattern + 1.0) * 0.5 * attenuation;
    
    // 時間による美しい色相変化システム
    let hue_shift = time * 0.2;
    let red = (sin(final_intensity * 6.28 + hue_shift) + 1.0) * 0.5;
    let green = (sin(final_intensity * 6.28 + hue_shift + 2.09) + 1.0) * 0.5;
    let blue = (sin(final_intensity * 6.28 + hue_shift + 4.19) + 1.0) * 0.5;
    
    // 最終的な色の計算
    let color = vec3(red, green, blue) * final_intensity;
    
    return vec4(ToLinearRgb(color), 1.0);
}
```

### 重要な新機能

#### 複合螺旋パターン（作品の核心）
```wgsl
// 高度な3つの要素
let enhanced_spiral = sin(distance * 6.0 + angle * 3.0 + time * 2.0);  // 螺旋
let enhanced_circle = sin(distance * 12.0 - time * 3.0);              // 同心円
let enhanced_radial = sin(angle * 8.0 + time * 1.5);                  // 放射

// 重み付け合成で複合パターンを作成
let combined_pattern = enhanced_spiral * 0.5 + enhanced_circle * 0.3 + enhanced_radial * 0.2;
```

#### 距離による減衰効果
```wgsl
let attenuation = 1.0 - distance * 0.6;
let final_intensity = (combined_pattern + 1.0) * 0.5 * attenuation;
```
中心が明るく、端に向かって自然に暗くなる効果

#### 色相回転システム
```wgsl
let hue_shift = time * 0.2;
let red = (sin(final_intensity * 6.28 + hue_shift) + 1.0) * 0.5;
let green = (sin(final_intensity * 6.28 + hue_shift + 2.09) + 1.0) * 0.5;
let blue = (sin(final_intensity * 6.28 + hue_shift + 4.19) + 1.0) * 0.5;
```
120度位相差による虹色効果で美しい色彩変化を実現

## 実験してみよう

### パラメータの調整

1. **螺旋の腕の数を変える**
   ```wgsl
   let spiral = sin(distance * 6.0 + angle * 2.0 + time * 2.0); // 2つ腕
   let spiral = sin(distance * 6.0 + angle * 5.0 + time * 2.0); // 5つ腕
   ```

2. **回転速度を変える**
   ```wgsl
   let spiral = sin(distance * 6.0 + angle * 3.0 + time * 1.0); // ゆっくり
   let spiral = sin(distance * 6.0 + angle * 3.0 + time * 4.0); // 高速
   ```

3. **色相変化の速度を変える**
   ```wgsl
   let hue_shift = time * 0.1; // ゆっくり変化
   let hue_shift = time * 0.5; // 速く変化
   ```

### 発展課題

#### 課題4-1: パラメータ調整
完成した作品のパラメータを変更して異なる効果を試してください：
```wgsl
// 螺旋の密度を変更
let enhanced_spiral = sin(distance * 4.0 + angle * 3.0 + time * 2.0);  // より粗い螺旋
let enhanced_spiral = sin(distance * 8.0 + angle * 3.0 + time * 2.0);  // より細かい螺旋
```

#### 課題4-2: 回転速度の調整
異なる回転速度を試してください：
```wgsl
let enhanced_spiral = sin(distance * 6.0 + angle * 3.0 + time * 1.0);  // ゆっくり回転
let enhanced_spiral = sin(distance * 6.0 + angle * 3.0 + time * 4.0);  // 高速回転
```

#### 課題4-3: 色相変化の速度調整
色の変化速度を変更してみてください：
```wgsl
let hue_shift = time * 0.1;  // ゆっくりとした色変化
let hue_shift = time * 0.5;  // 速い色変化
```

## Chapter 2 の完成
このステップで、Chapter 2「時間とアニメーション」の学習が完了します。基本的な円から始まって、同心円リング、放射線、そして最終的な螺旋アニメーションまで、段階的に一つの作品を構築しました。

## 学習のポイント
1. **段階的構築**: 各ステップで前の構造を保持しながら新要素を追加
2. **螺旋の理解**: 距離・角度・時間を組み合わせた複雑なパターン
3. **時間アニメーション**: 動的な色相変化と回転効果
4. **レイヤー合成**: 複数の効果を重ね合わせる技術