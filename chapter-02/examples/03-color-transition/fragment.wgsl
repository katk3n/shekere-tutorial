// Chapter 2 Example 3: 色の遷移アニメーション
// 時間による虹色の循環アニメーション

@fragment
fn fs_main(in: VertexOutput) -> @location(0) vec4<f32> {
    let uv = NormalizedCoords(in.position.xy);
    let time = Time.duration;
    
    // 中心からの距離を計算
    let distance = length(uv);
    
    // 距離と時間を組み合わせて色相を作成
    let hue_base = distance * 2.0 + time * 0.5;
    
    // 三角関数で虹色を生成（120度位相差）
    let red = (sin(hue_base) + 1.0) * 0.5;
    let green = (sin(hue_base + 2.09) + 1.0) * 0.5;   // 120度位相差
    let blue = (sin(hue_base + 4.19) + 1.0) * 0.5;    // 240度位相差
    
    // 距離に応じて明度を調整
    let brightness = 1.0 - distance * 0.3;
    let color = vec3(red, green, blue) * brightness;
    
    return vec4(ToLinearRgb(color), 1.0);
}

// 実験してみよう:
// 1. 色の変化速度を変える: + time * 1.0 で速く
// 2. 距離係数を変える: * 3.0 で密度を上げる
// 3. 位相差を変える: + 1.57 (90度) で異なる色合い
// 4. 角度による色変化: atan2(uv.y, uv.x) を追加