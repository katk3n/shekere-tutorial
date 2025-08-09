# 演習 1: 螺旋パターン「銀河の腕 - Galaxy Arms」

## 目標
length/atan2関数を使って銀河の渦巻き構造を数学的に再現し、Chapter 3の核心技術である極座標系（距離・角度）による表現方法を習得する。

## 学習内容
- **distance関数**: `length()`による中心からの距離計算
- **angle関数**: `atan2()`による角度計算と正規化
- **極座標系**: 距離と角度による座標表現の基礎
- **螺旋パターン**: 角度と距離を組み合わせた螺旋形状の生成
- **fract関数**: 周期化による繰り返しパターンの作成

## 作品テーマ: 「自然界の数学的パターンの発見」シリーズ第1作
この演習では、「自然の複合パターン - Natural Complex Patterns」作品への第1ステップとして、銀河の美しい渦巻き構造を数学的に再現します。宇宙に存在する螺旋銀河の腕の構造を、シンプルな数学関数で表現する方法を学びます。

## 技術要素
### 新規実装技術（この演習で学ぶ内容）
- **`length(uv)`**: 中心からの距離計算（0〜約1.4の範囲）
- **`atan2(uv.y, uv.x)`**: 角度計算（-π〜π範囲）
- **角度の正規化**: `(angle + PI) / (2.0 * PI)` で0〜1の扱いやすい範囲に変換
- **`fract(angle + distance)`**: 螺旋パターン生成の数学的手法
- **極座標表現**: デカルト座標系(x,y)から極座標系(r,θ)への変換

## 実装コード（完成版）

```wgsl
@fragment
fn fs_main(in: VertexOutput) -> @location(0) vec4<f32> {
    let uv = NormalizedCoords(in.position.xy);
    
    // 距離と角度の計算
    let distance = length(uv);
    let angle = atan2(uv.y, uv.x);
    
    // 角度を0〜1範囲に正規化
    let normalized_angle = (angle + PI) / (2.0 * PI);
    
    // 螺旋パターンの作成
    let spiral_frequency = 3.0;  // 螺旋の腕の数
    let spiral_tightness = 5.0;  // 螺旋の巻き具合
    let spiral_pattern = fract(normalized_angle * spiral_frequency + distance * spiral_tightness);
    
    // 銀河をイメージした青〜紫系の色彩
    let color = vec3(spiral_pattern * 0.6, spiral_pattern * 0.4, spiral_pattern);
    
    return vec4(ToLinearRgb(color), 1.0);
}
```

### 技術解説

#### 1. 極座標系への変換
```wgsl
let distance = length(uv);      // 中心からの距離
let angle = atan2(uv.y, uv.x);  // 角度（-π〜π）
```
- `length()`: ベクトルの大きさ（原点からの距離）
- `atan2()`: 逆正接関数で角度を求める（4象限対応）

#### 2. 角度の正規化
```wgsl
let normalized_angle = (angle + PI) / (2.0 * PI);
```
- `-π〜π`の範囲を`0〜1`の扱いやすい範囲に変換
- 色や他の計算で使いやすくなる

#### 3. 螺旋パターンの生成
```wgsl
let spiral_pattern = fract(normalized_angle * spiral_frequency + distance * spiral_tightness);
```
- `normalized_angle * frequency`: 角度方向の繰り返し（腕の数）
- `distance * tightness`: 距離による螺旋の巻き具合
- `fract()`: 0〜1の範囲に周期化して螺旋パターンを作成

## 完成目標
以下の技術要素を理解し実装できること：
- length()関数による距離計算
- atan2()関数による角度計算と正規化
- 極座標系による形状表現の基礎
- 螺旋パターンの数学的生成

## 学習のポイント
- **極座標系**: デカルト座標(x,y)と極座標(r,θ)の関係を理解
- **周期化**: fract()による0〜1範囲への変換の重要性
- **パラメータ調整**: frequency/tightnessによる形状制御
- **自然との対応**: 数学関数が自然現象を表現する美しさ

## 発展課題
余裕があれば以下にも挑戦してみてください：
1. **螺旋パラメータの調整**: 
   - `spiral_frequency`を変えて腕の数を調整（2.0, 4.0, 6.0など）
   - `spiral_tightness`を変えて巻き具合を調整（3.0, 8.0, 10.0など）
2. **色彩の実験**: 赤成分を強くして異なる銀河の色を表現
3. **逆螺旋**: `+ distance`を`- distance`にして逆向きの螺旋を作成
4. **複数螺旋**: 異なるパラメータの螺旋パターンを重ね合わせ

## 次のステップへの準備
この螺旋パターンは、次の演習で格子パターンと組み合わされ、より複雑で美しい自然のパターンへと発展します。極座標系の基礎をしっかり理解することが重要です。