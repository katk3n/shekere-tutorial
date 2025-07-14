// Chapter 3 Example 3: 放射状パターン
// atan2()関数を使って角度による放射線パターンを作成

// 定数定義
const PI = 3.14159265359;

@fragment
fn fs_main(in: VertexOutput) -> @location(0) vec4<f32> {
    // 正規化座標を取得
    let uv = NormalizedCoords(in.position.xy);
    
    // 角度を計算 (-π 〜 π)
    let angle = atan2(uv.y, uv.x);
    
    // 中心からの距離を計算
    let distance = length(uv);
    
    // 放射線パターンの作成
    let ray_count = 12.0;  // 放射線の数
    let normalized_angle = (angle + PI) / (2.0 * PI);  // 0〜1の範囲に正規化
    let ray_pattern = fract(normalized_angle * ray_count);
    
    // 放射線状のパターンに変換
    let ray_width = 0.15;  // 放射線の幅
    let ray_intensity = smoothstep(0.0, ray_width, ray_pattern) * 
                        smoothstep(1.0, 1.0 - ray_width, ray_pattern);
    
    // 距離による減衰効果
    let fade_start = 0.1;   // 減衰開始距離
    let fade_end = 0.9;     // 減衰終了距離
    let distance_fade = 1.0 - smoothstep(fade_start, fade_end, distance);
    
    // 最終的な強度の計算
    let final_intensity = ray_intensity * distance_fade;
    
    // 角度による色の変化
    let hue = normalized_angle;
    
    // 色の計算（HSV風の色空間）
    let red = (sin(hue * 6.28) + 1.0) * 0.5;
    let green = (sin(hue * 6.28 + 2.09) + 1.0) * 0.5;
    let blue = (sin(hue * 6.28 + 4.19) + 1.0) * 0.5;
    
    // 最終的な色の計算
    let color = vec3(red, green, blue) * final_intensity;
    
    return vec4(ToLinearRgb(color), 1.0);
}

// パターンの解析:
// 1. atan2(uv.y, uv.x): 角度を計算（-π〜π）
// 2. 正規化: 0〜1の範囲に変換
// 3. fract(): 放射線パターンを作成
// 4. smoothstep(): 滑らかなエッジ
// 5. 距離による減衰: 中心部が明るく、外側が暗い

// 実験してみよう:
// 1. ray_count を変える: 放射線の数を調整
// 2. ray_width を変える: 放射線の太さを調整
// 3. 減衰パラメータを変える: fade_start, fade_end
// 4. 色の変化: hue の係数を変える
// 5. 螺旋効果: normalized_angle + distance * 螺旋係数