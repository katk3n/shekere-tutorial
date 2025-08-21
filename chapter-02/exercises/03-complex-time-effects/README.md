# 演習課題 3: より複雑な時間効果の追加

## 目標
前ステップの基本アニメーションに螺旋効果と回転を追加し、複数の時間効果を組み合わせた複雑なアニメーションを学ぶ。

## このステップで作成するもの
同心円移動・放射線回転・螺旋回転が組み合わさった複雑な時間アニメーション

## 学習内容

### 1. 螺旋パターンの作成
距離・角度・時間を組み合わせた螺旋効果：
```wgsl
let spiral_pattern = sin(distance * frequency + angle * arms + time * speed);
```
- **distance * frequency**: 同心円の基本構造
- **angle * arms**: 螺旋の腕の数
- **time * speed**: 螺旋の回転速度

### 2. 回転アニメーションの追加
放射線パターンに時間による回転を追加：

#### 静的放射線（前ステップまで）
```wgsl
let radial_pattern = sin(angle * frequency);  // 静的
```

#### 回転する放射線（このステップ）
```wgsl
let radial_pattern = sin(angle * frequency + time * speed);  // 回転
```

### 3. 複数時間効果の組み合わせ
3つの異なる時間アニメーションを統合：

#### 同心円移動（前ステップから継続）
```wgsl
let circle_pattern = sin(distance * 8.0 - time * 2.0);  // 外向き移動
```

#### 放射線回転（新しく追加）
```wgsl
let radial_pattern = sin(angle * 6.0 + time * 1.0);  // 時計回り回転
```

#### 螺旋回転（新しく追加）
```wgsl
let spiral_pattern = sin(distance * 4.0 + angle * 3.0 + time * 1.5);  // 螺旋回転
```

### 4. 色相回転による動的色変化
時間による連続的な色相変化：
```wgsl
let hue_rotation = time * 0.3;
let red = (sin(intensity * 6.28 + hue_rotation) + 1.0) * 0.5;
let green = (sin(intensity * 6.28 + hue_rotation + 2.09) + 1.0) * 0.5;
let blue = (sin(intensity * 6.28 + hue_rotation + 4.19) + 1.0) * 0.5;
```
- **hue_rotation**: 色相の回転速度
- **2.09, 4.19**: 120度ずつの位相差

## 実装のポイント

### 基本構造
```wgsl
@fragment
fn fs_main(in: VertexOutput) -> @location(0) vec4<f32> {
    let uv = NormalizedCoords(in.position.xy);
    let time = Time.duration;
    let distance = length(uv);
    let angle = atan2(uv.y, uv.x);
    
    // 前ステップのアニメーション
    let circle_pattern = sin(distance * 8.0 - time * 2.0);
    
    // 新しく追加する時間効果
    let radial_pattern = sin(angle * 6.0 + time * 1.0);        // 回転
    let spiral_pattern = sin(distance * 4.0 + angle * 3.0 + time * 1.5);  // 螺旋
    
    // 3つのパターンを組み合わせ
    let combined = circle_pattern * 0.4 + radial_pattern * 0.3 + spiral_pattern * 0.3;
    
    // 色相回転
    let hue_rotation = time * 0.3;
    
    return vec4(ToLinearRgb(color), 1.0);
}
```

### 重要な概念

#### 螺旋の数学
```wgsl
sin(distance * freq + angle * arms + time * speed)
```
- **distance項**: 同心円構造
- **angle項**: 螺旋の腕
- **time項**: 回転アニメーション

#### 位相差による色相回転
```wgsl
// 120度ずつの位相差で RGB を生成
red   = sin(x + 0.0)
green = sin(x + 2.09)  // +120度
blue  = sin(x + 4.19)  // +240度
```

## 実験してみよう

### パラメータの調整

1. **螺旋の腕の数を変える**
   ```wgsl
   let spiral_pattern = sin(distance * 4.0 + angle * 2.0 + time * 1.5);  // 2つ腕
   let spiral_pattern = sin(distance * 4.0 + angle * 5.0 + time * 1.5);  // 5つ腕
   ```

2. **回転速度を変える**
   ```wgsl
   let radial_pattern = sin(angle * 6.0 + time * 0.5);  // ゆっくり回転
   let radial_pattern = sin(angle * 6.0 + time * 3.0);  // 高速回転
   ```

3. **色相回転の速度を変える**
   ```wgsl
   let hue_rotation = time * 0.1;  // ゆっくり色変化
   let hue_rotation = time * 0.8;  // 高速色変化
   ```

### 発展課題

#### 課題3-1: 逆回転の組み合わせ
時計回りと反時計回りの回転を組み合わせてみてください：
```wgsl
let clockwise = sin(angle * 6.0 + time * 1.0);
let counter_clockwise = sin(angle * 6.0 - time * 1.0);
let combined_rotation = clockwise * 0.5 + counter_clockwise * 0.5;
```

#### 課題3-2: 複数の螺旋
異なる腕の数の螺旋を重ね合わせてみてください：
```wgsl
let spiral2 = sin(distance * 4.0 + angle * 2.0 + time * 1.5);
let spiral3 = sin(distance * 6.0 + angle * 4.0 + time * 2.0);
let multi_spiral = spiral2 * 0.5 + spiral3 * 0.5;
```

#### 課題3-3: 時間による効果の切り替え
時間に応じて異なる効果に切り替えてみてください：
```wgsl
let switch_time = sin(time * 0.1) * 0.5 + 0.5;
let effect = mix(spiral_pattern, radial_pattern, switch_time);
```

## 次のステップへ
複雑な時間効果ができたら、次のステップ「04-final-spiral-artwork」で元の最終作品である複合螺旋パターンを完成させましょう。

## 学習のポイント
1. **螺旋パターン**: 距離・角度・時間の三次元的組み合わせ
2. **回転アニメーション**: 角度に時間を加えた回転効果
3. **複数時間効果**: 3つの異なる時間アニメーションの統合
4. **色相回転**: 時間による連続的な色変化
5. **複雑性の管理**: 多数のパラメータを調和させる技術
6. **Chapter 2の発展**: 時間アニメーションの応用段階