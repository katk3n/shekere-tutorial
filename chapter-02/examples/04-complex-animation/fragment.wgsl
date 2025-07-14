// Chapter 2 Example 4: 複合アニメーション
// 複数の波動、色遷移、時間変化を組み合わせた複雑なアニメーション

@fragment
fn fs_main(in: VertexOutput) -> @location(0) vec4<f32> {
    let uv = NormalizedCoords(in.position.xy);
    let time = Time.duration;
    
    // 複数の波動を組み合わせ
    let wave1 = sin(uv.x * 4.0 + time * 1.5);           // 横方向の波
    let wave2 = cos(uv.y * 6.0 + time * 2.0);           // 縦方向の波
    let wave3 = sin(length(uv) * 8.0 - time * 3.0);     // 円形の波
    
    // 波動を合成して基本パターンを作成
    let combined_wave = (wave1 + wave2 + wave3) / 3.0;
    
    // 中心からの距離と角度を計算
    let distance = length(uv);
    let angle = atan2(uv.y, uv.x);
    
    // 角度による回転効果
    let rotation = angle + time * 0.5;
    let rotated_wave = sin(rotation * 4.0) * 0.3;
    
    // 全体の強度を計算
    let intensity = (combined_wave + rotated_wave + 1.0) * 0.5;
    
    // 時間による色相の変化
    let hue_shift = time * 0.3;
    let color_base = distance * 1.5 + intensity + hue_shift;
    let hue = fract(color_base);
    
    // 複雑な色作成（三角関数を使用）
    let red = (sin(hue * 6.28) + 1.0) * 0.5;
    let green = (sin(hue * 6.28 + 2.09) + 1.0) * 0.5;   // 120度位相差
    let blue = (sin(hue * 6.28 + 4.19) + 1.0) * 0.5;    // 240度位相差
    
    // 強度による明度調整
    let brightness = intensity * (1.0 - distance * 0.4);
    let final_color = vec3(red, green, blue) * brightness;
    
    // 時間による全体の明度変化
    let global_brightness = (sin(time * 0.8) + 1.0) * 0.3 + 0.7;
    let result = final_color * global_brightness;
    
    return vec4(ToLinearRgb(result), 1.0);
}

// この例では以下の要素を組み合わせています:
// 1. 複数の波動パターン（横、縦、円形）
// 2. 角度による回転効果
// 3. 時間による色相変化
// 4. 距離による明度調整
// 5. 全体の明度変化
//
// 実験してみよう:
// 1. 各波動の係数を変更してパターンを変える
// 2. 回転速度を変更する: * 0.5 を他の値に
// 3. 色相変化の速度を変更する: * 0.3 を他の値に
// 4. 明度変化の振幅を変更する: * 0.3 + 0.7 を調整