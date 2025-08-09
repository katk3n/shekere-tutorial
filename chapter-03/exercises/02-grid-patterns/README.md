# 演習 2: 格子パターン「結晶の格子構造 - Crystal Lattice」

## 目標
前ステップの螺旋パターンに格子パターンを追加し、結晶の規則的な格子構造を表現することで、fract関数とカスタム関数の使い方を習得する。

## 学習内容
- **前ステップからの継承**: Exercise 1の螺旋パターンをベース利用
- **カスタム関数作成**: `rotate_uv()`関数の実装と活用
- **繰り返しパターン**: `fract()`による格子パターンの生成
- **滑らかなエッジ**: `smoothstep()`による格子線の作成
- **パターン統合**: 螺旋と格子の調和的な合成

## 作品テーマ: 「自然界の数学的パターンの発見」シリーズ第2作
「自然の複合パターン - Natural Complex Patterns」作品への第2ステップ。前ステップの銀河の渦巻きに、結晶の美しい格子構造を追加します。自然界に存在する規則的なパターンと有機的なパターンの組み合わせを学習します。

## 技術要素
### 前ステップから継承（Exercise 1のコードを再利用）
- length/atan2 による螺旋パターン
- 極座標系による形状表現

### 新規実装技術（この演習で追加学習）
- **rotate_uv() カスタム関数**: 2D座標の回転変換
- **fract(uv * size) 格子**: 繰り返し座標による格子パターン
- **smoothstep() エッジ**: 滑らかなエッジを持つ格子線
- **max() 統合**: 水平・垂直線の統合による格子形成

## 実装手順

### 段階的コード発展（前ステップからの継承を明記）

```wgsl
// カスタム関数（新規追加）
fn rotate_uv(uv: vec2<f32>, angle: f32) -> vec2<f32> {
    let cos_a = cos(angle);
    let sin_a = sin(angle);
    return vec2(uv.x * cos_a - uv.y * sin_a, uv.x * sin_a + uv.y * cos_a);
}

@fragment
fn fs_main(in: VertexOutput) -> @location(0) vec4<f32> {
    let uv = NormalizedCoords(in.position.xy);
    
    // 【前ステップから継承】螺旋パターン
    let distance = length(uv);
    let angle = atan2(uv.y, uv.x);
    let normalized_angle = (angle + PI) / (2.0 * PI);
    let spiral_pattern = fract(normalized_angle * 3.0 + distance * 5.0);
    
    // 【新規追加】格子パターン
    let grid_size = 6.0;
    let rotated_uv = rotate_uv(uv, PI * 0.25);       // 45度回転
    let grid_uv = fract(rotated_uv * grid_size);     // 繰り返し
    let grid_thickness = 0.1;
    
    let grid_x = smoothstep(0.0, grid_thickness, grid_uv.x) * 
                 smoothstep(grid_thickness, 0.0, grid_uv.x - grid_thickness);
    let grid_y = smoothstep(0.0, grid_thickness, grid_uv.y) * 
                 smoothstep(grid_thickness, 0.0, grid_uv.y - grid_thickness);
    let grid_pattern = max(grid_x, grid_y);
    
    // 【新規追加】パターンの合成
    let combined_pattern = spiral_pattern * 0.7 + grid_pattern * 0.3;
    
    // 結晶をイメージした色彩
    let color = vec3(combined_pattern * 0.3, combined_pattern * 0.8, combined_pattern * 0.6);
    
    return vec4(ToLinearRgb(color), 1.0);
}
```

### 技術解説

#### 1. カスタム関数の作成
```wgsl
fn rotate_uv(uv: vec2<f32>, angle: f32) -> vec2<f32>
```
- 2D回転行列による座標変換
- `cos/sin`を使った標準的な回転計算
- 格子パターンに角度を付けるために使用

#### 2. 繰り返しパターンの生成
```wgsl
let grid_uv = fract(rotated_uv * grid_size);
```
- `fract()`による座標の0〜1範囲への周期化
- `grid_size`により格子の密度を制御
- 回転された座標系で格子を生成

#### 3. 滑らかな格子線の作成
```wgsl
let grid_x = smoothstep(0.0, grid_thickness, grid_uv.x) * 
             smoothstep(grid_thickness, 0.0, grid_uv.x - grid_thickness);
```
- `smoothstep()`による滑らかなエッジ
- 格子線の太さを`grid_thickness`で制御
- 水平線と垂直線を別々に計算

#### 4. パターンの統合
```wgsl
let grid_pattern = max(grid_x, grid_y);
let combined_pattern = spiral_pattern * 0.7 + grid_pattern * 0.3;
```
- `max()`で水平・垂直線を統合
- 重み付きで螺旋と格子を合成

## 完成目標
以下の技術要素を理解し実装できること：
- 前ステップのコードを継承し再利用する技術
- カスタム関数の作成と活用
- fract()による繰り返しパターンの生成
- smoothstep()による滑らかなエッジ処理
- 複数パターンの調和的な合成

## 学習のポイント
- **関数化**: 再利用可能なコードの重要性
- **座標変換**: rotate_uv()による柔軟な座標操作
- **周期化**: fract()による繰り返しパターンの数学
- **エッジ処理**: smoothstep()による美しい境界線

## 発展課題
余裕があれば以下にも挑戦してみてください：
1. **格子調整**: 
   - `grid_size`を変更してパターンの密度を調整（4.0, 8.0, 10.0など）
   - 回転角度を変更して異なる格子配置を試行
2. **線の太さ**: `grid_thickness`を調整して格子線の見た目を変更
3. **合成比率**: `0.7`と`0.3`の比率を変えて異なるバランスを実験
4. **色の実験**: 結晶をイメージした異なる色配分を試行

## 次のステップへの準備
この螺旋+格子パターンの組み合わせは、次の演習でノイズパターンが追加され、自然界の規則性と不規則性が調和した、より複雑で美しいパターンへと発展します。