// Chapter 3 Example 2: 円形パターン
// length()関数を使って中心からの距離による同心円パターンを作成

@fragment
fn fs_main(in: VertexOutput) -> @location(0) vec4<f32> {
    // 正規化座標を取得
    let uv = NormalizedCoords(in.position.xy);
    
    // 中心からの距離を計算
    let distance = length(uv);
    
    // 同心円パターンの作成
    let ring_count = 8.0;  // 同心円の数
    let ring_pattern = fract(distance * ring_count);
    
    // リング状のパターンに変換
    // smoothstepを使って滑らかなエッジを作成
    let ring_width = 0.1;  // リングの幅
    let ring_intensity = smoothstep(0.0, ring_width, ring_pattern) * 
                        smoothstep(1.0, 1.0 - ring_width, ring_pattern);
    
    // 中心からの距離による色の変化
    let hue = distance * 0.5;  // 距離に応じた色相
    
    // 色の計算（HSV風の色空間）
    let red = (sin(hue * 6.28) + 1.0) * 0.5;
    let green = (sin(hue * 6.28 + 2.09) + 1.0) * 0.5;  // 120度位相差
    let blue = (sin(hue * 6.28 + 4.19) + 1.0) * 0.5;   // 240度位相差
    
    // 最終的な色の計算
    let color = vec3(red, green, blue) * ring_intensity;
    
    return vec4(ToLinearRgb(color), 1.0);
}

// パターンの解析:
// 1. distance = length(uv): 中心からの距離（0.0〜約1.4）
// 2. fract(distance * ring_count): 距離を周期化して0〜1の範囲に
// 3. smoothstep(): 滑らかなエッジでリング状パターンを作成
// 4. 色相変化: 距離に応じて色が変化

// 実験してみよう:
// 1. ring_count を変える: 同心円の数を調整
// 2. ring_width を変える: リングの太さを調整
// 3. hue の係数を変える: 色の変化速度を調整
// 4. 距離の変形: pow(distance, 2.0) などで非線形変化