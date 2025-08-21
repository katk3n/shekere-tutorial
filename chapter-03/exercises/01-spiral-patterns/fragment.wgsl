// 演習 1: 螺旋パターン
// 「自然界の数学的パターンの発見 - Mathematical Patterns in Nature」作品への第1ステップ
// テーマ: 「銀河の腕 - Galaxy Arms」
// 目標: length/atan2関数を使って銀河の渦巻き構造を数学的に再現する

const PI = 3.14159265359;

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
    let color = vec3(
        spiral_pattern * 0.6,         // 赤成分（紫のため中程度）
        spiral_pattern * 0.4,         // 緑成分（低め）
        spiral_pattern               // 青成分（強め）
    );
    
    return vec4(ToLinearRgb(color), 1.0);
}

// 【技術ポイント】:
// - length(uv): 中心からの距離を計算（0〜約1.4の範囲）
// - atan2(uv.y, uv.x): 角度を計算（-π〜πの範囲）
// - 角度正規化: (angle + PI) / (2.0 * PI) で0〜1の扱いやすい範囲に変換
// - fract(angle + distance): 螺旋パターンを生成する数学的手法
// - 極座標系: 距離と角度による座標表現の基礎

// 【実験してみよう】:
// 1. 螺旋の腕の数を変える: spiral_frequency を 2.0, 4.0, 6.0 など
// 2. 巻き具合を変える: spiral_tightness を 3.0, 8.0, 10.0 など  
// 3. 色の配分を変える: 赤成分を強くして銀河の色を変化
// 4. 逆螺旋: normalized_angle * frequency - distance * tightness で逆向き